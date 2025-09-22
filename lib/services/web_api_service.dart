import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import 'usb_printer_service.dart';

class WebApiService extends GetxController {
  static WebApiService get to => Get.find();

  final Logger _logger = Logger();
  Timer? _apiTimer;
  bool _isRunning = false;
  bool _requestInProgress = false;
  final Random _rand = Random();

  // Flag to track if MPOS TXN END is present in current receipt to prevent duplicate printing
  bool _mposTxnEndPresent = false;

  // API Configuration
  String _baseUrl =
      'http://192.168.2.100:50000/AEFProcess/restaefprocess/aefrun/posService';

  // Observable properties
  final RxBool _isConnected = false.obs;
  final RxString _lastResponse = ''.obs;
  final RxString _lastError = ''.obs;
  final RxInt _requestCount = 0.obs;

  // Getters
  bool get isConnected => _isConnected.value;
  String get lastResponse => _lastResponse.value;
  String get lastError => _lastError.value;
  int get requestCount => _requestCount.value;
  bool get isRunning => _isRunning;
  String get baseUrl => _baseUrl;

  @override
  void onInit() {
    super.onInit();
    _logger.i('WebApiService initialized');
  }

  @override
  void onClose() {
    stopApiLoop();
    super.onClose();
  }

  /// Start the adaptive API loop
  void startApiLoop({bool immediate = true}) {
    if (_isRunning) {
      _logger.w('API loop is already running');
      return;
    }

    _logger.i('Starting adaptive API loop (with jitter)');
    _isRunning = true;
    _isConnected.value = true;

    scheduleNext(immediate: immediate);
  }

  /// Stop the API loop
  void stopApiLoop() {
    _isRunning = false;
    _apiTimer?.cancel();
    _apiTimer = null;
    _logger.i('API loop stopped');
  }

  /// Schedule the next API request with jitter
  void scheduleNext({bool immediate = false}) {
    if (!_isRunning) return;

    // Base interval = 0.5s (500ms), jitter ±15%
    const baseSecs = 0.5;
    final jitter = 0.85 + (_rand.nextDouble() * 0.30);
    final delaySecs = (baseSecs * jitter).clamp(0.5, 5.0);
    final delay = immediate
        ? Duration.zero
        : Duration(milliseconds: (delaySecs * 1000).round());

    _apiTimer?.cancel();
    _apiTimer = Timer(delay, () async {
      if (!_isRunning) return;

      if (_requestInProgress) {
        // Skip this cycle to avoid overlap
        scheduleNext();
        return;
      }

      _requestInProgress = true;
      try {
        await _makeApiRequest().timeout(const Duration(seconds: 10));
      } catch (e) {
        _requestCount.value++;
        _lastError.value = e.toString();
        _logger.e('API request error: $e');
      } finally {
        _requestInProgress = false;
      }

      // Schedule next cycle
      scheduleNext();
    });
  }

