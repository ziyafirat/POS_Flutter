import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../models/app_state.dart';

class WebApiService extends GetxController {
  static WebApiService get to => Get.find();
  
  final Logger _logger = Logger();
  Timer? _apiTimer;
  bool _isRunning = false;
  
  // API Configuration
  static const String _baseUrl = 'http://192.168.3.90:50000/AEFProcess/restaefprocess/aefrun/posService';
  static const Duration _loopInterval = Duration(seconds: 1);
  
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
  
  /// Start the API loop that runs every 3 seconds
  void startApiLoop() {
    if (_isRunning) {
      _logger.w('API loop is already running');
      return;
    }
    
    _logger.i('Starting API loop with ${_loopInterval.inSeconds}s interval');
    _isRunning = true;
    _isConnected.value = true;
    
    // Start the timer
    _apiTimer = Timer.periodic(_loopInterval, (timer) {
      _makeApiRequest();
    });
    
    // Make initial request immediately
    _makeApiRequest();
  }
  
  /// Stop the API loop
  void stopApiLoop() {
    if (!_isRunning) {
      _logger.w('API loop is not running');
      return;
    }
    
    _logger.i('Stopping API loop');
    _isRunning = false;
    _isConnected.value = false;
    _apiTimer?.cancel();
    _apiTimer = null;
  }
  
  /// Make a single API request
  Future<void> _makeApiRequest() async {
    try {
      _logger.d('Making API request #${_requestCount.value + 1}');
      
      // Prepare request data matching cURL command exactly
      final bodyData = _prepareRequestData();
      
      // Make HTTP POST request with exact cURL headers
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 10));
      
      // Update counters
      _requestCount.value++;
      
