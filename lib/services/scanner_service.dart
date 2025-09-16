import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ScannerService extends GetxController {
  static ScannerService get to => Get.find();

  final Logger _logger = Logger();
  
  // Stream controller for scanner data
  final StreamController<String> _scannerController = StreamController<String>.broadcast();
  
  // Observable properties
  final RxBool _isListening = false.obs;
  final RxString _lastScannedCode = ''.obs;
  final RxInt _scanCount = 0.obs;
  
  // Getters
  bool get isListening => _isListening.value;
  String get lastScannedCode => _lastScannedCode.value;
  int get scanCount => _scanCount.value;
  Stream<String> get scannerStream => _scannerController.stream;
  
  // Focus node to capture keyboard input from USB scanner
  final FocusNode _scannerFocusNode = FocusNode();
  String _scanBuffer = '';
  Timer? _scanTimer;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i('ScannerService initialized');
    _setupScannerListener();
  }

  @override
  void onClose() {
    stopListening();
    _scannerController.close();
    _scannerFocusNode.dispose();
    _scanTimer?.cancel();
    super.onClose();
  }

  /// Setup scanner listener for USB scanner input
  void _setupScannerListener() {
    _logger.i('Setting up USB scanner listener...');
    
    // Most USB barcode scanners act as HID keyboards
    // They send keystrokes followed by Enter/Return
    _scannerFocusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        final key = event.logicalKey;
        
        // Handle Enter/Return key (end of scan)
        if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
          if (_scanBuffer.isNotEmpty) {
            _processScanData(_scanBuffer.trim());
            _scanBuffer = '';
            _scanTimer?.cancel();
          }
          return KeyEventResult.handled;
        }
        
        // Handle regular characters
        final character = event.character;
        if (character != null && character.isNotEmpty) {
          _scanBuffer += character;
          
          // Reset timer for scan completion
          _scanTimer?.cancel();
          _scanTimer = Timer(const Duration(milliseconds: 100), () {
            // If no more input for 100ms, consider scan complete
            if (_scanBuffer.isNotEmpty) {
              _processScanData(_scanBuffer.trim());
              _scanBuffer = '';
            }
          });
          
          return KeyEventResult.handled;
        }
      }
      
      return KeyEventResult.ignored;
    };
  }

  /// Process scanned barcode data
  void _processScanData(String scanData) {
    if (scanData.isEmpty) return;
    
    _logger.i('📱 SCANNER DATA RECEIVED');
    _logger.i('🔍 Scanned Code: $scanData');
    _logger.i('📊 Scan Count: ${_scanCount.value + 1}');
    _logger.i('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    // Also print for visibility
    print('📱 SCANNER DATA RECEIVED');
    print('🔍 Scanned Code: $scanData');
    print('📊 Scan Count: ${_scanCount.value + 1}');
    print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    // Update reactive properties
    _lastScannedCode.value = scanData;
    _scanCount.value++;
    
    // Emit to stream for listeners
    _scannerController.add(scanData);
  }

  /// Start listening for scanner input
  void startListening() {
    if (_isListening.value) {
      _logger.w('Scanner is already listening');
      return;
    }
    
    _logger.i('🎯 Starting USB scanner listener...');
    _isListening.value = true;
    
    // Request focus to capture keyboard events
    _scannerFocusNode.requestFocus();
    
    _logger.i('✅ USB scanner listener started successfully');
    print('🎯 USB Scanner listening for barcode data...');
  }

  /// Stop listening for scanner input
  void stopListening() {
    if (!_isListening.value) {
      _logger.w('Scanner is not currently listening');
      return;
    }
    
    _logger.i('⏹️ Stopping USB scanner listener...');
    _isListening.value = false;
    
    // Unfocus to stop capturing keyboard events
    _scannerFocusNode.unfocus();
    
    // Clear any pending scan data
    _scanBuffer = '';
    _scanTimer?.cancel();
    
    _logger.i('✅ USB scanner listener stopped');
    print('⏹️ USB Scanner listener stopped');
  }

  /// Get scanner focus node for UI integration
  FocusNode get focusNode => _scannerFocusNode;

  /// Test scanner functionality
  void testScanner() {
    _logger.i('🧪 Testing scanner functionality...');
    // Test with a 13-digit barcode (should get <80> appended)
    final testBarcode = '1234567890123'; // 13 digits
    _logger.i('🧪 Testing with 13-digit barcode: $testBarcode');
    _processScanData(testBarcode);
  }

  /// Test scanner with long barcode
  void testScannerLong() {
    _logger.i('🧪 Testing scanner with long barcode...');
    // Test with a longer barcode (should be sent as-is)
    final testBarcode = '12345678901234567890'; // 20 digits
    _logger.i('🧪 Testing with 20-digit barcode: $testBarcode');
    _processScanData(testBarcode);
  }

  /// Get scanner status information
  String getScannerStatus() {
    return 'Scanner Status: ${_isListening.value ? "Listening" : "Stopped"} | '
           'Last Scanned: ${_lastScannedCode.value.isEmpty ? "None" : _lastScannedCode.value} | '
           'Total Scans: ${_scanCount.value}';
  }

  /// Clear scanner statistics
  void clearStats() {
    _lastScannedCode.value = '';
    _scanCount.value = 0;
    _logger.i('Scanner statistics cleared');
  }
}
