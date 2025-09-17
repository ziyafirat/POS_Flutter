import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/grpc_service.dart';
import '../services/mqtt_service.dart';
import '../test/grpc_test.dart';
import 'language_controller.dart';

class AppController extends GetxController {
  final Logger _logger = Logger();
  final GrpcService _grpcService = GrpcService();
  final MqttService _mqttService = MqttService();

  // Reactive state
  final Rx<AppState> _appState = AppState(
    currentScreen: AppScreen.start,
    grpcStatus: ConnectionStatus.disconnected,
    mqttStatus: ConnectionStatus.disconnected,
    isAlertActive: false,
    lastUpdate: DateTime.now(),
  ).obs;

  final Rx<AlertMessage?> _currentAlert = Rx<AlertMessage?>(null);
  final RxList<String> _scannedItems = <String>[].obs;
  final RxDouble _totalAmount = 0.0.obs;
  final RxInt _bagCount = 0.obs;
  final RxString _cardNumber = ''.obs;
  final RxString _customerName = ''.obs;
  final RxInt _loyaltyPoints = 0.obs;
  final RxString _currentTransactionId = ''.obs;
  
  // Persistent gRPC connection for transaction session
  GrpcConnection? _activeGrpcConnection;

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  double get totalAmount => _totalAmount.value;
  int get bagCount => _bagCount.value;
  String get cardNumber => _cardNumber.value;
  String get customerName => _customerName.value;
  int get loyaltyPoints => _loyaltyPoints.value;
  String get currentTransactionId => _currentTransactionId.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;
  bool get hasActiveTransaction => _currentTransactionId.value.isNotEmpty && _activeGrpcConnection != null;

  // Stream subscriptions
  StreamSubscription<AlertMessage>? _alertSubscription;

  @override
  void onInit() {
    super.onInit();
    // Initialize language controller
    Get.put(LanguageController());
    _initializeServices();
    _setupAlertListener();
  }

  @override
  void onClose() async {
    _alertSubscription?.cancel();
    _grpcService.disconnect();
    _mqttService.disconnect();
    
    // Cleanup active gRPC connection
    await _cleanupGrpcConnection();
    
    super.onClose();
  }

  Future<void> _initializeServices() async {
    try {
      _logger.i('Initializing services...');
      
      // Connect to gRPC using the real GrpcConnection approach
      final grpcConnected = await _connectToGrpcServer();
      _updateGrpcStatus(grpcConnected ? ConnectionStatus.connected : ConnectionStatus.error);

      // Connect to MQTT
      final mqttConnected = await _mqttService.connect();
      _updateMqttStatus(mqttConnected ? ConnectionStatus.connected : ConnectionStatus.error);

      // Don't go to error screen if gRPC fails, just log it
      // The user can still use the app and connect later via assistant
      if (!grpcConnected) {
        _logger.w('gRPC connection failed at startup, but app can still be used');
      }
      if (!mqttConnected) {
        _logger.w('MQTT connection failed at startup');
      }
    } catch (e) {
      _logger.e('Service initialization failed: $e');
      // Don't navigate to error screen, just log and continue
      _logger.w('Continuing with app startup despite service initialization errors');
    }
  }

  Future<bool> _connectToGrpcServer() async {
    try {
      _logger.i('🔌 Creating PERSISTENT gRPC connection at app startup...');
      
      // Create the SINGLE persistent gRPC connection for the entire app lifecycle
      _activeGrpcConnection = GrpcConnection("localhost", 50051);
      await _activeGrpcConnection!.initialize(GrpcLane(
        companyId: "company",
        storeId: "paladium",
        laneId: "lane-05",
        userName: "user",
        password: "password",
      ));
      
      _logger.i('✅ PERSISTENT gRPC connection established at startup');
      _logger.i('🔗 Connection will remain OPEN for entire app lifecycle');
      _logger.i('📊 Connection hash: ${_activeGrpcConnection.hashCode}');
      
      return true;
    } catch (e) {
      _logger.e('❌ Failed to create persistent gRPC connection: $e');
      _activeGrpcConnection = null;
      return false;
    }
  }

