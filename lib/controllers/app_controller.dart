import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/mqtt_service.dart';
import '../services/web_api_service.dart';
import '../services/scanner_service.dart';
import 'language_controller.dart';

class AppController extends GetxController {
  final Logger _logger = Logger();
  late final MqttService _mqttService;
  late final ScannerService _scannerService;

  // Reactive state
  final Rx<AppState> _appState = AppState(
    currentScreen: AppScreen.start,
    mqttStatus: ConnectionStatus.disconnected,
    isAlertActive: false,
    lastUpdate: DateTime.now(),
  ).obs;

  final Rx<AlertMessage?> _currentAlert = Rx<AlertMessage?>(null);
  final RxList<String> _scannedItems = <String>[].obs;
  final RxDouble _totalAmount = 0.0.obs;
  final RxString _terminalId = '500'.obs;
  final RxBool _isProcessingPayment = false.obs;

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  double get totalAmount => _totalAmount.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;
  String? get terminalId => _terminalId.value;
  RxBool get isProcessingPayment => _isProcessingPayment;

  // Stream subscriptions
  StreamSubscription<AlertMessage>? _alertSubscription;
  StreamSubscription<String>? _scannerSubscription;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    Get.put(LanguageController());
    Get.put(WebApiService());
    Get.put(ScannerService());
    _mqttService = Get.find<MqttService>(); // Get the already registered MQTT service
    _scannerService = Get.find<ScannerService>(); // Get the scanner service
    _initializeServices();
    _setupAlertListener();
    _setupScannerListener();
  }

  @override
  void onClose() {
    _alertSubscription?.cancel();
    _scannerSubscription?.cancel();
    _mqttService.disconnect();
    _scannerService.stopListening();
    
    // Stop Web API Service
    try {
      final webApiService = Get.find<WebApiService>();
      webApiService.stopApiLoop();
    } catch (e) {
      _logger.w('WebApiService not found or already closed: $e');
    }
    
    super.onClose();
  }

  Future<void> _initializeServices() async {
    try {
      _logger.i('Initializing services...');
      
      // Connect to MQTT
      final mqttConnected = await _mqttService.connect();
      _updateMqttStatus(mqttConnected ? ConnectionStatus.connected : ConnectionStatus.error);

      // Start Web API Service
      final webApiService = Get.find<WebApiService>();
      webApiService.startApiLoop();
      _logger.i('Web API Service started');

      // Start Scanner Service
      _scannerService.startListening();
      _logger.i('Scanner Service started');

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
      
      // Navigate to appropriate alert screen based on alert type
      if (alert.type == AlertType.fraud) {
        // For fraud alerts, navigate to fraud alert page
        if (_appState.value.currentScreen != AppScreen.fraudAlert) {
          _navigateToScreen(AppScreen.fraudAlert);
        }
      } else {
        // For other alerts, navigate to regular alert page
        if (_appState.value.currentScreen != AppScreen.alert) {
          _navigateToScreen(AppScreen.alert);
        }
      }
    });
  }

  void _setupScannerListener() {
    _scannerSubscription = _scannerService.scannerStream.listen((scannedCode) {
      _logger.i('Received scanned barcode: $scannedCode');
      _handleScannedBarcode(scannedCode);
    });
  }

  void _handleScannedBarcode(String barcode) {
    try {
      _logger.i('🔍 PROCESSING SCANNED BARCODE');
      _logger.i('📊 Barcode: $barcode');
      _logger.i('📱 Current Screen: ${_appState.value.currentScreen}');
      _logger.i('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      
      // Send scanned barcode to API
      final webApiService = Get.find<WebApiService>();
      webApiService.sendOneTimeRequest(barcode);
      
      _logger.i('✅ Barcode sent to API successfully');
      print('🔍 Scanned barcode "$barcode" sent to API');
      
    } catch (e) {
      _logger.e('❌ Error processing scanned barcode: $e');
      print('❌ Error processing scanned barcode: $e');
    }
  }

  void _updateAppState({
    AppScreen? currentScreen,
    ConnectionStatus? mqttStatus,
    bool? isAlertActive,
    String? errorMessage,
  }) {
    final newState = _appState.value.copyWith(
      currentScreen: currentScreen ?? _appState.value.currentScreen,
      mqttStatus: mqttStatus ?? _appState.value.mqttStatus,
      isAlertActive: isAlertActive ?? _appState.value.isAlertActive,
      errorMessage: errorMessage ?? _appState.value.errorMessage,
      lastUpdate: DateTime.now(),
    );
    _appState.value = newState;
    _appState.refresh();
  }


  void _updateMqttStatus(ConnectionStatus status) {
    _updateAppState(mqttStatus: status);
  }

  void _navigateToScreen(AppScreen screen, {String? errorMessage}) {
    _logger.i('_navigateToScreen called with screen: $screen');
    
    // Check if fraud alert is active - if so, don't navigate unless it's dismissing the alert
    if (isAlertActive && _currentAlert.value?.type == AlertType.fraud) {
      if (screen != AppScreen.fraudAlert) {
        _logger.w('Cannot navigate to $screen - fraud alert is active and must be dismissed first');
        return;
      }
    }
    
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

  void navigateToPosCashier() {
    _navigateToScreen(AppScreen.posCashier);
  }

  void navigateToParameters() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to parameters - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.parameters);
  }

  // Item management
  void addScannedItem(String item) {
    _scannedItems.add(item);
    _logger.i('Added scanned item: $item');
  }

  void setScannedItems(List<String> items) {
    _scannedItems.clear();
    _scannedItems.addAll(items);
    _logger.i('Set scanned items list with ${items.length} items');
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
      
      // Note: Items will be cleared when PosSubState becomes 1008 in printing screen
      
    } catch (e) {
      _logger.e('Payment processing failed: $e');
      navigateToError(errorMessage: 'Payment failed: $e');
    }
  }

  // Assistant methods

  Future<void> testMqttConnection() async {
    final success = await _mqttService.testConnection();
    _logger.i('MQTT test connection: $success');
  }




  void simulateAlert() {
    _mqttService.simulateAlert();
  }

  void simulateFraudAlert() {
    _logger.i('Simulating fraud alert...');
    final fraudAlert = AlertMessage(
      id: 'FRAUD_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Fraud Alert',
      message: 'Suspicious activity detected at checkout station. Please investigate immediately.',
      type: AlertType.fraud,
      videoUrl: 'https://example.com/fraud_alert.gif',
      timestamp: DateTime.now(),
      isActive: true,
    );
    
    _currentAlert.value = fraudAlert;
    _updateAppState(isAlertActive: true);
    _navigateToScreen(AppScreen.fraudAlert);
  }
  
  // Public navigation method
  void navigateToScreen(AppScreen screen, {String? errorMessage}) {
    _navigateToScreen(screen, errorMessage: errorMessage);
  }
  
  // Update total amount method
  void updateTotalAmount(double amount) {
    print('🔥 LATEST CODE: AppController.updateTotalAmount called with: $amount');
    _totalAmount.value = amount;
    print('✅ LATEST CODE: Total amount RxDouble updated to: ${_totalAmount.value} AED');
  }
  
  // Display text for API Display field
  final RxString _displayText = ''.obs;
  String get displayText => _displayText.value;
  
  void updateDisplayText(String text) {
    _displayText.value = text;
    _logger.d('Updated display text: $text');
  }
  
  // PosSubState for API response
  final RxString _posSubState = ''.obs;
  String get posSubState => _posSubState.value;
  
  void updatePosSubState(String state) {
    _posSubState.value = state;
    _logger.d('Updated PosSubState: $state');
  }
  
  // Payment processing state management
  void setProcessingPayment(bool isProcessing) {
    _isProcessingPayment.value = isProcessing;
    _logger.d('Set processing payment: $isProcessing');
  }
  
  // Update terminal ID
  void updateTerminalId(String terminalId) {
    _terminalId.value = terminalId;
    _logger.d('Updated terminal ID: $terminalId');
  }
}
