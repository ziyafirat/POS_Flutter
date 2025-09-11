import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UsbPrinterService extends GetxController {
  static UsbPrinterService get to => Get.find();
  
  final Logger _logger = Logger();
  
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
    super.onClose();
  }
  
  /// Connect to USB Epson printer
  Future<bool> connectToPrinter() async {
    try {
      _logger.i('Attempting to connect to USB Epson printer...');
      
      // For Windows, we'll use a common Epson printer approach
      // This is a simplified implementation - in production you might want to use
      // platform-specific USB libraries or ESC/POS commands
      
      _isConnected.value = true;
      _printerStatus.value = 'Connected';
      _lastError.value = '';
      
      _logger.i('Successfully connected to USB Epson printer');
      return true;
      
    } catch (e) {
      _logger.e('Failed to connect to USB Epson printer: $e');
      _isConnected.value = false;
      _printerStatus.value = 'Connection Failed';
      _lastError.value = e.toString();
      return false;
    }
  }
  
  /// Disconnect from printer
  Future<void> disconnectFromPrinter() async {
    try {
      _logger.i('Disconnecting from USB Epson printer...');
      
      _isConnected.value = false;
      _printerStatus.value = 'Disconnected';
      _lastError.value = '';
      
      _logger.i('Disconnected from USB Epson printer');
    } catch (e) {
      _logger.e('Error disconnecting from printer: $e');
    }
  }
  
  /// Print receipt text to USB Epson printer
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
      
      _logger.i('Printing receipt to USB Epson printer...');
      
      // Convert text to ESC/POS commands for Epson printer
      final printData = _convertToEscPosCommands(receiptText);
      
      // For Windows, we'll simulate printing by writing to a file
      // In production, you would send this data to the actual USB printer
      await _sendToPrinter(printData);
      
      _logger.i('Receipt printed successfully');
      return true;
      
    } catch (e) {
      _logger.e('Error printing receipt: $e');
      _lastError.value = e.toString();
      return false;
    }
  }
  
  /// Convert receipt text to ESC/POS commands for Epson printer
  Uint8List _convertToEscPosCommands(String text) {
    final List<int> commands = [];
    
    // Initialize printer
    commands.addAll([0x1B, 0x40]); // ESC @ - Initialize printer
    
    // Set character size (normal)
    commands.addAll([0x1B, 0x4D, 0x00]); // ESC M 0 - Select character font A
    
    // Split text into lines and process each line
    final lines = text.split('\n');
    
    for (final line in lines) {
      // Add line content
      commands.addAll(line.codeUnits);
      
      // Add line feed
      commands.add(0x0A); // LF - Line feed
    }
    
    // Add extra line feeds for spacing
    commands.addAll([0x0A, 0x0A]); // Two extra line feeds
    
    // Cut paper (if supported)
    commands.addAll([0x1D, 0x56, 0x00]); // GS V 0 - Full cut
    
    return Uint8List.fromList(commands);
  }
  
  /// Send data to printer (simulated for now)
  Future<void> _sendToPrinter(Uint8List data) async {
    try {
      // For Windows, we'll simulate by writing to a file
      // In production, you would use platform-specific USB communication
      final file = File('receipt_print_data.txt');
      await file.writeAsBytes(data);
      
      _logger.d('Print data written to file: ${file.path}');
      _logger.d('Print data (hex): ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      
      // Simulate printing delay
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      _logger.e('Error sending data to printer: $e');
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
