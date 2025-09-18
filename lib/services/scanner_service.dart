import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ScannerService extends GetxController {
  static ScannerService get to => Get.find();

  final Logger _logger = Logger();

  // Stream controller for scanner data
  final StreamController<String> _scannerController =
      StreamController<String>.broadcast();

  // Observable properties
  final RxBool _isListening = false.obs;
  final RxString _lastScannedCode = ''.obs;
  final RxInt _scanCount = 0.obs;
  final RxInt _partialScans = 0.obs;
  final RxInt _validScans = 0.obs;

  // Getters
  bool get isListening => _isListening.value;
  String get lastScannedCode => _lastScannedCode.value;
  int get scanCount => _scanCount.value;
  int get partialScans => _partialScans.value;
  int get validScans => _validScans.value;
  Stream<String> get scannerStream => _scannerController.stream;

  // Focus node to capture keyboard input from USB scanner
  final FocusNode _scannerFocusNode = FocusNode();
  String _scanBuffer = '';
  Timer? _scanTimer;

  // Enhanced scanner configuration - these constants are used in _processScanData
  static const int _minBarcodeLength = 8; // Minimum expected barcode length
  static const int _maxBarcodeLength = 20; // Maximum expected barcode length
  static const int _scanTimeoutMs =
      300; // Increased timeout for slower scanners
  static const int _maxRetryAttempts =
      3; // Maximum retry attempts for partial scans

  // Retry mechanism - these variables are used throughout the scanning process
  int _currentRetryCount = 0;
  String? _lastPartialScan;

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
        if (key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.numpadEnter) {
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

          // Reset timer for scan completion with extended timeout
          _scanTimer?.cancel();
          _scanTimer = Timer(Duration(milliseconds: _scanTimeoutMs), () {
            // If no more input for the timeout period, consider scan complete
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

  /// Process scanned barcode data with validation and retry logic
  void _processScanData(String scanData) {
    if (scanData.isEmpty) return;

    final barcodeLength = scanData.length;
    final isValidLength =
        barcodeLength >= _minBarcodeLength &&
        barcodeLength <= _maxBarcodeLength;
    final isNumeric = RegExp(r'^[0-9]+$').hasMatch(scanData);

    _logger.i('📱 SCANNER DATA RECEIVED');
    _logger.i('🔍 Scanned Code: $scanData');
    _logger.i('📏 Length: $barcodeLength');
    _logger.i('🔢 Is Numeric: $isNumeric');
    _logger.i(
      '✅ Valid Length: $isValidLength (${_minBarcodeLength}-${_maxBarcodeLength})',
    );
    _logger.i('📊 Total Scans: ${_scanCount.value + 1}');
    _logger.i('🔄 Current Retry: $_currentRetryCount/${_maxRetryAttempts}');
    _logger.i('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Also print for visibility
    print('📱 SCANNER DATA RECEIVED');
    print('🔍 Scanned Code: $scanData');
    print('📏 Length: $barcodeLength');
    print('🔢 Is Numeric: $isNumeric');
    print(
      '✅ Valid Length: $isValidLength (${_minBarcodeLength}-${_maxBarcodeLength})',
    );
    print('📊 Total Scans: ${_scanCount.value + 1}');
    print('🔄 Current Retry: $_currentRetryCount/${_maxRetryAttempts}');
    print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Update scan count
    _scanCount.value++;

    // Validate barcode
    if (!isValidLength || !isNumeric) {
      _partialScans.value++;
      _logger.w('⚠️ PARTIAL/INVALID BARCODE DETECTED');
      _logger.w(
        'Expected: ${_minBarcodeLength}-${_maxBarcodeLength} numeric digits',
      );
      _logger.w('Received: $barcodeLength characters: "$scanData"');
      print('⚠️ PARTIAL/INVALID BARCODE DETECTED');
      print(
        'Expected: ${_minBarcodeLength}-${_maxBarcodeLength} numeric digits',
      );
      print('Received: $barcodeLength characters: "$scanData"');

      // Handle retry logic for partial scans
      if (barcodeLength < _minBarcodeLength &&
          _currentRetryCount < _maxRetryAttempts) {
        _currentRetryCount++;
        _lastPartialScan = scanData;
        _logger.i(
          '🔄 Retrying scan... Attempt $_currentRetryCount/$_maxRetryAttempts',
        );
        print(
          '🔄 Retrying scan... Attempt $_currentRetryCount/$_maxRetryAttempts',
        );

        // Wait a bit longer for the next scan attempt
        Timer(const Duration(milliseconds: 500), () {
          if (_scanBuffer.isEmpty) {
            _logger.w('⚠️ No additional data received during retry period');
            print('⚠️ No additional data received during retry period');
            _handleFailedScan(scanData);
          }
        });
        return;
      } else {
        _handleFailedScan(scanData);
        return;
      }
    }

    // Valid barcode received
    _validScans.value++;
    _currentRetryCount = 0; // Reset retry counter
    _lastPartialScan = null;

    _logger.i('✅ VALID BARCODE CONFIRMED');
    _logger.i('🎯 Processing barcode: $scanData');
    print('✅ VALID BARCODE CONFIRMED');
    print('🎯 Processing barcode: $scanData');

    // Update reactive properties
    _lastScannedCode.value = scanData;

    // Emit to stream for listeners
    _scannerController.add(scanData);
  }

  /// Handle failed scan attempts
  void _handleFailedScan(String partialData) {
    _currentRetryCount = 0;
    _lastPartialScan = null;

    _logger.e('❌ SCAN FAILED AFTER RETRIES');
    _logger.e('Partial data: "$partialData" (Length: ${partialData.length})');
    _logger.e('Please rescan the barcode');
    print('❌ SCAN FAILED AFTER RETRIES');
    print('Partial data: "$partialData" (Length: ${partialData.length})');
    print('Please rescan the barcode');

    // Optionally, you could emit a special error event or show a user notification
    // For now, we'll just log the failure
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

    // Clear any pending scan data and reset retry state
    _scanBuffer = '';
    _scanTimer?.cancel();
    _currentRetryCount = 0;
    _lastPartialScan = null;

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

  /// Test scanner with partial barcode (simulates the issue)
  void testPartialBarcode() {
    _logger.i('🧪 Testing scanner with partial barcode...');
    // Test with a partial barcode (simulates the issue)
    final partialBarcode = '12345678'; // 8 digits (partial)
    _logger.i('🧪 Testing with 8-digit partial barcode: $partialBarcode');
    _processScanData(partialBarcode);
  }

  /// Test scanner with invalid barcode
  void testInvalidBarcode() {
    _logger.i('🧪 Testing scanner with invalid barcode...');
    // Test with invalid characters
    final invalidBarcode = '123ABC456'; // Contains letters
    _logger.i('🧪 Testing with invalid barcode: $invalidBarcode');
    _processScanData(invalidBarcode);
  }

  /// Get detailed scanner statistics
  Map<String, dynamic> getDetailedStats() {
    return {
      'isListening': _isListening.value,
      'totalScans': _scanCount.value,
      'validScans': _validScans.value,
      'partialScans': _partialScans.value,
      'lastScannedCode': _lastScannedCode.value,
      'currentRetryCount': _currentRetryCount,
      'lastPartialScan': _lastPartialScan,
      'scanBuffer': _scanBuffer,
      'successRate': _scanCount.value > 0
          ? (_validScans.value / _scanCount.value * 100).toStringAsFixed(1) +
                '%'
          : '0%',
    };
  }

  /// Get scanner status information
  String getScannerStatus() {
    return 'Scanner Status: ${_isListening.value ? "Listening" : "Stopped"} | '
        'Last Scanned: ${_lastScannedCode.value.isEmpty ? "None" : _lastScannedCode.value} | '
        'Total Scans: ${_scanCount.value} | Valid: ${_validScans.value} | Partial: ${_partialScans.value}';
  }

  /// Clear scanner statistics
  void clearStats() {
    _lastScannedCode.value = '';
    _scanCount.value = 0;
    _partialScans.value = 0;
    _validScans.value = 0;
    _currentRetryCount = 0;
    _lastPartialScan = null;
    _logger.i('Scanner statistics cleared');
  }
}