  /// Make a single API request
  Future<void> _makeApiRequest() async {
    try {
      final bodyData = _prepareRequestData();

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      _requestCount.value++;

      if (response.statusCode == 200) {
        _lastResponse.value = response.body;
        _lastError.value = '';
        _processApiResponse(response.body);
      } else {
        _lastError.value = 'HTTP ${response.statusCode}: ${response.body}';
        _logger.e(
          'API request failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      _requestCount.value++;
      _lastError.value = e.toString();
      _logger.e('API request error: $e');
    }
  }

  /// Prepare the request data based on current state
  List<Map<String, dynamic>> _prepareRequestData() {
    // Using hardcoded request data as specified
    return [
      {
        'DisplayLine': '',
        'IPDevice': ' ',
        'ListenerFlag': 'false',
        'ProcessFlag': 'display2',
        'qty': 'This is REST Service.',
        'TerminalID': '500',
      },
    ];
  }

  /// Test the API connection manually
  Future<bool> testConnection() async {
    try {
      _logger.i('Testing API connection...');

      final bodyData = _prepareRequestData();

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _logger.i('API connection test successful');
        return true;
      } else {
        _logger.e('API connection test failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('API connection test error: $e');
      return false;
    }
  }

  /// Get connection status
  String getConnectionStatus() {
    if (!_isRunning) {
      return 'Stopped';
    } else if (_lastError.value.isNotEmpty) {
      return 'Error: ${_lastError.value}';
    } else {
      return 'Connected (${_requestCount.value} requests)';
    }
  }

  /// Manually reset MPOS TXN END flag (for testing or manual reset)
  void resetMposTxnEndFlag() {
    _mposTxnEndPresent = false;
    _logger.i('🔄 MPOS TXN END flag manually reset');
    print('🔄 MPOS TXN END flag manually reset');
  }

  /// Get current MPOS TXN END flag status (for debugging)
  bool get mposTxnEndPresent => _mposTxnEndPresent;

  /// Test method to simulate receipt processing (for testing MPOS TXN END logic)
  void testProcessReceipt(String receiptText) {
    // Convert to base64 format as the API would send it
    final base64Receipt = base64Encode(utf8.encode(receiptText));
    _processReceipt(base64Receipt);
  }

  /// Process API response and update app state
  void _processApiResponse(String responseBody) {
    try {
      // Clean the response body to handle control characters in Display field
      final cleanedResponseBody = _cleanResponseBody(responseBody);
      final responseData = jsonDecode(cleanedResponseBody);

      // Update total amount from BalanceDue - Process for ANY substate
      // print('🔥 LATEST CODE RUNNING - BalanceDue Check 🔥'); // Disabled - too verbose
      if (responseData['BalanceDue'] != null &&
          responseData['BalanceDue'].toString().isNotEmpty &&
          responseData['BalanceDue'] != 'null') {
        final balanceDueString = responseData['BalanceDue'].toString().trim();
        final balanceDue = double.tryParse(balanceDueString) ?? 0.0;

        // print('🔥 LATEST CODE: Processing BalanceDue: "$balanceDueString" -> $balanceDue'); // Disabled - too verbose

        // Update total amount immediately
        final appController = Get.find<AppController>();
        appController.updateTotalAmount(balanceDue);

        // print('💰 LATEST CODE: Updated total amount: $balanceDue AED'); // Disabled - too verbose
      } else {
        // print('🔥 LATEST CODE: BalanceDue not found or empty: ${responseData['BalanceDue']}'); // Disabled - too verbose
      }

      // Process Display field for screen display
      if (responseData['Display'] != null &&
          responseData['Display'].toString().isNotEmpty) {
        final displayText = responseData['Display'].toString();
        final appController = Get.find<AppController>();
        appController.updateDisplayText(displayText);
      }

      // Handle navigation based on PosSubState
      if (responseData['PosSubState'] != null) {
        final posSubState = responseData['PosSubState'].toString();
        final appController = Get.find<AppController>();
        appController.updatePosSubState(posSubState);
        //_handlePosSubStateNavigation(posSubState);
      }

      // Process ItemLine for scanned items
      if (responseData['ItemLine'] != null &&
          responseData['ItemLine'].toString().isNotEmpty) {
        final itemLine = responseData['ItemLine'].toString();
        _processItemLine(itemLine);
      }

      // Process Receipt for printing
      if (responseData['Receipt'] != null &&
          responseData['Receipt'].toString().isNotEmpty) {
        final receipt = responseData['Receipt'].toString();
        _processReceipt(receipt);
      }
    } catch (e) {
      _logger.e('Error processing API response: $e');
    }
  }

  // /// Handle navigation based on PosSubState
  // void _handlePosSubStateNavigation(String posSubState) {
  //   final appController = Get.find<AppController>();

  //   // Skip automatic navigation if currently in POS Cashier, Assistant, Parameters, or Error screen
  //   final currentScreen = appController.appState.value.currentScreen;
  //   if (currentScreen == AppScreen.posCashier ||
  //       currentScreen == AppScreen.assistant ||
  //       currentScreen == AppScreen.parameters ||
  //       currentScreen == AppScreen.error) {
  //     _logger.i(
  //       'Skipping automatic navigation - currently in ${currentScreen.toString().split('.').last} screen (PosSubState: $posSubState)',
  //     );
  //     return;
  //   }

  //   switch (posSubState) {
  //     case '1002':
  //       // Skip 1002 if 1010 has already been received
  //       if (_hasReceived1010) {
  //         _logger.i(
  //           'Skipping posSubState 1002 - 1010 has already been received',
  //         );
  //         return;
  //       }
  //       _hasSent7006PrinterText =
  //           false; // Reset 7006 printer flag when substate changes
  //       // Clear user-initiated navigation flag when system takes control
  //       appController.clearUserInitiatedNavigation();
  //       _logger.i('Navigating to item scan page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.itemScan);
  //       break;
  //     case '1010':
  //       _hasReceived1010 = true; // Set flag when 1010 is received
  //       _hasSent7006PrinterText =
  //           false; // Reset 7006 printer flag when substate changes
  //       // Clear user-initiated navigation flag when system takes control
  //       appController.clearUserInitiatedNavigation();
  //       _logger.i('Navigating to payment page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.payment);
  //       break;
  //     case '1001':
  //       _hasSent7006PrinterText =
  //           false; // Reset 7006 printer flag when substate changes
  //       // Clear user-initiated navigation flag when system takes control
  //       appController.clearUserInitiatedNavigation();
  //       _logger.i('Navigating to start page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.itemScan);
  //       break;
  //     case '1008':
  //       _hasReceived1010 = false; // Reset flag when 1008 is received
  //       _hasSent7006PrinterText =
  //           false; // Reset 7006 printer flag when substate changes

  //       // Check if user manually navigated to item scan page
  //       if (appController.userInitiatedNavigation &&
  //           appController.appState.value.currentScreen == AppScreen.itemScan) {
  //         _logger.i(
  //           'PosSubState 1008 - User is in item scan page, staying on item scan (user-initiated navigation)',
  //         );
  //         // Clear the flag after some time or on next different substate
  //         // Don't navigate away from item scan page
  //       } else {
  //         _logger.i('Navigating to start page (PosSubState: $posSubState)');
  //         appController.navigateToScreen(AppScreen.start);
  //       }
  //       break;
  //     case '10333':
  //       _logger.i('Navigating to error page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.error);
  //       break;
  //     case '10356':
  //       _logger.i('Navigating to error page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.error);
  //       break;
  //     case '10398':
  //       _logger.i('Navigating to error page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.error);
  //       break;
  //     case '7006':
  //       _logger.i('Navigating to printing page (PosSubState: $posSubState)');
  //       appController.navigateToScreen(AppScreen.printing);

  //       // Send printer text only once until substate changes
  //       if (!_hasSent7006PrinterText) {
  //         _hasSent7006PrinterText = true;
  //         _logger.i('Sending printer text for PosSubState 7006 (first time)');
  //         print('🖨️ SUBSTATE 7006: Sending printer text (first time)');

  //         _sendPrinterTextFor7006();
  //       } else {
  //         _logger.i(
  //           'Skipping printer text for PosSubState 7006 (already sent)',
  //         );
  //         print('🖨️ SUBSTATE 7006: Skipping printer text (already sent)');
  //       }
  //       break;
  //     default:
  //       _logger.d('Unknown PosSubState: $posSubState');
  //       break;
  //   }
  // }

  /// Clean response body to handle control characters
  String _cleanResponseBody(String responseBody) {
    // Replace control characters in Display field with escaped characters
    return responseBody.replaceAllMapped(RegExp(r'"Display":\s*"([^"]*)"'), (
      match,
    ) {
      final displayContent = match.group(1) ?? '';
      // Replace newlines and other control characters with escaped versions
      final cleanedDisplay = displayContent
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return '"Display": "$cleanedDisplay"';
    });
  }

  /// Convert price from raw format (e.g., 1000) to decimal format (e.g., 10.00)
  String _convertPrice(String rawPrice) {
    try {
      // Parse the raw price as integer
      final priceValue = int.tryParse(rawPrice) ?? 0;

      // Divide by 100 and format with 2 decimal places
      final convertedPrice = priceValue / 100.0;

      // Format with 2 decimal places
      return convertedPrice.toStringAsFixed(2);
    } catch (e) {
      _logger.w('Error converting price "$rawPrice": $e');
      return '0.00';
    }
  }

  /// Process ItemLine and add to scanned items
  void _processItemLine(String itemLine) {
    try {
      // _logger.d('Processing ItemLine: $itemLine'); // Disabled - too verbose
      final decodedItems = _decodeBase64Lines(itemLine);
      // _logger.d('Decoded ${decodedItems.length} items: $decodedItems'); // Disabled - too verbose

      final appController = Get.find<AppController>();

      // Process all items from API response and replace the current list
      final List<String> processedItems = <String>[];

      for (final item in decodedItems) {
        final trimmedItem = item.trim();
        if (trimmedItem.isNotEmpty) {
          // _logger.d('Processing item: $item'); // Disabled - too verbose
          // Parse new item format: Barcode:Eng Name:Ara Name:UOM:Price:V/R:Qty
          final parts = trimmedItem.split(':');
          // _logger.d('Item parts (${parts.length}): $parts'); // Disabled - too verbose

          if (parts.length >= 7) {
            final barcode = parts[0];
            final engName = parts[1];
            final araName = parts[2];
            final uom = parts[3];
            final rawPrice = parts[4];
            final vr = parts[5];
            final qty = parts[6];

            // Convert price: divide by 100 and format with 2 decimal places
            final price = _convertPrice(rawPrice);

            // _logger.d('Parsed - Barcode: $barcode, EngName: $engName, AraName: $araName, UOM: $uom, RawPrice: $rawPrice, ConvertedPrice: $price, VR: $vr, Qty: $qty'); // Disabled - too verbose

            // Format for display: Eng Name (Ara Name) - UOM - Price - Qty
            final displayName = araName.isNotEmpty
                ? '$engName ($araName)'
                : engName;
            final itemString = '$barcode:$displayName:$uom:$price:$qty:$vr';
            // _logger.d('Processing item: $itemString'); // Disabled - too verbose
            processedItems.add(itemString);
          } else {
            _logger.w('Item has insufficient parts (${parts.length}): $item');
          }
        }
      }

      // Replace the entire scanned items list with the current API response
      // Use batch update to minimize UI rebuilds
      appController.setScannedItems(processedItems);

      _logger.i('⚡ Fast-processed ${decodedItems.length} items from ItemLine');
    } catch (e) {
      _logger.e('Error processing ItemLine: $e');
    }
  }

  /// Process Receipt for printing
  void _processReceipt(String receipt) {
    try {
      final decodedReceipt = _decodeBase64Lines(receipt);
      final receiptText = decodedReceipt.join('\n');

      // _logger.i('Decoded receipt for printing:\n$receiptText');

      // Check if receipt contains "MPOS TXN END" text
      final containsMposTxnEnd = receiptText.contains('MPOS TXN END');

      if (containsMposTxnEnd) {
        // If MPOS TXN END is present and we haven't already processed it, print the receipt
        if (!_mposTxnEndPresent) {
          _logger.i('Decoded receipt for printing:\n$receiptText');
          _logger.i(
            'MPOS TXN END detected in receipt (first time) - navigating to printing page and printing receipt',
          );
          print('🖨️ MPOS TXN END: First occurrence - proceeding with print');

          final appController = Get.find<AppController>();
          appController.navigateToPrinting();

          // Automatically print the receipt to USB Epson printer
          _printReceiptToUsbPrinter(receiptText);

          // Set flag to prevent duplicate printing
          _mposTxnEndPresent = true;
        } else {
          _logger.i(
            'MPOS TXN END detected in receipt (duplicate) - ignoring print request',
          );
          print(
            '🖨️ MPOS TXN END: Duplicate detected - ignoring print request',
          );
        }
      } else {
        // If MPOS TXN END is not present, reset the flag
        if (_mposTxnEndPresent) {
          _logger.i(
            'MPOS TXN END no longer present in receipt - resetting duplicate prevention flag',
          );
          print('🖨️ MPOS TXN END: No longer present - resetting flag');
          _mposTxnEndPresent = false;
        }
      }

      // Store receipt for printing (you can implement printing logic here)
      // For now, just log it
    } catch (e) {
      _logger.e('Error processing Receipt: $e');
    }
  }

  /// Print receipt to USB Epson printer using testPrintV2
  Future<void> _printReceiptToUsbPrinter(String receiptText) async {
    try {
      _logger.i('Sending receipt to USB Epson printer using testPrintV2...');
      print('🖨️ MPOS DEBUG: MPOS TXN END detected - calling testPrintV2');
      print(
        '🖨️ MPOS DEBUG: Receipt text length: ${receiptText.length} characters',
      );

      // Get the USB printer service
      final printerService = Get.find<UsbPrinterService>();

      // Print the receipt using testPrintV2 method
      await printerService.testPrintV2(receiptText);

      _logger.i(
        'Receipt printed successfully to USB Epson printer via testPrintV2',
      );
      print('🖨️ MPOS DEBUG: testPrintV2 completed successfully');
    } catch (e) {
      _logger.e('Error printing receipt to USB printer via testPrintV2: $e');
      print('🖨️ MPOS DEBUG: testPrintV2 failed: $e');
    }
  }

  /// Decode base64 lines (similar to your getReceipt method)
  List<String> _decodeBase64Lines(String base64Text) {
    List<String> lines = base64Text.split('\r\n');
    List<String> decodedLines = [];

    for (var line in lines) {
      if (line.trim().isEmpty) {
        decodedLines.add(''); // keep empty lines
        continue;
      }
      try {
        final bytes = base64Decode(line.trim());
        final decodedLine = utf8.decode(bytes);
        decodedLines.add(decodedLine);
      } catch (e) {
        _logger.w('Invalid base64 line skipped: $line');
      }
    }

    return decodedLines;
  }

  /// Send one-time API request with custom DisplayLine
  Future<void> sendOneTimeRequest(String displayLine) async {
    try {
      _logger.i('Sending one-time API request with DisplayLine: $displayLine');

      final bodyData = [
        {
          'DisplayLine': displayLine,
          'IPDevice': ' ',
          'ListenerFlag': 'false',
          'ProcessFlag': 'display',
          'qty': 'This is REST Service.',
          'TerminalID': '500',
        },
      ];

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.i('One-time API request successful: ${response.body}');
        _processApiResponse(response.body);
      } else {
        _logger.e(
          'One-time API request failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      _logger.e('One-time API request error: $e');
    }
  }

  // Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _logger.i('Updating Web API base URL from $_baseUrl to $newBaseUrl');
    _baseUrl = newBaseUrl;
    _logger.i('Web API base URL updated successfully');
  }
}
