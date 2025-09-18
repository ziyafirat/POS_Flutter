import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/mqtt_service.dart';
import '../services/web_api_service.dart';
import '../services/scanner_service.dart';
import '../widgets/payment_popup.dart';
import '../widgets/processing_popup.dart';
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
  final RxBool _userInitiatedNavigation = false.obs;
  final RxBool _posOverrideMode = false.obs;

  // Track current popup substate to prevent duplicates
  String _currentPopupSubstate = '';

  // Track previous substate to determine 1002 behavior
  String _previousSubstate = '';

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  double get totalAmount => _totalAmount.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;
  String? get terminalId => _terminalId.value;
  RxBool get isProcessingPayment => _isProcessingPayment;
  bool get userInitiatedNavigation => _userInitiatedNavigation.value;
  bool get posOverrideMode => _posOverrideMode.value;

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
    _mqttService =
        Get.find<MqttService>(); // Get the already registered MQTT service
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
      _updateMqttStatus(
        mqttConnected ? ConnectionStatus.connected : ConnectionStatus.error,
      );

      // Start Web API Service
      final webApiService = Get.find<WebApiService>();
      webApiService.startApiLoop();
      _logger.i('Web API Service started');

      // Start Scanner Service
      _scannerService.startListening();
      _logger.i('Scanner Service started');

      // Wait for initial API response to get current substate
      _scheduleInitialSubstateCheck();
    } catch (e) {
      _logger.e('Service initialization failed: $e');
      _navigateToScreen(AppScreen.error, errorMessage: e.toString());
    }
  }

  /// Schedule initial substate check after API service starts
  void _scheduleInitialSubstateCheck() {
    // Wait for initial API response (3 seconds should be enough)
    Timer(const Duration(seconds: 3), () {
      _handleInitialSubstate();
    });
  }

  /// Handle initial substate on app startup
  void _handleInitialSubstate() {
    final currentSubstate = _posSubState.value;
    _logger.i('🚀 STARTUP: Checking initial substate: $currentSubstate');
    print('🚀 STARTUP: Checking initial substate: $currentSubstate');

    if (currentSubstate == '1010') {
      _logger.i(
        '🚀 STARTUP: Found substate 1010 - navigating to item scan and showing payment popup',
      );
      print(
        '🚀 STARTUP: Found substate 1010 - navigating to item scan and showing payment popup',
      );

      // Navigate to item scan page first
      navigateToItemScan();

      // Small delay to ensure page navigation completes
      Timer(const Duration(milliseconds: 500), () {
        // Show payment popup
        _handleItemScanPopupNavigation('1010');
      });
    } else {
      _logger.i(
        '🚀 STARTUP: Substate $currentSubstate - no special handling needed',
      );
      print(
        '🚀 STARTUP: Substate $currentSubstate - no special handling needed',
      );
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
      _logger.i('📏 Barcode Length: ${barcode.length}');
      _logger.i('📱 Current Screen: ${_appState.value.currentScreen}');
      _logger.i('⏰ Timestamp: ${DateTime.now().toIso8601String()}');

      // Check for special POS Cashier barcode
      if (barcode == '1111111111116') {
        _logger.i('🎯 SPECIAL BARCODE DETECTED: POS Cashier Mode');
        print('🎯 SPECIAL BARCODE DETECTED: POS Cashier Mode');
        print('🔄 Navigating to POS Cashier page...');

        // Close any open popups
        closeAllPopups();

        // Navigate to POS Cashier
        navigateToPosCashier();
        return;
      }

      // Format DisplayLine based on barcode length
      String displayLine;
      if (barcode.length <= 13) {
        // For barcodes 13 digits or less, append <80>
        displayLine = '$barcode<80>';
        _logger.i('✅ Barcode ≤ 13 digits: Using format "$displayLine"');
        print('🔍 Barcode ≤ 13 digits: Using format "$displayLine"');
      } else {
        // For longer barcodes, send as-is
        displayLine = barcode;
        _logger.i('⚠️ Barcode > 13 digits: Using format "$displayLine"');
        print('🔍 Barcode > 13 digits: Using format "$displayLine"');
      }

      // Send formatted barcode to API
      final webApiService = Get.find<WebApiService>();
      webApiService.sendOneTimeRequest(displayLine);

      _logger.i('✅ Formatted barcode sent to API successfully');
      print('🔍 Formatted barcode "$displayLine" sent to API');
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
        _logger.w(
          'Cannot navigate to $screen - fraud alert is active and must be dismissed first',
        );
        return;
      }
    }

    _updateAppState(currentScreen: screen, errorMessage: errorMessage);
    _logger.i(
      'App state updated. Current screen: ${_appState.value.currentScreen}',
    );
  }

  // Navigation methods
  void navigateToStart() {
    // Clear POS override mode when returning to start
    if (_posOverrideMode.value) {
      _posOverrideMode.value = false;
      _logger.i(
        '🔓 POS Override mode deactivated - returning to normal operation',
      );
      print('🔓 POS Override mode deactivated - returning to normal operation');
    }

    _navigateToScreen(AppScreen.start);
  }

  void navigateToItemScan() {
    _logger.i('Attempting to navigate to item scan...');
    _logger.i('isAlertActive: $isAlertActive');
    if (isAlertActive) {
      _logger.w('Cannot navigate to item scan - alert is active');
      return;
    }

    // Close any open popups when navigating to item scan
    closeAllPopups();

    _logger.i(
      'Calling _navigateToScreen with AppScreen.itemScan (user-initiated)',
    );
    _userInitiatedNavigation.value = true;
    _navigateToScreen(AppScreen.itemScan);
  }

  void navigateToPayment() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to payment - alert is active');
      return;
    }
    // Show payment popup instead of navigating to payment page
    // This keeps the item scan page in the background
    if (_appState.value.currentScreen == AppScreen.itemScan) {
      _logger.i('🎯 Showing payment popup over item scan page...');
      print('🎯 Showing payment popup over item scan page...');

      Get.dialog(
        const PaymentPopup(),
        barrierDismissible: false,
        name: 'payment_popup', // Named route for tracking
      );
    } else {
      // For other screens, navigate normally
      _navigateToScreen(AppScreen.payment);
    }
  }

  void navigateToProcessing() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to processing - alert is active');
      return;
    }
    // Show processing popup instead of navigating to processing page
    // This keeps the item scan page in the background
    if (_appState.value.currentScreen == AppScreen.itemScan) {
      _logger.i('🎯 Showing processing popup over item scan page...');
      print('🎯 Showing processing popup over item scan page...');

      Get.dialog(
        const ProcessingPopup(),
        barrierDismissible: false,
        name: 'processing_popup', // Named route for tracking
      );
    } else {
      // For other screens, navigate normally
      _navigateToScreen(AppScreen.processing);
    }
  }

  void navigateToPrinting() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to printing - alert is active');
      return;
    }
    // Show printing popup instead of navigating to printing page
    // This keeps the item scan page in the background
    if (_appState.value.currentScreen == AppScreen.itemScan) {
      _logger.i('🎯 Showing printing popup over item scan page...');
      print('🎯 Showing printing popup over item scan page...');

      // For now, use processing popup for printing (you can create a dedicated PrintingPopup later)
      Get.dialog(
        const ProcessingPopup(
          title: 'Printing Receipt',
          message: 'Please wait while we print your receipt...',
          icon: Icons.print,
        ),
        barrierDismissible: false,
        name: 'printing_popup', // Named route for tracking
      );

      // Auto-close after printing simulation
      Future.delayed(const Duration(seconds: 5), () {
        if (Get.isDialogOpen == true) {
          Get.back(); // Close printing popup
          _logger.i('✅ Printing completed, returning to item scan');
          print('✅ Printing completed, returning to item scan');
        }
      });
    } else {
      // For other screens, navigate normally
      _navigateToScreen(AppScreen.printing);
    }
  }

  void navigateToError({String? errorMessage}) {
    _logger.i('🚨 Navigating to error page - closing all popups');
    print('🚨 Navigating to error page - closing all popups');

    // Close all open popups before showing error page
    closeAllPopups();

    // Navigate to error page
    _navigateToScreen(AppScreen.error, errorMessage: errorMessage);
  }

  /// Close all open popups/dialogs
  void closeAllPopups() {
    int popupCount = 0;
    while (Get.isDialogOpen == true) {
      Get.back();
      popupCount++;
      _logger.i('📱 Closed popup dialog #$popupCount');
      print('📱 Closed popup dialog #$popupCount');

      // Safety check to prevent infinite loop
      if (popupCount > 10) {
        _logger.w('⚠️ Too many popups detected, breaking loop');
        print('⚠️ Too many popups detected, breaking loop');
        break;
      }
    }

    // Clear popup substate tracking
    _currentPopupSubstate = '';

    if (popupCount > 0) {
      _logger.i('✅ Closed $popupCount popup(s) successfully');
      print('✅ Closed $popupCount popup(s) successfully');
    }
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
    _logger.i('🎯 Navigating to POS Cashier mode');
    print('🎯 Navigating to POS Cashier mode');

    // Set POS override mode if coming from terminal closed
    if (_appState.value.currentScreen == AppScreen.terminalClosed) {
      _posOverrideMode.value = true;
      _logger.i('🔓 POS Override mode activated from terminal closed screen');
      print('🔓 POS Override mode activated from terminal closed screen');
    }

    _navigateToScreen(AppScreen.posCashier);
  }

  void navigateToParameters() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to parameters - alert is active');
      return;
    }
    _navigateToScreen(AppScreen.parameters);
  }

  void navigateToTerminalClosed() {
    _logger.i('🔒 Navigating to terminal closed screen');
    print('🔒 Navigating to terminal closed screen');

    // Close any open popups when terminal is closed
    closeAllPopups();

    _navigateToScreen(AppScreen.terminalClosed);
  }

  void showPaymentPopup() {
    if (isAlertActive) {
      _logger.w('Cannot show payment popup - alert is active');
      return;
    }
    _logger.i('Showing payment popup...');
    // The popup will be shown using Get.dialog in the calling code
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
      message:
          'Suspicious activity detected at checkout station. Please investigate immediately.',
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
    print(
      '🔥 LATEST CODE: AppController.updateTotalAmount called with: $amount',
    );
    _totalAmount.value = amount;
    print(
      '✅ LATEST CODE: Total amount RxDouble updated to: ${_totalAmount.value} AED',
    );
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
    _logger.i('🔄 POS SubState updated: $state (previous: $_previousSubstate)');
    print('🔄 POS SubState updated: $state (previous: $_previousSubstate)');

    // Store previous substate before updating
    _previousSubstate = _posSubState.value;
    _posSubState.value = state;

    // Handle substate-driven navigation
    _handleSubstateNavigation(state);
  }

  void _handleSubstateNavigation(String state) {
    _logger.i('🎯 SUBSTATE NAVIGATION: $state');
    print('🎯 SUBSTATE NAVIGATION: $state');
    print('📱 Current Screen: ${_appState.value.currentScreen}');

    // Handle terminal closed substates (only if not in POS override mode)
    if ((state == '11043' || state == '11042') && !_posOverrideMode.value) {
      _logger.i('🔒 TERMINAL CLOSED SUBSTATE DETECTED: $state');
      print('🔒 TERMINAL CLOSED SUBSTATE DETECTED: $state');
      print('🔒 Navigating to terminal closed screen...');
      navigateToTerminalClosed();
      return;
    } else if ((state == '11043' || state == '11042') &&
        _posOverrideMode.value) {
      _logger.i(
        '🔓 Terminal closed substate $state ignored - POS override mode active',
      );
      print(
        '🔓 Terminal closed substate $state ignored - POS override mode active',
      );
      return;
    }

    // Handle popup navigation when on item scan page
    if (_appState.value.currentScreen == AppScreen.itemScan) {
      _handleItemScanPopupNavigation(state);
    }
  }

  void _handleItemScanPopupNavigation(String state) {
    _logger.i('🎭 POPUP NAVIGATION ON ITEM SCAN: $state');
    print('🎭 POPUP NAVIGATION ON ITEM SCAN: $state');

    // Check if this is the same substate as current popup to prevent duplicates
    if (_currentPopupSubstate == state && Get.isDialogOpen == true) {
      _logger.d('⚠️ Same substate $state - popup already open, skipping');
      print('⚠️ Same substate $state - popup already open, skipping');
      return;
    }

    switch (state) {
      case '1001':
        _logger.i('📱 Substate 1001: Stay on item scan page (no popup)');
        print('📱 Substate 1001: Stay on item scan page (no popup)');
        // Close any existing popup and stay on item scan page
        if (Get.isDialogOpen == true) {
          Get.back();
          _currentPopupSubstate = '';
        }
        break;

      case '1010':
        _logger.i('💳 Substate 1010: Showing payment popup');
        print('💳 Substate 1010: Showing payment popup');
        _showPopupOverItemScan('PaymentPopup', state, () {
          Get.dialog(
            const PaymentPopup(),
            barrierDismissible: false,
            name: 'payment_popup',
          );
        });
        break;

      case '7006':
        _logger.i('🖨️ Substate 7006: Printing - showing printing popup');
        print('🖨️ Substate 7006: Printing - showing printing popup');
        _showPopupOverItemScan('PrintingPopup', state, () {
          Get.dialog(
            const ProcessingPopup(
              title: 'Printing Receipt',
              message: 'Please wait while we print your receipt...',
              icon: Icons.print,
            ),
            barrierDismissible: false,
            name: 'printing_popup',
          );
        });
        break;

      case '1002':
        // Only show processing popup if previous substate was 1010 (payment flow)
        if (_previousSubstate == '1010') {
          _logger.i(
            '🔄 Substate 1002: Processing after payment (1010) - showing processing popup',
          );
          print(
            '🔄 Substate 1002: Processing after payment (1010) - showing processing popup',
          );
          _showPopupOverItemScan('ProcessingPopup', state, () {
            Get.dialog(
              const ProcessingPopup(
                title: 'Processing Payment',
                message: 'Please wait while we process your payment...',
                icon: Icons.hourglass_empty,
              ),
              barrierDismissible: false,
              name: 'processing_popup',
            );
          });
        } else {
          _logger.i(
            '📱 Substate 1002: Stay on item scan page (no previous 1010)',
          );
          print('📱 Substate 1002: Stay on item scan page (no previous 1010)');
          // Close any existing popup and stay on item scan page
          if (Get.isDialogOpen == true) {
            Get.back();
            _currentPopupSubstate = '';
          }
        }
        break;

      case '1008':
        _logger.i(
          '🏁 Substate 1008: Completing transaction - returning to start',
        );
        print('🏁 Substate 1008: Completing transaction - returning to start');
        closeAllPopups();
        _currentPopupSubstate = '';
        navigateToStart();
        break;

      default:
        _logger.d('ℹ️ Substate $state: No specific popup action defined');
        print('ℹ️ Substate $state: No specific popup action defined');
        break;
    }
  }

  void _showPopupOverItemScan(
    String popupName,
    String substate,
    VoidCallback showPopup,
  ) {
    // Close any existing popup first
    if (Get.isDialogOpen == true) {
      _logger.i('📱 Closing existing popup before showing $popupName');
      print('📱 Closing existing popup before showing $popupName');
      Get.back();
      _currentPopupSubstate = '';
    }

    // Small delay to ensure previous popup is closed
    Future.delayed(const Duration(milliseconds: 100), () {
      _logger.i('📱 Showing $popupName over item scan page');
      print('📱 Showing $popupName over item scan page');
      _currentPopupSubstate = substate; // Track current popup substate
      showPopup();
    });
  }

  // Payment processing state management
  void setProcessingPayment(bool isProcessing) {
    _isProcessingPayment.value = isProcessing;
    _logger.d('Set processing payment: $isProcessing');
  }

  void clearUserInitiatedNavigation() {
    _userInitiatedNavigation.value = false;
    _logger.d('Cleared user-initiated navigation flag');
  }

  // Update terminal ID
  void updateTerminalId(String terminalId) {
    _terminalId.value = terminalId;
    _logger.d('Updated terminal ID: $terminalId');
  }

  // Test method to simulate terminal closed substates
  void simulateTerminalClosed(String substate) {
    _logger.i('🧪 SIMULATING TERMINAL CLOSED SUBSTATE: $substate');
    print('🧪 SIMULATING TERMINAL CLOSED SUBSTATE: $substate');
    updatePosSubState(substate);
  }

  // Method to manually clear POS override mode
  void clearPosOverrideMode() {
    _posOverrideMode.value = false;
    _logger.i('🔓 POS Override mode manually cleared');
    print('🔓 POS Override mode manually cleared');
  }

  // Method to check if POS override is active
  bool isPosOverrideModeActive() {
    return _posOverrideMode.value;
  }

  // Public method to simulate barcode scanning for testing
  void simulateBarcodeScanning(String barcode) {
    _logger.i('🧪 SIMULATING BARCODE SCAN: $barcode');
    print('🧪 SIMULATING BARCODE SCAN: $barcode');
    _handleScannedBarcode(barcode);
  }

  /// Test method to simulate startup substate handling
  void testStartupSubstateHandling(String substate) {
    _logger.i('🧪 TEST: Simulating startup substate handling for $substate');
    print('🧪 TEST: Simulating startup substate handling for $substate');

    if (substate == '1010') {
      // Navigate to item scan page first
      navigateToItemScan();

      // Small delay to ensure page navigation completes
      Timer(const Duration(milliseconds: 500), () {
        // Show payment popup
        _handleItemScanPopupNavigation('1010');
      });
    }
  }
}
