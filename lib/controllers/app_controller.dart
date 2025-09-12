import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/grpc_service.dart';
import '../services/mqtt_service.dart';
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

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  double get totalAmount => _totalAmount.value;
  int get bagCount => _bagCount.value;
  String get cardNumber => _cardNumber.value;
  String get customerName => _customerName.value;
  int get loyaltyPoints => _loyaltyPoints.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;

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
  void onClose() {
    _alertSubscription?.cancel();
    _grpcService.disconnect();
    _mqttService.disconnect();
    super.onClose();
  }

  Future<void> _initializeServices() async {
    try {
      _logger.i('Initializing services...');
      
      // Connect to gRPC
      final grpcConnected = await _grpcService.connect();
      _updateGrpcStatus(grpcConnected ? ConnectionStatus.connected : ConnectionStatus.error);

      // Connect to MQTT
      final mqttConnected = await _mqttService.connect();
      _updateMqttStatus(mqttConnected ? ConnectionStatus.connected : ConnectionStatus.error);

      // If both connections fail, go to error screen
      if (!grpcConnected && !mqttConnected) {
        _navigateToScreen(AppScreen.error, errorMessage: 'Connection failed');
      }
    } catch (e) {
      _logger.e('Service initialization failed: $e');
      _navigateToScreen(AppScreen.error, errorMessage: e.toString());
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
  void navigateToStart() {
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

  // Item management
  void addScannedItem(String itemId) {
    _scannedItems.add(itemId);
    _totalAmount.value += 10.0; // Mock price
    _logger.i('Added item: $itemId, Total: ${_totalAmount.value}');
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
    final isRunning = await _grpcService.isServerRunning();
    
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
}
