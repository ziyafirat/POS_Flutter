import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/app_state.dart';
import '../models/alert_message.dart';
import '../services/mqtt_service.dart';
import '../services/web_api_service.dart';
import '../services/scanner_service.dart';
import '../services/lamp_service.dart';
import '../models/parsed_item.dart';
import '../widgets/payment_popup.dart';
import '../widgets/processing_popup.dart';
import '../widgets/printing_popup.dart';
import '../widgets/thank_you_popup.dart';
import 'language_controller.dart';

class AppController extends GetxController {
  final Logger _logger = Logger();
  late final MqttService _mqttService;
  late final ScannerService _scannerService;
  late final LampService _lampService;

  // Reactive state
  final Rx<AppState> _appState = AppState(
    currentScreen: AppScreen.start,
    mqttStatus: ConnectionStatus.disconnected,
    isAlertActive: false,
    lastUpdate: DateTime.now(),
  ).obs;

  final Rx<AlertMessage?> _currentAlert = Rx<AlertMessage?>(null);
  final RxList<String> _scannedItems = <String>[].obs;
  final RxList<ParsedItem> _parsedItems = <ParsedItem>[].obs;
  final RxDouble _totalAmount = 0.0.obs;

  // Cache for itemline data comparison to skip unnecessary updates
  String _lastItemlineHash = '';
  final RxString _terminalId = '500'.obs;
  final RxBool _isProcessingPayment = false.obs;
  final RxBool _userInitiatedNavigation = false.obs;
  final RxBool _posOverrideMode = false.obs;

  // Track current popup substate to prevent duplicates
  String _currentPopupSubstate = '';

  // Track user scanning session to ignore 1008 during active scanning
  final RxBool _userScanningSession = false.obs;

  // Track previous page before fraud alert to return to it when alert is dismissed
  AppScreen? _previousPageBeforeFraudAlert;

  // Track payment flow state - enabled on 1010, disabled on 1008
  bool _paymentFlowActive = false;

  // Track start page stay state - enabled after 1008, disabled on 1010
  bool _stayOnStartPageUntilManualStart = false;

  // Timer for 20-second item scan session when start button is pressed from start page
  Timer? _itemScanTimer;

  // Flags to prevent duplicate MQTT checkout events
  bool _canSendCheckoutStart = true; // Initially can send start event
  bool _canSendCheckoutEnd = false; // Cannot send end until start is sent
  bool _canSendPaymentEvent =
      true; // Can send payment event once per 1010 substate

