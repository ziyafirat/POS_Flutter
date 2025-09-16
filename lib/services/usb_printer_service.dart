import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UsbPrinterService extends GetxController {
  static UsbPrinterService get to => Get.find();
  
  final Logger _logger = Logger();
  
  // Platform channel for USB printer communication
  static const MethodChannel _channel = MethodChannel('usb_printer');
  
  // Observable properties
  final RxBool _isConnected = false.obs;
  final RxString _lastError = ''.obs;
  final RxString _printerStatus = 'Disconnected'.obs;
  
  // Getters
  bool get isConnected => _isConnected.value;
  String get lastError => _lastError.value;
  String get printerStatus => _printerStatus.value;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i('UsbPrinterService initialized');
  }
  
  @override
  void onClose() {
    disconnectFromPrinter();
    super.onClose();
  }
  
  /// Connect to USB thermal printer
  Future<bool> connectToPrinter() async {
    try {
      _logger.i('Attempting to connect to TM-M30 USB thermal printer...');
      
      // Call native method to connect to USB printer
      final result = await _channel.invokeMethod('connectPrinter', {
        'vendorId': 1208, // Seiko Epson Corporation (TM-M30 vendor ID)
        'productId': 514, // TM-M30 product ID (may vary)
        'printerName': 'TM-M30',
      });
      
      if (result['success'] == true) {
        _isConnected.value = true;
        _printerStatus.value = 'Connected to ${result['printerName'] ?? 'TM-M30'}';
        _lastError.value = '';
        
        _logger.i('Successfully connected to TM-M30 USB thermal printer');
        return true;
      } else {
        throw Exception(result['error'] ?? 'Unknown connection error');
      }
      
    } catch (e) {
      _logger.e('Failed to connect to USB thermal printer: $e');
      _isConnected.value = false;
      _printerStatus.value = 'Connection Failed';
      _lastError.value = e.toString();
      return false;
    }
  }
  
  /// Disconnect from printer
  Future<void> disconnectFromPrinter() async {
    try {
      if (_isConnected.value) {
        _logger.i('Disconnecting from TM-M30 USB thermal printer...');
        
        // Call native method to disconnect
        await _channel.invokeMethod('disconnectPrinter');
      }
      
      _isConnected.value = false;
      _printerStatus.value = 'Disconnected';
      _lastError.value = '';
      
      _logger.i('Disconnected from TM-M30 USB thermal printer');
    } catch (e) {
      _logger.e('Error disconnecting from printer: $e');
    }
  }
  
  /// Print receipt text to TM-M30 USB thermal printer
  Future<bool> printReceipt(String receiptText) async {
    try {
      if (!_isConnected.value) {
        _logger.w('Printer not connected. Attempting to connect...');
        final connected = await connectToPrinter();
        if (!connected) {
          _logger.e('Failed to connect to printer for printing');
          return false;
        }
      }
      
      _logger.i('Printing receipt to TM-M30 USB thermal printer...');
      
      // Generate ESC/POS commands for TM-M30
      final printData = _generateEscPosCommands(receiptText);
      
      // Send to TM-M30 printer (simulated for now)
      await _sendToTmM30Printer(printData);
      
      _logger.i('Receipt printed successfully to TM-M30 thermal printer');
      return true;
      
    } catch (e) {
      _logger.e('Error printing receipt: $e');
      _lastError.value = e.toString();
      return false;
    }
  }

  /// Generate ESC/POS commands for TM-M30 thermal printer
  Uint8List _generateEscPosCommands(String text) {
    final List<int> commands = [];
    
    // Initialize printer
    commands.addAll([0x1B, 0x40]); // ESC @ - Initialize printer
    
    // Set character size (normal)
    commands.addAll([0x1B, 0x4D, 0x00]); // ESC M 0 - Select character font A
    
    // Split text into lines and process each line
    final lines = text.split('\n');
    
    for (final line in lines) {
      // Add line content (UTF-8 encoded)
      commands.addAll(line.codeUnits);
      
      // Add line feed
      commands.add(0x0A); // LF - Line feed
    }
    
    // Add extra line feeds for spacing
    commands.addAll([0x0A, 0x0A, 0x0A]); // Three extra line feeds
    
    // Cut paper (TM-M30 specific)
    commands.addAll([0x1D, 0x56, 0x00]); // GS V 0 - Full cut
    
    return Uint8List.fromList(commands);
  }

  /// Send ESC/POS data to TM-M30 printer
  Future<void> _sendToTmM30Printer(Uint8List data) async {
    try {
      _logger.d('Sending ${data.length} bytes to TM-M30 printer...');
      _logger.d('ESC/POS data (hex): ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      
      // Send data to TM-M30 via USB using platform channel
      final result = await _channel.invokeMethod('printData', {
        'data': data,
      });
      
      if (result['success'] == true) {
        _logger.i('ESC/POS data sent successfully to TM-M30 printer');
      } else {
        throw Exception(result['error'] ?? 'Print failed');
      }
      
    } catch (e) {
      _logger.e('Error sending data to TM-M30 printer: $e');
      rethrow;
    }
  }

  /// Test printer connection
  Future<bool> testPrint() async {
    try {
      _logger.i('Testing printer with sample text...');
      
      final now = DateTime.now();
      final testText = '''
=== PRINTER TEST ===
Date: $now
Time: ${now.toString().substring(11, 19)}
Status: Working
==================
''';
      
      return await printReceipt(testText);
      
    } catch (e) {
      _logger.e('Printer test failed: $e');
      return false;
    }
  }
  
  /// Get printer status information
  Map<String, dynamic> getPrinterStatus() {
    return {
      'isConnected': _isConnected.value,
      'status': _printerStatus.value,
      'lastError': _lastError.value,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
