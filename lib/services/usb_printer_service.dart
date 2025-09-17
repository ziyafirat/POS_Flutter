import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_pos_printer_platform_image_3_sdt/flutter_pos_printer_platform_image_3_sdt.dart';
import 'package:flutter_pos_printer_platform_image_3_sdt/esc_pos_utils_platform/flutter_esc_pos_utils.dart';


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


  final PrinterManager _printerManager = PrinterManager.instance;

  // Hardcoded Epson TM-m30 info
  final int vendorId = 1208;   // Seiko Epson Corp
  final int productId = 3616;  // TM-m30 model
  final String printerName = "TM-m30 Bluetooth";

  Future<void> testPrintV2(String receiptText) async {
    try {
      print('🖨️ V2 DEBUG: Starting testPrintV2...');
      print('🖨️ V2 DEBUG: Using VID:$vendorId PID:$productId Name:$printerName');
      
      // ESC/POS generator
      print('🖨️ V2 DEBUG: Loading capability profile...');
      final profile = await CapabilityProfile.load(name: 'default');
      final generator = Generator(PaperSize.mm80, profile);
      print('🖨️ V2 DEBUG: Generator created successfully');

      List<int> bytes = [];
      bytes += generator.text(
        '*** ALMAYA SUPERMARKET ***',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
       bytes += generator.text(
        receiptText,
        styles: const PosStyles(align: PosAlign.left),
      );
      bytes += generator.feed(2);
      bytes += generator.cut();
      
      print('🖨️ V2 DEBUG: Generated ${bytes.length} bytes of ESC/POS data');

      // Connect via USB
      print('🖨️ V2 DEBUG: Attempting to connect to printer...');
      await _printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: printerName,
          productId: productId.toString(),
          vendorId: vendorId.toString(),
        ),
      );
      print('🖨️ V2 DEBUG: Connected to printer successfully');

      // Send data
      print('🖨️ V2 DEBUG: Sending ${bytes.length} bytes to printer...');
      await _printerManager.send(type: PrinterType.usb, bytes: bytes);
      print('🖨️ V2 DEBUG: Data sent successfully');

      // Disconnect (optional, but good practice)
      print('🖨️ V2 DEBUG: Disconnecting from printer...');
      await _printerManager.disconnect(type: PrinterType.usb);
      print('🖨️ V2 DEBUG: Disconnected successfully');

      print("✅ Test print V2 completed successfully for Epson TM-m30");
    } catch (e) {
      print("❌ USB print V2 error: $e");
      print("❌ Error type: ${e.runtimeType}");
      if (e.toString().contains('Return code: -1')) {
        print("❌ DIAGNOSIS: Return code -1 indicates:");
        print("   - Printer not responding (check power/connection)");
        print("   - USB communication timeout");
        print("   - Printer in error state (paper jam, out of paper, etc.)");
        print("   - Wrong VID/PID (try 'List USB Devices' to verify)");
      }
      rethrow;
    }
  }

  Future<void> testPrintV2old() async {
    try {
      print('🖨️ V2 DEBUG: Starting testPrintV2...');
      print(
        '🖨️ V2 DEBUG: Using VID:$vendorId PID:$productId Name:$printerName',
      );

      final devices = await PrinterManager.instance
          .discovery(type: PrinterType.usb)
          .toList();
      for (var d in devices) {
        print(
          'Found USB device: ${d.name} VID:${d.vendorId} PID:${d.productId}',
        );
      }
      // ESC/POS generator
      print('🖨️ V2 DEBUG: Loading capability profile...');
      final profile = await CapabilityProfile.load(name: 'XP-N160I');
      // final profile = await CapabilityProfile.load(
      // name: 'default',
      // ); // or epson.json if you have it
      final generator = Generator(PaperSize.mm80, profile);
      print('🖨️ V2 DEBUG: Generator created successfully');

      List<int> bytes = [];
      bytes += generator.text(
        'I213 - IDOL -GITEX 2024',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      // bytes += generator.text(
      //   'I213 - IDOL -GITEX 2024 00000',
      //   styles: const PosStyles(align: PosAlign.center, bold: true),
      // );
      // bytes += generator.feed(2);
      // bytes += generator.cut();

      print('🖨️ V2 DEBUG: Generated ${bytes.length} bytes of ESC/POS data');

      // Connect via USB
      print('🖨️ V2 DEBUG: Attempting to connect to printer...');
      // await _printerManager.connect(
      //   type: PrinterType.usb,
      //   model: UsbPrinterInput(
      //     name: printerName,
      //     productId: productId.toString(),
      //     vendorId: vendorId.toString(),
      //   ),
      // );

      // Connect to printer
      final printerManager = PrinterManager.instance;
      final result = await printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: printerName,
          productId: productId.toString(), // must be String
          vendorId: vendorId.toString(), // must be String
        ),
      );

      print("USB connect result: $result");

      print('USB connect result: $result');
      print('🖨️ V2 DEBUG: Connected to printer successfully');

      // Send data
      print('🖨️ V2 DEBUG: Sending ${bytes.length} bytes to printer...');
      await _printerManager.send(type: PrinterType.usb, bytes: bytes);
      print('🖨️ V2 DEBUG: Data sent successfully');

      // Disconnect (optional, but good practice)
      print('🖨️ V2 DEBUG: Disconnecting from printer...');
      await _printerManager.disconnect(type: PrinterType.usb);
      print('🖨️ V2 DEBUG: Disconnected successfully');

      print('✅ Test print V2 completed successfully for Epson TM-m30');
    } catch (e) {
      print('❌ USB print V2 error: $e');
      print('❌ Error type: ${e.runtimeType}');
      if (e.toString().contains('Return code: -1')) {
        print('❌ DIAGNOSIS: Return code -1 indicates:');
        print('   - Printer not responding (check power/connection)');
        print('   - USB communication timeout');
        print('   - Printer in error state (paper jam, out of paper, etc.)');
        print('   - Wrong VID/PID (try \'List USB Devices\' to verify)');
      }
      rethrow;
    }
  }


  
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
      print('🖨️ PRINTER DEBUG: Starting connection to TM-M30...');
      
      // Call native method to connect to USB printer
      _logger.d('🔌 Calling platform channel connectPrinter...');
      print('🖨️ PRINTER DEBUG: Calling Android platform channel...');
      try {
        final result = await _channel.invokeMethod('connectPrinter', {
          'vendorId': 1208, // Seiko Epson Corporation (TM-M30 vendor ID)
          'productId': 3616, // TM-M30 product ID (may vary)
          'printerName': 'TM-m30 Bluetooth', // Optional printer name
        });
        
        _logger.d('🔌 Platform channel response: $result');
        
        if (result != null && result is Map && result['success'] == true) {
          _isConnected.value = true;
          _printerStatus.value = 'Connected to ${result['printerName'] ?? 'TM-M30'}';
          _lastError.value = '';
          
          _logger.i('✅ Successfully connected to TM-M30 USB thermal printer via platform channel');
          return true;
        } else {
          final error = result?['error'] ?? 'Platform channel returned null or failed';
          _logger.e('❌ Platform channel connection failed: $error');
          throw Exception(error);
        }
      } on PlatformException catch (e) {
        _logger.e('❌ Platform channel exception: ${e.code} - ${e.message}');
        throw Exception('Platform channel error: ${e.message}');
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
      _logger.d('📤 Sending ${data.length} bytes to TM-M30 printer...');
      _logger.d('📤 ESC/POS data (hex): ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      
      // Debug: Print the actual ESC/POS commands being sent
      print('🖨️ PRINTER DEBUG: Sending ${data.length} bytes to TM-M30');
      print('🖨️ PRINTER DEBUG: Data (hex): ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      
      // Send data to TM-M30 via USB using platform channel
      _logger.d('📱 Calling platform channel printData...');
      print('🖨️ PRINTER DEBUG: Calling platform channel printData...');
      
      try {
        final result = await _channel.invokeMethod('printData', {
          'data': data,
        });
        
        _logger.d('📱 Platform channel printData response: $result');
        print('🖨️ PRINTER DEBUG: Platform response: $result');
        
        if (result != null && result is Map && result['success'] == true) {
          final bytesTransferred = result['bytesTransferred'] ?? 0;
          _logger.i('✅ ESC/POS data sent successfully to TM-M30 printer ($bytesTransferred bytes transferred)');
          print('🖨️ PRINTER DEBUG: SUCCESS - $bytesTransferred bytes transferred to TM-M30');
        } else {
          final error = result?['error'] ?? 'Platform channel returned null or failed';
          _logger.e('❌ Platform channel print failed: $error');
          print('🖨️ PRINTER DEBUG: FAILED - $error');
          throw Exception(error);
        }
      } on PlatformException catch (e) {
        _logger.e('❌ Platform channel exception during print: ${e.code} - ${e.message}');
        print('🖨️ PRINTER DEBUG: Platform exception - ${e.code}: ${e.message}');
        throw Exception('Platform channel error: ${e.message}');
      }
      
    } catch (e) {
      _logger.e('Error sending data to TM-M30 printer: $e');
      print('🖨️ PRINTER DEBUG: Send error - $e');
      rethrow;
    }
  }

  /// Test printer connection
  Future<bool> testPrint() async {
    try {
      _logger.i('🖨️ Testing printer with sample text...');
      print('🖨️ PRINTER DEBUG: Starting test print...');
      
      // First, try to connect to the printer
      _logger.i('🖨️ Ensuring printer connection...');
      final connected = await connectToPrinter();
      
      if (!connected) {
        _logger.e('🖨️ Failed to connect to printer for test');
        print('🖨️ PRINTER DEBUG: Connection failed');
        return false;
      }
      
      print('🖨️ PRINTER DEBUG: Connection successful, generating test text...');
      
      final now = DateTime.now();
      final testText = '''
=== PRINTER TEST ===
Date: ${now.day}/${now.month}/${now.year}
Time: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}
Device: Epson TM-M30
Status: Working
==================
Test completed successfully!
''';
      
      print('🖨️ PRINTER DEBUG: Test text generated, calling printReceipt...');
      final result = await printReceipt(testText);
      
      if (result) {
        print('🖨️ PRINTER DEBUG: Test print completed successfully');
      } else {
        print('🖨️ PRINTER DEBUG: Test print failed');
      }
      
      return result;
      
    } catch (e) {
      _logger.e('🖨️ Printer test failed: $e');
      print('🖨️ PRINTER DEBUG: Test print exception: $e');
      return false;
    }
  }
  
  /// Validate USB connection before printing
  Future<bool> validateConnection() async {
    try {
      _logger.i('🖨️ Validating USB printer connection...');
      print('🖨️ PRINTER DEBUG: Validating connection...');
      
      if (!_isConnected.value) {
        print('🖨️ PRINTER DEBUG: Not connected, attempting to connect...');
        return await connectToPrinter();
      }
      
      // Test the connection by checking device availability
      final result = await _channel.invokeMethod('validateConnection');
      
      if (result != null && result is Map && result['success'] == true) {
        print('🖨️ PRINTER DEBUG: Connection validation successful');
        return true;
      } else {
        print('🖨️ PRINTER DEBUG: Connection validation failed, reconnecting...');
        _isConnected.value = false;
        return await connectToPrinter();
      }
      
    } catch (e) {
      _logger.e('🖨️ Connection validation failed: $e');
      print('🖨️ PRINTER DEBUG: Validation exception: $e');
      _isConnected.value = false;
      return false;
    }
  }

  /// List all connected USB devices
  Future<Map<String, dynamic>> listUsbDevices() async {
    try {
      _logger.i('🔍 Listing all connected USB devices...');
      print('🔍 PRINTER DEBUG: Calling platform channel listUsbDevices...');
      
      final result = await _channel.invokeMethod('listUsbDevices');
      
      if (result != null && result is Map) {
        _logger.i('🔍 USB device listing completed');
        print('🔍 PRINTER DEBUG: Found ${result['deviceCount']} USB devices');
        
        // Log device details for debugging
        if (result['devices'] != null && result['devices'] is List) {
          final devices = result['devices'] as List;
          for (int i = 0; i < devices.length; i++) {
            final device = devices[i] as Map;
            print('🔍 Device $i: VID:${device['vendorId']} PID:${device['productId']} - ${device['productName']}');
            if (device['isEpson'] == true) {
              print('  ⭐ EPSON DEVICE FOUND!');
            }
            if (device['isPrinter'] == true) {
              print('  🖨️ PRINTER CLASS DEVICE!');
            }
          }
        }
        
        return Map<String, dynamic>.from(result);
      } else {
        _logger.e('🔍 Invalid response from platform channel');
        return {'success': false, 'error': 'Invalid response from platform'};
      }
      
    } catch (e) {
      _logger.e('🔍 Failed to list USB devices: $e');
      print('🔍 PRINTER DEBUG: List devices exception: $e');
      return {'success': false, 'error': e.toString()};
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