  // Getters
  Rx<AppState> get appState => _appState;
  AlertMessage? get currentAlert => _currentAlert.value;
  List<String> get scannedItems => _scannedItems;
  List<ParsedItem> get parsedItems => _parsedItems;
  double get totalAmount => _totalAmount.value;
  bool get isAlertActive => _currentAlert.value?.isActive ?? false;
  String? get terminalId => _terminalId.value;
  RxBool get isProcessingPayment => _isProcessingPayment;
  bool get userInitiatedNavigation => _userInitiatedNavigation.value;
  bool get posOverrideMode => _posOverrideMode.value;
  bool get userScanningSession => _userScanningSession.value;
  bool get stayOnStartPageUntilManualStart => _stayOnStartPageUntilManualStart;
  bool get canSendCheckoutStart => _canSendCheckoutStart;
  bool get canSendCheckoutEnd => _canSendCheckoutEnd;
  bool get canSendPaymentEvent => _canSendPaymentEvent;
  MqttService get mqttService => _mqttService;
  LampService get lampService => _lampService;

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
    Get.put(LampService());
    _mqttService =
        Get.find<MqttService>(); // Get the already registered MQTT service
    _scannerService = Get.find<ScannerService>(); // Get the scanner service
    _lampService = Get.find<LampService>(); // Get the lamp service
    _initializeServices();
    _setupAlertListener();
    _setupScannerListener();
  }

  @override
  void onClose() {
    _alertSubscription?.cancel();
    _scannerSubscription?.cancel();
    _itemScanTimer?.cancel(); // Cancel the 20-second timer
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

      // Start connection monitoring for auto-reconnection
      _mqttService.startConnectionMonitoring();

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
        // For fraud alerts, close all other popup pages first
        _closeAllPopups();

        // Remember the current page before navigating to fraud alert
        if (_appState.value.currentScreen != AppScreen.fraudAlert) {
          _previousPageBeforeFraudAlert = _appState.value.currentScreen;
          _logger.i(
            '🚨 FRAUD ALERT: Remembering previous page: $_previousPageBeforeFraudAlert',
          );
          print(
            '🚨 FRAUD ALERT: Remembering previous page: $_previousPageBeforeFraudAlert',
          );
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

  /// Close all popup pages (dialogs) when fraud alert is received
  void _closeAllPopups() {
    _logger.i('🚨 FRAUD ALERT: Closing all popup pages');
    print('🚨 FRAUD ALERT: Closing all popup pages');

    // Close any open dialogs/popups
    if (Get.isDialogOpen == true) {
      _logger.i('🚨 FRAUD ALERT: Closing existing dialog');
      print('🚨 FRAUD ALERT: Closing existing dialog');
      Get.back();
    }

    // Reset popup substate tracking
    _currentPopupSubstate = '';

    _logger.i('🚨 FRAUD ALERT: All popups closed successfully');
    print('🚨 FRAUD ALERT: All popups closed successfully');
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

      // Reset scanning session flag when item is actually scanned
      if (_userScanningSession.value) {
        _userScanningSession.value = false;
        _logger.i(
          '🔓 User scanning session ended - item scanned, will now respond to substate 1008',
        );
        print(
          '🔓 User scanning session ended - item scanned, will now respond to substate 1008',
        );
      }

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

    // Update lamp color based on current screen
    _updateLampColor(newState.currentScreen, errorMessage);
  }

  void _updateMqttStatus(ConnectionStatus status) {
    _updateAppState(mqttStatus: status);
  }

  /// Update lamp color based on current screen
  void _updateLampColor(AppScreen screen, String? errorMessage) {
    switch (screen) {
      case AppScreen.error:
        // Blinking red for error page (especially for assistance calls)
        if (errorMessage?.contains('Assistance requested') == true) {
          _lampService.startBlinking(LampColor.red);
          _logger.i('💡 [LAMP] Error page (assistance) - blinking red');
        } else {
          _lampService.setColor(LampColor.red);
          _logger.i('💡 [LAMP] Error page - solid red');
        }
        break;

      case AppScreen.terminalClosed:
        // Solid red for terminal closed
        _lampService.setColor(LampColor.red);
        _logger.i('💡 [LAMP] Terminal closed - solid red');
        break;

      case AppScreen.start:
        // Green for start page
        _lampService.setColor(LampColor.green);
        _logger.i('💡 [LAMP] Start page - green');
        break;

      case AppScreen.itemScan:
        // Blue for item scan page
        _lampService.setColor(LampColor.blue);
        _logger.i('💡 [LAMP] Item scan page - blue');
        break;

      case AppScreen.posCashier:
        // Green for POS cashier
        _lampService.setColor(LampColor.green);
        _logger.i('💡 [LAMP] POS Cashier page - green');
        break;

      default:
        // Default to off for other screens
        _lampService.turnOff();
        _logger.i('💡 [LAMP] Other screen ($screen) - off');
        break;
    }
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

    // Clear scanning session flag when returning to start page
    if (_userScanningSession.value) {
      _userScanningSession.value = false;
      _logger.i('🔓 User scanning session cleared when returning to start');
      print('🔓 User scanning session cleared when returning to start');
    }

    // Clear payment flow flag when returning to start page
    if (_paymentFlowActive) {
      _paymentFlowActive = false;
      _logger.i('💳 Payment flow flag cleared when returning to start');
      print('💳 Payment flow flag cleared when returning to start');
    }

    // Clear itemline cache for fresh session
    clearItemlineCache();

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

    // Set scanning session flag when user manually navigates to item scan
    _userScanningSession.value = true;
    _logger.i('🔒 User scanning session started - will ignore substate 1008');
    print('🔒 User scanning session started - will ignore substate 1008');

    // Disable start page stay flag when user manually starts new session
    if (_stayOnStartPageUntilManualStart) {
      _stayOnStartPageUntilManualStart = false;
      _logger.i(
        '🔓 Start page stay flag disabled - user manually started new session',
      );
      print(
        '🔓 Start page stay flag disabled - user manually started new session',
      );
    }

    _navigateToScreen(AppScreen.itemScan);
  }

  /// Navigate to item scan page with 20-second timer (for start button from start page)
  void navigateToItemScanWithTimer() {
    _logger.i('🚀 Starting 20-second item scan session from start page');
    print('🚀 Starting 20-second item scan session from start page');

    // Cancel any existing timer
    if (_itemScanTimer != null) {
      _logger.i('🔄 Cancelling existing timer before starting new one');
      print('🔄 Cancelling existing timer before starting new one');
      _itemScanTimer!.cancel();
    }

    // Navigate to item scan page
    navigateToItemScan();

    // Start 20-second timer
    _itemScanTimer = Timer(const Duration(seconds: 20), () {
      _logger.i('⏰ 20-second timer expired - checking if still substate 1008');
      print('⏰ 20-second timer expired - checking if still substate 1008');
      print('⏰ Current substate: ${_posSubState.value}');
      print('⏰ Current screen: ${_appState.value.currentScreen}');

      // Check if we're still on substate 1008
      if (_posSubState.value == '1008') {
        _logger.i('🔄 Still substate 1008 - returning to start page');
        print('🔄 Still substate 1008 - returning to start page');

        // Clear the timer
        _itemScanTimer = null;

        // Navigate back to start page
        navigateToStart();

        // Re-enable start page stay flag
        _stayOnStartPageUntilManualStart = true;
        _logger.i('🔒 Start page stay flag re-enabled after timer expiry');
        print('🔒 Start page stay flag re-enabled after timer expiry');
      } else {
        _logger.i(
          '✅ Substate changed to ${_posSubState.value} - staying on item scan',
        );
        print(
          '✅ Substate changed to ${_posSubState.value} - staying on item scan',
        );
        _itemScanTimer = null;
      }
    });

    _logger.i(
      '⏱️ 20-second timer started - will return to start if substate remains 1008',
    );
    print(
      '⏱️ 20-second timer started - will return to start if substate remains 1008',
    );
    print('⏱️ Timer active: ${_itemScanTimer?.isActive}');
  }

  void navigateToPayment() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to payment - alert is active');
      return;
    }
    // Show payment popup (payment page has been removed)
    _logger.i('🎯 Showing payment popup...');
    print('🎯 Showing payment popup...');

    Get.dialog(
      const PaymentPopup(),
      barrierDismissible: false,
      name: 'payment_popup', // Named route for tracking
    );
  }

  void navigateToProcessing() {
    if (isAlertActive) {
      _logger.w('Cannot navigate to processing - alert is active');
      return;
    }
    // Show processing popup (processing page has been removed)
    _logger.i('🎯 Showing processing popup...');
    print('🎯 Showing processing popup...');

    Get.dialog(
      const ProcessingPopup(
        title: 'Processing Transaction',
        message: 'Please wait while we process your transaction...',
        icon: Icons.hourglass_empty,
      ),
      barrierDismissible: false,
      name: 'processing_popup',
    );
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
      // Show printing popup (printing page has been removed)
      Get.dialog(
        const PrintingPopup(
          title: 'Printing Receipt',
          message: 'Please wait while we print your receipt...',
          icon: Icons.print,
        ),
        barrierDismissible: false,
        name: 'printing_popup',
      );
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

  /// Call for assistance - navigate to error page and stay there
  void callForAssistance() {
    _logger.i('🚨 CALL FOR ASSISTANCE: User requested help');
    print('🚨 CALL FOR ASSISTANCE: User requested help');

    // Close all popups
    closeAllPopups();

    // Clear all flags to ensure we stay on error page
    _userScanningSession.value = false;
    _paymentFlowActive = false;

    // Navigate to error page with assistance message
    _navigateToScreen(
      AppScreen.error,
      errorMessage: 'Assistance requested. Please wait for staff to help you.',
    );

    // Start lamp blinking red for assistance
    _lampService.startBlinking(LampColor.red);
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
    // Generate hash for current itemline data
    final currentHash = _generateItemlineHash(items);

    // Skip update if data hasn't changed
    if (currentHash == _lastItemlineHash) {
      // _logger.d('📋 Itemline data unchanged - skipping ListView update'); // Disabled - too verbose
      return;
    }

    // Check if new items were added (item count increased)
    final previousItemCount = _scannedItems.length;
    final newItemCount = items.length;
    final hasNewItems = newItemCount > previousItemCount;

    // Update cached hash
    _lastItemlineHash = currentHash;

    _scannedItems.clear();
    _scannedItems.addAll(items);

    // Also update parsed items for better UI performance
    _parsedItems.clear();
    _parsedItems.addAll(items.map((item) => ParsedItem.fromString(item)));

    _logger.i(
      '⚡ Set scanned items list with ${items.length} items (with parsed cache) - Hash: ${currentHash.substring(0, 8)}...',
    );

    // Send item scan event if new items were added
    if (hasNewItems) {
      final newItemsAdded = newItemCount - previousItemCount;
      _logger.i('📦 New items detected: $newItemsAdded items added');
      print('📦 New items detected: $newItemsAdded items added');

      // Get the latest scanned item for MQTT event
      if (_parsedItems.isNotEmpty) {
        final latestItem = _parsedItems.last;
        _logger.i(
          '📦 Latest item: barcode=${latestItem.barcode}, qty=${latestItem.qty}',
        );
        print(
          '📦 Latest item: barcode=${latestItem.barcode}, qty=${latestItem.qty}',
        );

        // Send item scan event to MQTT with actual item data
        _mqttService.sendItemScanEvent(
          uiStatus: 'ITEM_SCANNED',
          scanId: latestItem.barcode, // Use barcode as scan_id
          itemId: latestItem.barcode, // Use barcode as item_id
          quantityOfItems: int.tryParse(latestItem.qty) ?? 1,
          isReturned: false,
          isVoided: false,
          isMobileScan: false,
          scanMode: 'REGULAR',
        );
      } else {
        // Fallback if no parsed items available
        _mqttService.sendItemScanEvent(uiStatus: 'ITEM_SCANNED');
      }

      // Also send item info event with actual item data
      if (_parsedItems.isNotEmpty) {
        final latestItem = _parsedItems.last;
        _mqttService.sendItemInfoEvent(
          uiStatus: 'ITEM_ADDED',
          scanId: latestItem.barcode, // Use barcode as scan_id
          itemId: latestItem.barcode, // Use barcode as item_id
          productPrice: latestItem.priceAsDouble, // Use actual price
          productName: latestItem.displayName, // Use actual product name
          quantityOfItems:
              int.tryParse(latestItem.qty) ?? 1, // Use actual quantity
          isReturned: false,
          isVoided: false,
          isMobileScan: false,
          scanMode: 'REGULAR',
        );
      } else {
        // Fallback if no parsed items available
        _mqttService.sendItemInfoEvent(uiStatus: 'ITEM_ADDED');
      }
    }
  }

  /// Generate a simple hash for itemline data to detect changes
  String _generateItemlineHash(List<String> items) {
    if (items.isEmpty) return '';

    // Create a simple hash based on items count and content
    final combined = items.join('|');
    return combined.hashCode.toString();
  }

  /// Clear itemline cache when starting new session
  void clearItemlineCache() {
    _lastItemlineHash = '';
    _logger.i('🗑️ Itemline cache cleared');
  }

  // Alert management
  void dismissAlert() {
    _currentAlert.value = null;
    _updateAppState(isAlertActive: false);
    _logger.i('Alert dismissed');
  }

  // Return to the page that was active before fraud alert
  void returnToPreviousPageAfterFraudAlert() {
    if (_previousPageBeforeFraudAlert != null) {
      _logger.i(
        '🚨 FRAUD ALERT: Returning to previous page: $_previousPageBeforeFraudAlert',
      );
      print(
        '🚨 FRAUD ALERT: Returning to previous page: $_previousPageBeforeFraudAlert',
      );
      _navigateToScreen(_previousPageBeforeFraudAlert!);
      _previousPageBeforeFraudAlert = null; // Clear the remembered page
    } else {
      _logger.i(
        '🚨 FRAUD ALERT: No previous page remembered, navigating to start',
      );
      print('🚨 FRAUD ALERT: No previous page remembered, navigating to start');
      _navigateToScreen(AppScreen.start);
    }
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

    // Create a simple test image (1x1 red pixel PNG) in base64
    const testImageBase64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

    // Create message in the same format as real fraud alerts (with nested image object)
    final messageJson = {
      "id": "0f363004-9acc-4053-b2fe-ff594d9a2321",
      "transaction_id": "de3caf2d-060d-42c0-ba99-c18e066afdac",
      "store_id": "123",
      "checkout_id": "0500",
      "timestamp": DateTime.now().toIso8601String(),
      "fraud_type": "FIRST_ITEM_IN_FINAL_AREA",
      "data_path": "walkout",
      "confidence": 0.82,
      "pos_interaction": "SOFT_NUDGE",
      "image": {"mime": "image/png", "data": testImageBase64},
    };

    final fraudAlert = AlertMessage(
      id: 'FRAUD_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Fraud Alert',
      message: jsonEncode(messageJson), // Use JSON string like real alerts
      type: AlertType.fraud,
      videoUrl: 'https://example.com/fraud_alert.gif',
      imageData: testImageBase64, // Also set direct imageData for fallback
      imageMimeType: 'image/png',
      timestamp: DateTime.now(),
      isActive: true,
    );

    _logger.i('📸 Fraud alert created with nested image format');
    print('📸 Fraud alert created with nested image format');
    print('📸 Fraud alert message: ${jsonEncode(messageJson)}');
    print('📸 Fraud alert imageData: "$testImageBase64"');

    _currentAlert.value = fraudAlert;
    _updateAppState(isAlertActive: true);

    // Close all popups before showing fraud alert page
    _closeAllPopups();
    _navigateToScreen(AppScreen.fraudAlert);
  }

  // Public navigation method
  void navigateToScreen(AppScreen screen, {String? errorMessage}) {
    _navigateToScreen(screen, errorMessage: errorMessage);
  }

  // Update total amount method
  void updateTotalAmount(double amount) {
    // print('🔥 LATEST CODE: AppController.updateTotalAmount called with: $amount'); // Disabled - too verbose
    _totalAmount.value = amount;
    // print('✅ LATEST CODE: Total amount RxDouble updated to: ${_totalAmount.value} AED'); // Disabled - too verbose
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
  RxString get posSubStateStream => _posSubState;

  void updatePosSubState(String state) {
    final previousState = _posSubState.value;
    _logger.i('🔄 POS SubState updated: $previousState → $state');
    print('🔄 POS SubState updated: $previousState → $state');
    print('📱 Current Screen: ${_appState.value.currentScreen}');
    print('💬 Dialog Open: ${Get.isDialogOpen}');
    print('🎯 Payment Flow Active: $_paymentFlowActive');
    print('🔒 Stay on Start Page: $_stayOnStartPageUntilManualStart');

    _posSubState.value = state;

    // ENHANCED PROTECTION: Check if we're on protected pages and should stay there
    final currentScreen = _appState.value.currentScreen;
    if (currentScreen == AppScreen.posCashier ||
        currentScreen == AppScreen.assistant ||
        currentScreen == AppScreen.parameters) {
      _logger.i(
        '🔒 PROTECTED PAGE: Staying on $currentScreen screen - ignoring substate $state navigation',
      );
      print(
        '🔒 PROTECTED PAGE: Staying on $currentScreen screen - ignoring substate $state navigation',
      );
      if (currentScreen == AppScreen.posCashier) {
        print('🔒 Use "Customer Screen" button to exit POS Cashier mode');
      } else {
        print('🔒 Use navigation buttons to exit $currentScreen page');
      }
      return; // Exit early - don't handle any navigation when on protected pages
    }

    // Handle payment flow flags
    if (state == '1010') {
      _paymentFlowActive = true;
      // Disable start page stay flag when new transaction starts
      _stayOnStartPageUntilManualStart = false;
      _logger.i(
        '💳 Payment flow started - flag enabled, start page stay disabled',
      );
      print('💳 Payment flow started - flag enabled, start page stay disabled');

      // Send payment UI event to MQTT (one time only)
      if (_canSendPaymentEvent) {
        _logger.i(
          '💳 Substate 1010: Sending payment UI event to MQTT (first time)',
        );
        print(
          '💳 Substate 1010: Sending payment UI event to MQTT (first time)',
        );
        _mqttService.sendPaymentEvent();

        // Disable payment event flag until next transaction
        _canSendPaymentEvent = false;
        _logger.i('🔄 Payment event flag disabled until next transaction');
        print('🔄 Payment event flag disabled until next transaction');
      } else {
        _logger.i(
          '🚫 Substate 1010: Payment UI event already sent - skipping duplicate',
        );
        print(
          '🚫 Substate 1010: Payment UI event already sent - skipping duplicate',
        );
      }
    } else if (state == '1008') {
      if (_paymentFlowActive) {
        _paymentFlowActive = false;
        // Enable start page stay flag when transaction completes
        _stayOnStartPageUntilManualStart = true;
        _logger.i(
          '🏁 Payment flow ended - flag disabled, start page stay enabled',
        );
        print('🏁 Payment flow ended - flag disabled, start page stay enabled');
      }
    }

    // Special handling for substate 1008 - go to start page unless timer is active
    if (state == '1008') {
      // Check if we have an active timer (user pressed start button)
      if (_itemScanTimer != null && _itemScanTimer!.isActive) {
        _logger.i(
          '⏱️ Substate 1008: Timer is active - ignoring navigation to start',
        );
        print(
          '⏱️ Substate 1008: Timer is active - ignoring navigation to start',
        );
        // Just close popups but don't navigate - let the timer handle the navigation
        closeAllPopups();
        _currentPopupSubstate = '';
        return; // Exit early - let timer handle the navigation
      } else {
        _logger.i(
          '🏁 Substate 1008: No active timer - returning to start page',
        );
        print('🏁 Substate 1008: No active timer - returning to start page');

        // Cancel any existing item scan timer (should be null already)
        _itemScanTimer?.cancel();
        _itemScanTimer = null;

        // Close any popups and navigate to start
        closeAllPopups();
        _currentPopupSubstate = '';
        navigateToStart();

        // Enable start page stay flag for next transaction
        _stayOnStartPageUntilManualStart = true;
        _logger.i(
          '🔒 Start page stay flag enabled - will stay on start until manual start button press',
        );
        print(
          '🔒 Start page stay flag enabled - will stay on start until manual start button press',
        );

        return; // Exit early since we've handled this substate
      }
    }

    // Special handling for error substates - navigate to error page
    if (state == '10333' || state == '10356' || state == '10398') {
      _logger.i('🚨 Error substate $state: Navigating to error page');
      print('🚨 Error substate $state: Navigating to error page');

      // Clear payment flow flag on error
      _paymentFlowActive = false;

      closeAllPopups();
      navigateToError(errorMessage: 'System error (SubState: $state)');
      return; // Exit early since we've handled this substate
    }

    // Special handling for substate 1001 - send checkout start event to MQTT
    if (state == '1001') {
      // Send checkout start event only if allowed (prevent duplicates)
      if (_canSendCheckoutStart) {
        _logger.i(
          '🛒 Substate 1001: Sending checkout start event to MQTT (first time)',
        );
        print(
          '🛒 Substate 1001: Sending checkout start event to MQTT (first time)',
        );

        // Send checkout start event (will generate new transaction IDs automatically)
        _mqttService.sendCheckoutStartEvent();

        // Update flags: disable start, enable end, enable payment
        _canSendCheckoutStart = false;
        _canSendCheckoutEnd = true;
        _canSendPaymentEvent =
            true; // Reset payment event flag for new transaction
        _logger.i('🔄 MQTT Flags: Start=false, End=true, Payment=true');
        print('🔄 MQTT Flags: Start=false, End=true, Payment=true');
      } else {
        _logger.i(
          '🚫 Substate 1001: Checkout start event already sent - skipping duplicate',
        );
        print(
          '🚫 Substate 1001: Checkout start event already sent - skipping duplicate',
        );
      }

      // Always navigate from start page to item scan on substate 1001
      if (_appState.value.currentScreen == AppScreen.start) {
        _logger.i(
          '📱 Substate 1001 on start page: Always navigating to item scan page',
        );
        print(
          '📱 Substate 1001 on start page: Always navigating to item scan page',
        );
        navigateToItemScan();
        // Reset the stay flag since we're starting a new transaction
        _stayOnStartPageUntilManualStart = false;
      }
    }

    // Special handling for substate 7006 - send checkout end event to MQTT
    if (state == '7006') {
      // Send checkout end event only if allowed (prevent duplicates)
      if (_canSendCheckoutEnd) {
        _logger.i(
          '🏁 Substate 7006: Sending checkout end event to MQTT (first time)',
        );
        print(
          '🏁 Substate 7006: Sending checkout end event to MQTT (first time)',
        );
        _mqttService.sendCheckoutEndEvent();

        // Update flags: enable start, disable end
        _canSendCheckoutStart = true;
        _canSendCheckoutEnd = false;
        _logger.i('🔄 MQTT Flags: Start=true, End=false');
        print('🔄 MQTT Flags: Start=true, End=false');
      } else {
        _logger.i(
          '🚫 Substate 7006: Checkout end event already sent or start not sent - skipping duplicate',
        );
        print(
          '🚫 Substate 7006: Checkout end event already sent or start not sent - skipping duplicate',
        );
      }
    }

    // Special handling for substate 1002 when on start page - navigate to item scan
    if (state == '1002' && _appState.value.currentScreen == AppScreen.start) {
      if (_stayOnStartPageUntilManualStart) {
        _logger.i(
          '🔒 Substate 1002 on start page: Staying on start page (manual start required)',
        );
        print(
          '🔒 Substate 1002 on start page: Staying on start page (manual start required)',
        );
      } else {
        _logger.i(
          '📱 Substate 1002 on start page: Navigating to item scan page',
        );
        print('📱 Substate 1002 on start page: Navigating to item scan page');
        navigateToItemScan();
      }
    }

    // Handle substate-driven navigation
    _handleSubstateNavigation(state);
  }

  void _handleSubstateNavigation(String state) {
    _logger.i('🎯 SUBSTATE NAVIGATION: $state');
    print('🎯 SUBSTATE NAVIGATION: $state');
    print('📱 Current Screen: ${_appState.value.currentScreen}');

    // Check if we're on persistent pages that should stay open
    final currentScreen = _appState.value.currentScreen;
    if (currentScreen == AppScreen.posCashier ||
        currentScreen == AppScreen.assistant ||
        currentScreen == AppScreen.parameters ||
        (currentScreen == AppScreen.error &&
            _appState.value.errorMessage?.contains('Assistance requested') ==
                true)) {
      _logger.i(
        '🔒 PERSISTENT PAGE PROTECTION: On $currentScreen - ignoring substate $state navigation',
      );
      print(
        '🔒 PERSISTENT PAGE PROTECTION: On $currentScreen - ignoring substate $state navigation',
      );
      print(
        '🔒 POS Cashier screen will remain stable until "Customer Screen" button is pressed',
      );
      return; // Exit early - don't handle navigation for these pages
    }

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
    } else {
      // Special case: Handle processing popup for 1002 when payment flow is active, even if not on item scan page
      if (state == '1002' && _paymentFlowActive) {
        _logger.i(
          '🔄 Substate 1002 with active payment flow: Showing processing popup (not on item scan page)',
        );
        print(
          '🔄 Substate 1002 with active payment flow: Showing processing popup (not on item scan page)',
        );

        // Close any existing popup first
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        // Show processing popup
        Get.dialog(
          const ProcessingPopup(
            title: 'Processing Payment',
            message: 'Please wait while we process your payment...',
            icon: Icons.hourglass_empty,
          ),
          barrierDismissible: false,
          name: 'processing_popup',
        );
        _currentPopupSubstate = state;
      }
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

      case '5004':
        // Show processing popup for substate 5004
        _logger.i('🔄 Substate 5004: Showing processing popup');
        print('🔄 Substate 5004: Showing processing popup');
        _showPopupOverItemScan('ProcessingPopup', state, () {
          Get.dialog(
            const ProcessingPopup(
              title: 'Processing Transaction',
              message: 'Please wait while we process your transaction...',
              icon: Icons.hourglass_empty,
            ),
            barrierDismissible: false,
            name: 'processing_popup',
          );
        });
        break;

      case '7006':
        _logger.i(
          '🎉 Substate 7006: Transaction Complete - showing thank you popup',
        );
        print(
          '🎉 Substate 7006: Transaction Complete - showing thank you popup',
        );
        _showPopupOverItemScan('ThankYouPopup', state, () {
          Get.dialog(
            const ThankYouPopup(), // No auto-close - stays until substate 1008 or 7006 changes
            barrierDismissible: false,
            name: 'thank_you_popup',
          );
        });
        break;

      case '1002':
        // Only show processing popup if payment flow is active (after 1010)
        if (_paymentFlowActive) {
          _logger.i(
            '🔄 Substate 1002: Processing payment (payment flow active) - showing processing popup',
          );
          print(
            '🔄 Substate 1002: Processing payment (payment flow active) - showing processing popup',
          );

          _showPopupOverItemScan('ProcessingPopup', state, () {
            Get.dialog(
              const ProcessingPopup(
                title: 'Processing Transaction',
                message: 'Please wait while we process your transaction...',
                icon: Icons.hourglass_empty,
              ),
              barrierDismissible: false,
              name: 'processing_popup',
            );
          });
        } else {
          _logger.i(
            '📱 Substate 1002: Stay on item scan page (no active payment flow)',
          );
          print(
            '📱 Substate 1002: Stay on item scan page (no active payment flow)',
          );
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

  // Method to test substate 1001 always navigating to item scan
  void test1001AlwaysNavigate() {
    _logger.i('🧪 TEST: Testing substate 1001 always navigates to item scan');
    print('🧪 TEST: Testing substate 1001 always navigates to item scan');

    // Ensure we're on start page
    navigateToStart();

    // Enable stay flag to test that 1001 overrides it
    _stayOnStartPageUntilManualStart = true;
    _logger.i('🧪 TEST: Stay flag enabled - testing 1001 override');
    print('🧪 TEST: Stay flag enabled - testing 1001 override');

    // Wait a moment then simulate 1001
    Timer(const Duration(milliseconds: 500), () {
      updatePosSubState('1001');
    });
  }

  // Method to reset MQTT checkout event flags (for testing or manual reset)
  void resetCheckoutEventFlags() {
    _canSendCheckoutStart = true;
    _canSendCheckoutEnd = false;
    _canSendPaymentEvent = true;
    _logger.i(
      '🔄 MQTT checkout event flags reset: Start=true, End=false, Payment=true',
    );
    print(
      '🔄 MQTT checkout event flags reset: Start=true, End=false, Payment=true',
    );
  }

  // Method to get current MQTT flag status (for debugging)
  Map<String, bool> getCheckoutEventFlagStatus() {
    return {
      'canSendCheckoutStart': _canSendCheckoutStart,
      'canSendCheckoutEnd': _canSendCheckoutEnd,
      'canSendPaymentEvent': _canSendPaymentEvent,
    };
  }

  // Method to test complete checkout event cycle
  void testCheckoutEventCycle() {
    _logger.i('🧪 TEST: Testing complete checkout event cycle');
    print('🧪 TEST: Testing complete checkout event cycle');

    // Reset flags to initial state
    resetCheckoutEventFlags();

    // Test sequence: 1001 → 7006 → 1001 → 7006
    navigateToStart();

    Timer(const Duration(milliseconds: 500), () {
      print('🧪 TEST: Step 1 - Sending first 1001 (should send start event)');
      updatePosSubState('1001');

      Timer(const Duration(milliseconds: 1000), () {
        print('🧪 TEST: Step 2 - Sending 7006 (should send end event)');
        updatePosSubState('7006');

        Timer(const Duration(milliseconds: 1000), () {
          print(
            '🧪 TEST: Step 3 - Sending second 1001 (should send start event again)',
          );
          updatePosSubState('1001');

          Timer(const Duration(milliseconds: 1000), () {
            print('🧪 TEST: Step 4 - Sending duplicate 1001 (should skip)');
            updatePosSubState('1001');
          });
        });
      });
    });
  }

  // Method to test protected page navigation resistance
  void testProtectedPageNavigation() {
    _logger.i('🧪 TEST: Testing protected page navigation resistance');
    print('🧪 TEST: Testing protected page navigation resistance');

    // Test assistant page protection
    navigateToAssistant();
    Timer(const Duration(milliseconds: 500), () {
      print(
        '🧪 TEST: On assistant page - sending substate 1001 (should be ignored)',
      );
      updatePosSubState('1001');

      Timer(const Duration(milliseconds: 500), () {
        print(
          '🧪 TEST: On assistant page - sending substate 1010 (should be ignored)',
        );
        updatePosSubState('1010');

        // Test parameters page protection
        navigateToParameters();
        Timer(const Duration(milliseconds: 500), () {
          print(
            '🧪 TEST: On parameters page - sending substate 1001 (should be ignored)',
          );
          updatePosSubState('1001');

          Timer(const Duration(milliseconds: 500), () {
            print(
              '🧪 TEST: On parameters page - sending substate 7006 (should be ignored)',
            );
            updatePosSubState('7006');

            // Return to start page
            Timer(const Duration(milliseconds: 500), () {
              print('🧪 TEST: Returning to start page');
              navigateToStart();
            });
          });
        });
      });
    });
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

  /// Test method to show the Thank You popup (substate 7006)
  void testThankYouPopup() {
    _logger.i('🧪 TEST: Testing Thank You popup (substate 7006)');
    print('🧪 TEST: Testing Thank You popup (substate 7006)');

    // Ensure we're on item scan page first
    if (_appState.value.currentScreen != AppScreen.itemScan) {
      navigateToItemScan();
      Timer(const Duration(milliseconds: 500), () {
        _handleItemScanPopupNavigation('7006');
      });
    } else {
      _handleItemScanPopupNavigation('7006');
    }
  }

  /// Test method for substate 1008 behavior with 20-second timer
  void testSubstate1008Behavior() {
    _logger.i('🧪 TEST: Testing substate 1008 behavior with 20-second timer');
    print('🧪 TEST: Testing substate 1008 behavior with 20-second timer');

    // Simulate being on start page
    navigateToStart();

    // Wait a moment then simulate start button press
    Timer(const Duration(milliseconds: 500), () {
      print('🧪 TEST: Simulating start button press');
      navigateToItemScanWithTimer();

      // Wait 25 seconds to see if it returns to start page
      Timer(const Duration(seconds: 25), () {
        print('🧪 TEST: 25 seconds elapsed - checking final state');
        print('🧪 TEST: Current screen: ${_appState.value.currentScreen}');
        print('🧪 TEST: Current substate: ${_posSubState.value}');
      });
    });
  }

  /// Debug method to check timer status
  void debugTimerStatus() {
    print('🔍 TIMER DEBUG:');
    print('🔍 Timer exists: ${_itemScanTimer != null}');
    print('🔍 Timer active: ${_itemScanTimer?.isActive}');
    print('🔍 Current substate: ${_posSubState.value}');
    print('🔍 Current screen: ${_appState.value.currentScreen}');
    print('🔍 Stay on start flag: $_stayOnStartPageUntilManualStart');
  }

  /// Test fraud alert popup with image
  void testFraudAlertWithImage() {
    _logger.i('🧪 TEST: Testing fraud alert popup with image');
    print('🧪 TEST: Testing fraud alert popup with image');
    simulateFraudAlert();
  }
}