  void _setupAlertListener() {
    _alertSubscription = _mqttService.alertStream.listen((alert) {
      _logger.i('Received alert: ${alert.title}');
      _currentAlert.value = alert;
      _updateAppState(isAlertActive: true);
      
      // Navigate to alert screen if not already there
      if (_appState.value.currentScreen != AppScreen.alert) {
        _navigateToScreen(AppScreen.alert);
      }
    });
  }

  void _updateAppState({
    AppScreen? currentScreen,
    ConnectionStatus? grpcStatus,
    ConnectionStatus? mqttStatus,
    bool? isAlertActive,
    String? errorMessage,
  }) {
    final newState = _appState.value.copyWith(
      currentScreen: currentScreen ?? _appState.value.currentScreen,
      grpcStatus: grpcStatus ?? _appState.value.grpcStatus,
      mqttStatus: mqttStatus ?? _appState.value.mqttStatus,
      isAlertActive: isAlertActive ?? _appState.value.isAlertActive,
      errorMessage: errorMessage ?? _appState.value.errorMessage,
      lastUpdate: DateTime.now(),
    );
    _appState.value = newState;
    _appState.refresh();
  }

  void _updateGrpcStatus(ConnectionStatus status) {
    _updateAppState(grpcStatus: status);
  }

  void _updateMqttStatus(ConnectionStatus status) {
    _updateAppState(mqttStatus: status);
  }

  void _navigateToScreen(AppScreen screen, {String? errorMessage}) {
    _logger.i('_navigateToScreen called with screen: $screen');
    _updateAppState(
      currentScreen: screen,
      errorMessage: errorMessage,
    );
    _logger.i('App state updated. Current screen: ${_appState.value.currentScreen}');
  }

  // Navigation methods
  Future<void> navigateToStart() async {
    // End current transaction when going back to start
    _logger.i('🏠 [NAV] Navigating to start - ending current transaction...');
    await _endCurrentTransaction();
    _navigateToScreen(AppScreen.start);
  }

  void navigateToItemScan() {
    _logger.i('Attempting to navigate to item scan...');
    _logger.i('isAlertActive: $isAlertActive');
    if (isAlertActive) {
      _logger.w('Cannot navigate to item scan - alert is active');
      return;
    }
    _logger.i('Calling _navigateToScreen with AppScreen.itemScan');
    _navigateToScreen(AppScreen.itemScan);
  }

