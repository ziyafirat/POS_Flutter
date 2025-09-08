import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/grpc_service.dart';
import '../services/mqtt_service.dart';
import '../services/web_api_service.dart';
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
  final RxString _terminalId = '500'.obs;

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  double get totalAmount => _totalAmount.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;
  String? get terminalId => _terminalId.value;

  // Stream subscriptions
  StreamSubscription<AlertMessage>? _alertSubscription;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    Get.put(LanguageController());
    Get.put(WebApiService());
    _initializeServices();
    _setupAlertListener();
  }

  @override
  void onClose() {
    _alertSubscription?.cancel();
    _mqttService.disconnect();
    
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

      // Set GRPC as disconnected since we're not using it
      _updateGrpcStatus(ConnectionStatus.disconnected);
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

  void navigateToPosCashier() {
    _navigateToScreen(AppScreen.posCashier);
  }

  // Item management
  void addScannedItem(String item) {
    _scannedItems.add(item);
    _logger.i('Added scanned item: $item');
  }

  void clearScannedItems() {
    _scannedItems.clear();
    _logger.i('Cleared scanned items');
  }

  void removeScannedItem(int index) {
    if (index >= 0 && index < _scannedItems.length) {
      _scannedItems.removeAt(index);
      _totalAmount.value -= 10.0; // Mock price
      _logger.i('Removed item at index $index, Total: ${_totalAmount.value}');
    }
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
    final results = await _grpcService.runHappyTestScenario();
    
    final passedTests = results.values.where((result) => result).length;
    final totalTests = results.length;
    
    // Log the results instead of showing snackbar to avoid overlay issues
    if (passedTests == totalTests) {
      _logger.i('🎉 All Tests Passed! gRPC happy test scenario completed successfully ($passedTests/$totalTests)');
    } else {
      _logger.w('⚠️ Some Tests Failed: gRPC happy test scenario: $passedTests/$totalTests tests passed');
    }
    
    // Try to show snackbar safely
    try {
      if (Get.context != null) {
        if (passedTests == totalTests) {
          Get.snackbar(
            '🎉 All Tests Passed!',
            'gRPC happy test scenario completed successfully ($passedTests/$totalTests)',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        } else {
          Get.snackbar(
            '⚠️ Some Tests Failed',
            'gRPC happy test scenario: $passedTests/$totalTests tests passed',
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
  
  // Public navigation method
  void navigateToScreen(AppScreen screen, {String? errorMessage}) {
    _navigateToScreen(screen, errorMessage: errorMessage);
  }
  
  // Update total amount method
  void updateTotalAmount(double amount) {
    _totalAmount.value = amount;
    _logger.d('Updated total amount: $amount');
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
}