      // Handle response
      if (response.statusCode == 200) {
        _lastResponse.value = response.body;
        _lastError.value = '';
        _logger.d('API request successful: ${response.body}');
        
        // Process the response
        _processApiResponse(response.body);
      } else {
        _lastError.value = 'HTTP ${response.statusCode}: ${response.body}';
        _logger.e('API request failed: ${response.statusCode} - ${response.body}');
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
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 5));
      
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
  
  /// Process API response and update app state
  void _processApiResponse(String responseBody) {
    try {
      // Clean the response body to handle control characters in Display field
      final cleanedResponseBody = _cleanResponseBody(responseBody);
      final responseData = jsonDecode(cleanedResponseBody);
      
      // Update total amount from BalanceDue
      if (responseData['BalanceDue'] != null && responseData['BalanceDue'] != 'null') {
        final balanceDue = double.tryParse(responseData['BalanceDue'].toString()) ?? 0.0;
        final appController = Get.find<AppController>();
        appController.updateTotalAmount(balanceDue);
      }
      
      // Process Display field for screen display
      if (responseData['Display'] != null && responseData['Display'].toString().isNotEmpty) {
        final displayText = responseData['Display'].toString();
        final appController = Get.find<AppController>();
        appController.updateDisplayText(displayText);
      }
      
      // Handle navigation based on PosSubState
      if (responseData['PosSubState'] != null) {
        final posSubState = responseData['PosSubState'].toString();
        final appController = Get.find<AppController>();
        appController.updatePosSubState(posSubState);
        _handlePosSubStateNavigation(posSubState);
      }
      
      // Process ItemLine for scanned items
      if (responseData['ItemLine'] != null && responseData['ItemLine'].toString().isNotEmpty) {
        final itemLine = responseData['ItemLine'].toString();
        _processItemLine(itemLine);
      }
      
      // Process Receipt for printing
      if (responseData['Receipt'] != null && responseData['Receipt'].toString().isNotEmpty) {
        final receipt = responseData['Receipt'].toString();
        _processReceipt(receipt);
      }
      
    } catch (e) {
      _logger.e('Error processing API response: $e');
    }
  }
  
  /// Handle navigation based on PosSubState
  void _handlePosSubStateNavigation(String posSubState) {
    final appController = Get.find<AppController>();
    
    // Skip automatic navigation if currently in POS Cashier screen
    if (appController.appState.value.currentScreen == AppScreen.posCashier) {
      _logger.i('Skipping automatic navigation - currently in POS Cashier screen (PosSubState: $posSubState)');
      return;
    }
    
    switch (posSubState) {
      case '1002':
        _logger.i('Navigating to item scan page (PosSubState: $posSubState)');
        appController.navigateToScreen(AppScreen.itemScan);
        break;
      case '1010':
        _logger.i('Navigating to payment page (PosSubState: $posSubState)');
        appController.navigateToScreen(AppScreen.payment);
        break;
      case '1001':
        _logger.i('Navigating to start page (PosSubState: $posSubState)');
        appController.navigateToScreen(AppScreen.itemScan);
        break;
     case '1008':
        _logger.i('Navigating to start page (PosSubState: $posSubState)');
        appController.navigateToScreen(AppScreen.start);
        break;
      default:
        _logger.d('Unknown PosSubState: $posSubState');
        break;
    }
  }
  
  /// Clean response body to handle control characters
  String _cleanResponseBody(String responseBody) {
    // Replace control characters in Display field with escaped characters
    return responseBody.replaceAllMapped(
      RegExp(r'"Display":\s*"([^"]*)"'),
      (match) {
        final displayContent = match.group(1) ?? '';
        // Replace newlines and other control characters with escaped versions
        final cleanedDisplay = displayContent
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r')
            .replaceAll('\t', '\\t');
        return '"Display": "$cleanedDisplay"';
      },
    );
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
      _logger.d('Processing ItemLine: $itemLine');
      final decodedItems = _decodeBase64Lines(itemLine);
      _logger.d('Decoded ${decodedItems.length} items: $decodedItems');
      
      final appController = Get.find<AppController>();
      
      // Clear existing items and add new ones
      appController.clearScannedItems();
      
      for (final item in decodedItems) {
        if (item.trim().isNotEmpty) {
          _logger.d('Processing item: $item');
          // Parse new item format: Barcode:Eng Name:Ara Name:UOM:Price:V/R:Qty
          final parts = item.split(':');
          _logger.d('Item parts (${parts.length}): $parts');
          
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
            
            _logger.d('Parsed - Barcode: $barcode, EngName: $engName, AraName: $araName, UOM: $uom, RawPrice: $rawPrice, ConvertedPrice: $price, VR: $vr, Qty: $qty');
            
            // Format for display: Eng Name (Ara Name) - UOM - Price - Qty
            final displayName = araName.isNotEmpty ? '$engName ($araName)' : engName;
            final itemString = '$barcode:$displayName:$uom:$price:$qty:$vr';
            _logger.d('Adding item: $itemString');
            appController.addScannedItem(itemString);
          } else {
            _logger.w('Item has insufficient parts (${parts.length}): $item');
          }
        }
      }
      
      _logger.i('Processed ${decodedItems.length} items from ItemLine');
    } catch (e) {
      _logger.e('Error processing ItemLine: $e');
    }
  }
  
  /// Process Receipt for printing
  void _processReceipt(String receipt) {
    try {
      final decodedReceipt = _decodeBase64Lines(receipt);
      final receiptText = decodedReceipt.join('\n');
      
      _logger.i('Decoded receipt for printing:\n$receiptText');
      
      // Store receipt for printing (you can implement printing logic here)
      // For now, just log it
      
    } catch (e) {
      _logger.e('Error processing Receipt: $e');
    }
  }
  
  /// Decode base64 lines (similar to your getReceipt method)
  List<String> _decodeBase64Lines(String base64Text) {
    List<String> lines = base64Text.split("\r\n");
    List<String> decodedLines = [];
    
    for (var line in lines) {
      if (line.trim().isEmpty) {
        decodedLines.add(""); // keep empty lines
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
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.i('One-time API request successful: ${response.body}');
        _processApiResponse(response.body);
      } else {
        _logger.e('One-time API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.e('One-time API request error: $e');
    }
  }
}