  void navigateToPayment() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to payment - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.payment);
  }

  void navigateToProcessing() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to processing - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.processing);
  }

  void navigateToPrinting() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to printing - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.printing);
  }

  void navigateToError({String? errorMessage}) {
    _navigateToScreen(AppScreen.error, errorMessage: errorMessage);
  }

  void navigateToAlert() {
    _navigateToScreen(AppScreen.alert);
  }

  void navigateToAssistant() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to assistant - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.assistant);
  }

  // Transaction management
  Future<void> startTransaction() async {
    try {
      _logger.i('🚀 [START] Starting new transaction...');
      
      // Clear previous transaction data (but keep connection open)
      _logger.i('🧹 [START] Clearing previous transaction data...');
      clearScannedItems();
      clearCardInfo();
      clearBags();
      _currentTransactionId.value = '';
      
      // Check if we have the persistent gRPC connection
      if (_activeGrpcConnection == null) {
        _logger.e('❌ [START] No persistent gRPC connection available');
        throw Exception('gRPC connection not available. Please restart the app.');
      }
      
      _logger.i('✅ [START] Using PERSISTENT gRPC connection established at startup');
      _logger.i('📊 [START] Connection hash: ${_activeGrpcConnection.hashCode}');
      
      // Generate unique order ID
      final scoOrderId = 'SCO_ORDER_${DateTime.now().millisecondsSinceEpoch}';
      _logger.i('🆔 [START] Generated SCO Order ID: $scoOrderId');
      
      // Create transaction using the PERSISTENT connection (established at startup)
      _logger.i('📝 [START] Creating transaction on PERSISTENT connection...');
      final posTxId = await _activeGrpcConnection!.createTransaction(scoOrderId);
      _currentTransactionId.value = posTxId;
      
      _logger.i('🎉 [SUCCESS] Transaction created successfully!');
      _logger.i('🆔 [SUCCESS] POS Transaction ID: $posTxId');
      _logger.i('🔗 [SUCCESS] Using SAME persistent connection for entire app session');
      
      // Update gRPC status to connected since we successfully created transaction
      _updateGrpcStatus(ConnectionStatus.connected);
      
      // Navigate to item scan page on success
      navigateToItemScan();
      
    } catch (e) {
      _logger.e('💥 [ERROR] Failed to start transaction: $e');
      _logger.e('🔍 [ERROR] Error type: ${e.runtimeType}');
      // Update gRPC status to error (but don't close connection)
      _updateGrpcStatus(ConnectionStatus.error);
      navigateToError(errorMessage: 'Failed to start transaction: $e');
    }
  }

  // Helper method to end current transaction (but keep connection open)
  Future<void> _endCurrentTransaction() async {
    _logger.i('🧹 [CLEANUP] Ending current transaction (keeping connection open)...');
    
    // Clear transaction data only
    clearScannedItems();
    clearCardInfo();
    clearBags();
    _currentTransactionId.value = '';
    _logger.i('🧹 [CLEANUP] Cleared transaction data');
    _logger.i('🔗 [CLEANUP] Persistent gRPC connection remains OPEN');
    
    // DO NOT cleanup the gRPC connection - it stays open for app lifecycle
  }

  // Helper method to cleanup gRPC connection (only called when app closes)
  Future<void> _cleanupGrpcConnection() async {
    if (_activeGrpcConnection != null) {
      try {
        _logger.i('🔌 [CLEANUP] Shutting down persistent gRPC connection (app closing)...');
        await _activeGrpcConnection!.shutdown();
        _logger.i('✅ [CLEANUP] Persistent gRPC connection closed successfully');
      } catch (e) {
        _logger.w('⚠️ [CLEANUP] Error shutting down gRPC connection: $e');
      } finally {
        _activeGrpcConnection = null;
        _logger.i('🗑️ [CLEANUP] gRPC connection object cleared');
      }
    } else {
      _logger.i('ℹ️ [CLEANUP] No persistent gRPC connection to cleanup');
    }
  }

  // Item management
  void addScannedItem(String itemId) {
    _scannedItems.add(itemId);
    _totalAmount.value += 10.0; // Mock price
    _logger.i('Added item: $itemId, Total: ${_totalAmount.value}');
  }

  Future<void> addItemViaGrpc(String barcode, {int quantity = 1}) async {
    try {
      _logger.i('🔍 [ITEM] Adding item via PERSISTENT gRPC connection...');
      _logger.i('🔍 [ITEM] Barcode: $barcode, Quantity: $quantity');
      _logger.i('🔍 [ITEM] Current transaction ID: "${_currentTransactionId.value}"');
      
      // Check if we have an active transaction and the persistent connection
      if (_currentTransactionId.value.isEmpty) {
        _logger.e('❌ [ITEM] Cannot add item - no active transaction ID');
        throw Exception('No active transaction. Please start a new transaction first.');
      }
      
      if (_activeGrpcConnection == null) {
        _logger.e('❌ [ITEM] Cannot add item - no persistent gRPC connection');
        throw Exception('No persistent gRPC connection. Please restart the app.');
      }
      
      _logger.i('✅ [ITEM] Using SAME persistent connection from startup');
      _logger.i('📊 [ITEM] Connection hash: ${_activeGrpcConnection.hashCode}');
      _logger.i('🔗 [ITEM] Connection details: ${_activeGrpcConnection!.host}:${_activeGrpcConnection!.port}');
      
      // Add item by quantity using the SAME persistent connection
      _logger.i('📦 [ITEM] Calling addItemByQuantity on PERSISTENT connection...');
      await _activeGrpcConnection!.addItemByQuantity(_currentTransactionId.value, barcode, quantity);
      _logger.i('✅ [ITEM] addItemByQuantity call completed successfully');
      
      // Add to local list for UI display
      _scannedItems.add(barcode);
      _logger.i('✅ [ITEM] Added to local scanned items list');
      
      // Get updated totals from server using the SAME persistent connection
      _logger.i('💰 [ITEM] Getting updated totals from SAME persistent connection...');
      final totals = await _activeGrpcConnection!.getTotals(_currentTransactionId.value);
      _totalAmount.value = totals.total;
      _logger.i('✅ [ITEM] Updated totals received: ${totals.total}');
      
      _logger.i('🎉 [SUCCESS] Item added successfully via PERSISTENT gRPC connection: $barcode');
      _logger.i('💰 [SUCCESS] Updated total: ${totals.total}');
      
    } catch (e) {
      _logger.e('💥 [ERROR] Failed to add item via gRPC: $e');
      _logger.e('🔍 [ERROR] Error type: ${e.runtimeType}');
      _logger.e('🔍 [ERROR] Full error details: $e');
      
      // If the error suggests the transaction is invalid, clear our state
      if (e.toString().contains('No active transaction found') || 
          e.toString().contains('POS_SERVICE_EXCEPTION') ||
          e.toString().contains('does not match the active transaction')) {
        _logger.w('⚠️ [RECOVERY] Transaction appears to be invalid on server, clearing local state');
        await _endCurrentTransaction();
        throw Exception('Transaction expired. Please start a new transaction.');
      }
      
      throw Exception('Failed to add item: $e');
    }
  }

  // Debug method to check transaction status
  void debugTransactionStatus() {
    _logger.i('🔍 [DEBUG] === TRANSACTION STATUS ===');
    _logger.i('🔍 [DEBUG] Transaction ID: "${_currentTransactionId.value}"');
    _logger.i('🔍 [DEBUG] Transaction ID empty: ${_currentTransactionId.value.isEmpty}');
    _logger.i('🔍 [DEBUG] Active gRPC connection exists: ${_activeGrpcConnection != null}');
    _logger.i('🔍 [DEBUG] Has active transaction: $hasActiveTransaction');
    _logger.i('🔍 [DEBUG] gRPC status: ${_appState.value.grpcStatus}');
    if (_activeGrpcConnection != null) {
      _logger.i('🔍 [DEBUG] Connection host: ${_activeGrpcConnection!.host}');
      _logger.i('🔍 [DEBUG] Connection port: ${_activeGrpcConnection!.port}');
    }
    _logger.i('🔍 [DEBUG] === END STATUS ===');
  }

  // Test method to reproduce the exact working scenario
  Future<void> testTransactionFlow() async {
    try {
      _logger.i('🧪 [TEST] Starting transaction flow test...');
      
      // Create fresh connection (exactly like working example)
      final grpc = GrpcConnection("localhost", 50051);
      
      _logger.i('🧪 [TEST] Initializing connection...');
      await grpc.initialize(GrpcLane(
        companyId: "company",
        storeId: "paladium",
        laneId: "lane-05",
        userName: "user",
        password: "password",
      ));
      
      _logger.i('🧪 [TEST] Creating transaction...');
      final txId = await grpc.createTransaction("SCO_ORDER_TEST_${DateTime.now().millisecondsSinceEpoch}");
      _logger.i('🧪 [TEST] Transaction created: $txId');
      
      _logger.i('🧪 [TEST] Adding item...');
      await grpc.addItemByQuantity(txId, "NORMAL_ITEM_WITH_NO_WEIGHT_DEFINED", 1);
      _logger.i('🧪 [TEST] Item added successfully');
      
      _logger.i('🧪 [TEST] Getting totals...');
      final totals = await grpc.getTotals(txId);
      _logger.i('🧪 [TEST] Totals: ${totals.total}');
      
      _logger.i('🧪 [TEST] Shutting down...');
      await grpc.shutdown();
      
      _logger.i('✅ [TEST] Transaction flow test completed successfully!');
      
    } catch (e) {
      _logger.e('❌ [TEST] Transaction flow test failed: $e');
    }
  }

  // Test our persistent connection immediately after creation
  Future<void> testPersistentConnection() async {
    try {
      _logger.i('🧪 [PERSIST] Testing persistent connection immediately...');
      
      if (_activeGrpcConnection == null || _currentTransactionId.value.isEmpty) {
        _logger.e('❌ [PERSIST] No active connection or transaction');
        return;
      }
      
      _logger.i('🧪 [PERSIST] Using connection hash: ${_activeGrpcConnection.hashCode}');
      _logger.i('🧪 [PERSIST] Transaction ID: ${_currentTransactionId.value}');
      
      _logger.i('🧪 [PERSIST] Adding test item immediately...');
      await _activeGrpcConnection!.addItemByQuantity(
        _currentTransactionId.value, 
        "NORMAL_ITEM_WITH_NO_WEIGHT_DEFINED", 
        1
      );
      _logger.i('✅ [PERSIST] Item added successfully with persistent connection!');
      
    } catch (e) {
      _logger.e('❌ [PERSIST] Persistent connection test failed: $e');
    }
  }

  void clearScannedItems() {
    _scannedItems.clear();
    _totalAmount.value = 0.0;
    _logger.i('Cleared scanned items');
  }

  void removeScannedItem(int index) {
    if (index >= 0 && index < _scannedItems.length) {
      _scannedItems.removeAt(index);
      _totalAmount.value -= 10.0; // Mock price
      _logger.i('Removed item at index $index, Total: ${_totalAmount.value}');
    }
  }

  // Card management
  void setCardInfo(String cardNumber) {
    _cardNumber.value = cardNumber;
    // Mock customer data based on card number
    if (cardNumber.length >= 4) {
      _customerName.value = 'Customer ${cardNumber.substring(0, 4)}';
      _loyaltyPoints.value = int.tryParse(cardNumber.substring(0, 4)) ?? 0;
    } else {
      _customerName.value = 'Customer $cardNumber';
      _loyaltyPoints.value = 0;
    }
    _logger.i('Card set: $cardNumber, Customer: ${_customerName.value}, Points: ${_loyaltyPoints.value}');
  }

  void clearCardInfo() {
    _cardNumber.value = '';
    _customerName.value = '';
    _loyaltyPoints.value = 0;
    _logger.i('Card info cleared');
  }

  // Bag management
  void addBag() {
    _bagCount.value++;
    _totalAmount.value += 0.25; // Mock bag price
    _logger.i('Added bag, Count: ${_bagCount.value}, Total: ${_totalAmount.value}');
  }

  void removeBag() {
    if (_bagCount.value > 0) {
      _bagCount.value--;
      _totalAmount.value -= 0.25; // Mock bag price
      _logger.i('Removed bag, Count: ${_bagCount.value}, Total: ${_totalAmount.value}');
    }
  }

  void clearBags() {
    _totalAmount.value -= (_bagCount.value * 0.25); // Remove bag costs
    _bagCount.value = 0;
    _logger.i('Cleared bags');
  }

  // Alert management
  void dismissAlert() {
    _currentAlert.value = null;
    _updateAppState(isAlertActive: false);
    _logger.i('Alert dismissed');
  }

  // Payment processing
  Future<void> processPayment(String paymentMethod) async {
    try {
      _logger.i('Processing payment: $paymentMethod');
      
      // Navigate to processing screen
      navigateToProcessing();
      
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));
      
      // Navigate to printing screen
      navigateToPrinting();
      
      // Clear items after successful payment
      clearScannedItems();
      
    } catch (e) {
      _logger.e('Payment processing failed: $e');
      navigateToError(errorMessage: 'Payment failed: $e');
    }
  }

  // Assistant methods
  Future<void> testGrpcConnection() async {
    final success = await _grpcService.testConnection();
    _logger.i('gRPC test connection: $success');
  }

  Future<void> testMqttConnection() async {
    final success = await _mqttService.testConnection();
    _logger.i('MQTT test connection: $success');
  }

  Future<void> runGrpcHappyTestScenario() async {
    _logger.i('🚀 Starting comprehensive gRPC happy test scenario...');
    final success = await _grpcService.runHappyTestScenario();
    
    // Log the results instead of showing snackbar to avoid overlay issues
    if (success) {
      _logger.i('🎉 Happy Test Passed! gRPC happy test scenario completed successfully');
    } else {
      _logger.w('⚠️ Happy Test Failed: gRPC happy test scenario failed');
    }
    
    // Try to show snackbar safely
    try {
      if (Get.context != null) {
        if (success) {
          Get.snackbar(
            '🎉 Happy Test Passed!',
            'gRPC happy test scenario completed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        } else {
          Get.snackbar(
            '⚠️ Happy Test Failed',
            'gRPC happy test scenario failed',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      }
    } catch (e) {
      _logger.w('Could not show snackbar: $e');
    }
  }

  Future<void> runGrpcQuickHealthCheck() async {
    _logger.i('⚡ Running gRPC quick health check...');
    final isHealthy = await _grpcService.quickHealthCheck();
    
    // Log the results instead of showing snackbar to avoid overlay issues
    if (isHealthy) {
      _logger.i('✅ Health Check Passed: gRPC service is healthy and responsive');
    } else {
      _logger.w('❌ Health Check Failed: gRPC service health check failed');
    }
    
    // Try to show snackbar safely
    try {
      if (Get.context != null) {
        if (isHealthy) {
          Get.snackbar(
            '✅ Health Check Passed',
            'gRPC service is healthy and responsive',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            '❌ Health Check Failed',
            'gRPC service health check failed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      _logger.w('Could not show snackbar: $e');
    }
  }

  Future<void> testServerRunning() async {
    _logger.i('🔍 Testing if server is running...');
    final isRunning = _grpcService.isServerRunning();
    
    if (isRunning) {
      _logger.i('✅ Server is running at localhost:50051');
    } else {
      _logger.e('❌ Server is not running or not reachable at localhost:50051');
    }
    
    // Try to show snackbar safely
    try {
      if (Get.context != null) {
        if (isRunning) {
          Get.snackbar(
            '✅ Server Running',
            'gRPC server is running at localhost:50051',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            '❌ Server Not Running',
            'gRPC server is not running at localhost:50051',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      _logger.w('Could not show snackbar: $e');
    }
  }

  void simulateAlert() {
    _mqttService.simulateAlert();
  }

  void _showSnackbarSafely(String title, String message, Color backgroundColor) {
    try {
      // Check if we have a valid context and overlay
      if (Get.context != null && Get.context!.mounted) {
        Get.snackbar(
          title,
          message,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Fallback to logging if UI is not ready
        _logger.i('UI not ready for snackbar: $title - $message');
      }
    } catch (e) {
      // Fallback to logging if snackbar fails
      _logger.w('Snackbar failed: $e - $title - $message');
    }
  }

  Future<void> runGrpcTest() async {
    _logger.i('🚀 Starting gRPC Connection Test...');
    
    try {
      // Import the GrpcConnection class
      // final app = GrpcConnection("localhost", 50051);
      
      // // Initialize with lane configuration
      // await app.initialize(GrpcLane(
      //   companyId: "pos",
      //   storeId: "paladium",
      //   laneId: "lane-05",
      //   userName: "user",
      //   password: "password",
      // ));

      // // Create transaction
      // final txId = await app.createTransaction("SCO_ORDER_12345");
      
      // // Set customer
      // await app.setCustomer(txId, "5322100000");
      
      // // Add item by quantity
      // await app.addItemByQuantity(txId, "NORMAL_ITEM_WITH_NO_WEIGHT_DEFINED", 2);
      
      // // Get totals
      // final totals = await app.getTotals(txId);
      // _logger.i("Balance due: ${totals.balanceDue}");
      
      // // Shutdown
      // await app.shutdown();


      final grpc = GrpcConnection("localhost", 50051);

await grpc.initialize(GrpcLane(
  companyId: "company",
  storeId: "paladium",
  laneId: "lane-05",
  userName: "user",
  password: "password"));

final txId = await grpc.createTransaction("SCO_ORDER_12345");
// await grpc.setCustomer(txId, "5322100000");
await grpc.addItemByQuantity(txId, "NORMAL_ITEM_WITH_NO_WEIGHT_DEFINED", 2);

final totals = await grpc.getTotals(txId);
print("Balance due: ${totals.balanceDue}");

await grpc.shutdown();

      
      _logger.i('✅ gRPC Connection Test completed successfully');
      
      // Show success snackbar safely
      _showSnackbarSafely(
        'gRPC Test Passed',
        'gRPC Connection Test completed successfully',
        Colors.green,
      );
      
    } catch (e) {
      _logger.e('❌ gRPC Connection Test failed: $e');
      
      // Show error snackbar safely
      _showSnackbarSafely(
        '❌ gRPC Test Failed',
        'gRPC Connection Test failed: $e',
        Colors.red,
      );
    }
  }

}
