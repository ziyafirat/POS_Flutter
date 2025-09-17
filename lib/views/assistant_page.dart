import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../services/scanner_service.dart';
import '../services/usb_printer_service.dart';
import '../services/lamp.dart';
import '../services/eft.dart';
import '../models/app_state.dart';
import '../test/mqtt_test_widget.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  LampController? lampController;
  NiVm? eftService;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  void _initializeControllers() {
    try {
      if (!_controllersInitialized) {
        lampController = Get.isRegistered<LampController>() 
            ? Get.find<LampController>() 
            : Get.put(LampController(), permanent: true);
        eftService = Get.isRegistered<NiVm>() 
            ? Get.find<NiVm>() 
            : Get.put(NiVm(), permanent: true);
        _controllersInitialized = true;
        setState(() {});
      }
    } catch (e) {
      print('Controller initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final ScannerService scannerService = Get.find<ScannerService>();
    final UsbPrinterService printerService = Get.find<UsbPrinterService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Mode'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStart(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Obx(() => Row(
                    children: [
                      Icon(
                        controller.appState.value.mqttStatus == ConnectionStatus.connected
                            ? Icons.cloud_done
                            : Icons.cloud_off,
                        color: controller.appState.value.mqttStatus == ConnectionStatus.connected
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text('MQTT: ${controller.appState.value.mqttStatus.name}'),
                    ],
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                    children: [
                      Icon(
                        scannerService.isListening
                            ? Icons.qr_code_scanner
                            : Icons.qr_code_scanner_outlined,
                        color: scannerService.isListening
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text('Scanner: ${scannerService.isListening ? "Listening" : "Stopped"}'),
                    ],
                  )),
                  const SizedBox(height: 5),
                  Obx(() => Text(
                    'Scans: ${scannerService.scanCount} | Last: ${scannerService.lastScannedCode.isEmpty ? "None" : scannerService.lastScannedCode}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                    children: [
                      Icon(
                        printerService.isConnected
                            ? Icons.print
                            : Icons.print_disabled,
                        color: printerService.isConnected
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text('Printer: ${printerService.printerStatus}'),
                    ],
                  )),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        eftService?.channelOpen == true
                            ? Icons.credit_card
                            : Icons.credit_card_off,
                        color: eftService?.channelOpen == true
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text('EFT: ${eftService?.channelOpen == true ? "Connected" : "Disconnected"}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Test Buttons Section
            const Text(
              'Test Functions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 10,
                crossAxisSpacing: 4,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
                children: [
                  _buildTestButton(
                    'Test MQTT Connection',
                    Icons.cloud,
                    Colors.green,
                    () => controller.testMqttConnection(),
                  ),
                  _buildTestButton(
                    'MQTT Test Screen',
                    Icons.science,
                    Colors.deepOrange,
                    () => _openMqttTestScreen(context),
                  ),
                  _buildTestButton(
                    'Test Payment',
                    Icons.payment,
                    Colors.orange,
                    () async {
                      // Simulate payment test
                      controller.navigateToProcessing();
                      await Future.delayed(const Duration(seconds: 2));
                      controller.navigateToPrinting();
                      await Future.delayed(const Duration(seconds: 2));
                      controller.navigateToStart();
                    },
                  ),
                  _buildTestButton(
                    'Simulate Alert',
                    Icons.warning,
                    Colors.red,
                    () => controller.simulateAlert(),
                  ),
                  _buildTestButton(
                    'Simulate Fraud Alert',
                    Icons.security,
                    Colors.red[800]!,
                    () => controller.simulateFraudAlert(),
                  ),
                  _buildTestButton(
                    'Add Test Item',
                    Icons.add_shopping_cart,
                    Colors.purple,
                    () {
                      final itemId = 'TEST_${DateTime.now().millisecondsSinceEpoch}';
                      controller.addScannedItem(itemId);
                      Get.snackbar(
                        'Success',
                        'Test item added: $itemId',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildTestButton(
                    'Clear Items',
                    Icons.clear_all,
                    Colors.grey,
                    () {
                      Get.snackbar(
                        'Success',
                        'All items cleared',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildTestButton(
                    'Go to Item Scan',
                    Icons.qr_code_scanner,
                    Colors.teal,
                    () => controller.navigateToItemScan(),
                  ),
                  _buildTestButton(
                    'Go to Payment',
                    Icons.credit_card,
                    Colors.indigo,
                    () => controller.navigateToPayment(),
                  ),
                  _buildTestButton(
                    'Force Error',
                    Icons.error,
                    Colors.red[700]!,
                    () => controller.navigateToError(
                      errorMessage: 'Test error from assistant mode',
                    ),
                  ),
                  _buildTestButton(
                    'Reset App',
                    Icons.refresh,
                    Colors.amber,
                    () {
                      controller.dismissAlert();
                      controller.navigateToStart();
                      Get.snackbar(
                        'Success',
                        'App reset to start screen',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildTestButton(
                    'Test Scanner (13 digits)',
                    Icons.qr_code,
                    Colors.purple,
                    () {
                      scannerService.testScanner();
                      Get.snackbar(
                        'Scanner Test',
                        'Test 13-digit barcode with <80> suffix',
                        backgroundColor: Colors.purple,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildTestButton(
                    'Test Scanner (Long)',
                    Icons.qr_code_2,
                    Colors.deepPurple,
                    () {
                      scannerService.testScannerLong();
                      Get.snackbar(
                        'Scanner Test',
                        'Test long barcode (>13 digits)',
                        backgroundColor: Colors.deepPurple,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  Obx(() => _buildTestButton(
                    scannerService.isListening ? 'Stop Scanner' : 'Start Scanner',
                    scannerService.isListening ? Icons.stop : Icons.play_arrow,
                    scannerService.isListening ? Colors.red : Colors.green,
                    () {
                      if (scannerService.isListening) {
                        scannerService.stopListening();
                        Get.snackbar(
                          'Scanner',
                          'Scanner listening stopped',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        scannerService.startListening();
                        Get.snackbar(
                          'Scanner',
                          'Scanner listening started',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                  )),
                  _buildTestButton(
                    'Test Printer',
                    Icons.print,
                    Colors.orange,
                    () async {
                      try {
                        print('🖨️ PRINTER DEBUG: Calling testPrint()...');
                        final success = await printerService.testPrint();
                        // Use a safer snackbar approach
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text(success 
                                ? 'Test print sent successfully!' 
                                : 'Test print failed - check printer connection'),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text('Test print failed: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _buildTestButton(
                    'Test Print V2',
                    Icons.print_outlined,
                    Colors.deepOrange,
                    () async {
                      try {
                        print('🖨️ PRINTER DEBUG: Calling testPrintV2()...');
                        await printerService.testPrintV2();
                        
                        print('🖨️ PRINTER DEBUG: testPrintV2() completed without exception');
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            const SnackBar(
                              content: Text('Test Print V2 completed successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        print('🖨️ PRINTER DEBUG: testPrintV2 failed: $e');
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text('Test Print V2 failed: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _buildTestButton(
                    'List USB Devices',
                    Icons.usb,
                    Colors.deepPurple,
                    () async {
                      try {
                        final result = await printerService.listUsbDevices();
                        
                        if (result['success'] == true) {
                          final deviceCount = result['deviceCount'] ?? 0;
                          final devices = result['devices'] as List? ?? [];
                          
                          String message = 'Found $deviceCount USB devices:\n';
                          
                          for (int i = 0; i < devices.length && i < 5; i++) {
                            final device = devices[i] as Map;
                            final vendorId = device['vendorId'];
                            final productId = device['productId'];
                            final productName = device['productName'] ?? 'Unknown';
                            final isEpson = device['isEpson'] == true;
                            final isPrinter = device['isPrinter'] == true;
                            
                            message += '\n${i + 1}. $productName';
                            message += '\n   VID: $vendorId (${device['vendorIdHex']})';
                            message += '\n   PID: $productId (${device['productIdHex']})';
                            if (isEpson) message += '\n   ⭐ EPSON DEVICE';
                            if (isPrinter) message += '\n   🖨️ PRINTER CLASS';
                            message += '\n';
                          }
                          
                          if (devices.length > 5) {
                            message += '\n... and ${devices.length - 5} more devices';
                          }
                          
                          // Show in a dialog for better visibility
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('USB Devices'),
                              content: SingleChildScrollView(
                                child: Text(message),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          
                        } else {
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(
                                content: Text('Failed to list devices: ${result['error']}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text('Error listing USB devices: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _buildTestButton(
                    'Lamp Red',
                    Icons.lightbulb,
                    Colors.red,
                    () async {
                      try {
                        if (lampController != null) {
                          await lampController!.activateColor(LampColor.red);
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('Red lamp activated'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('Lamp controller not available'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text('Failed to activate red lamp: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _buildTestButton(
                    'Lamp Green',
                    Icons.lightbulb,
                    Colors.green,
                    () async {
                      try {
                        if (lampController != null) {
                          await lampController!.activateColor(LampColor.green);
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('Green lamp activated'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Lamp Error',
                            'Lamp controller not available',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Lamp Error',
                          'Failed to activate green lamp: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                  _buildTestButton(
                    'Lamp Blue',
                    Icons.lightbulb,
                    Colors.blue,
                    () async {
                      try {
                        if (lampController != null) {
                          await lampController!.activateColor(LampColor.blue);
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('Blue lamp activated'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Lamp Error',
                            'Lamp controller not available',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Lamp Error',
                          'Failed to activate blue lamp: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                  _buildTestButton(
                    'Lamp Off',
                    Icons.lightbulb_outline,
                    Colors.grey,
                    () async {
                      try {
                        if (lampController != null) {
                          await lampController!.activateColor(LampColor.off);
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('Lamp turned off'),
                                backgroundColor: Colors.grey,
                              ),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Lamp Error',
                            'Lamp controller not available',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Lamp Error',
                          'Failed to turn off lamp: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                  _buildTestButton(
                    'EFT Test',
                    Icons.credit_card,
                    Colors.teal,
                    () async {
                      try {
                        print('🏦 EFT DEBUG: Starting EFT transaction test...');
                        
                        if (eftService != null) {
                          // Call the startTransaction method with test amount
                          const testAmount = 100.00; // Test with 10.00 currency units
                          print('🏦 EFT DEBUG: Calling eftService.startTransaction($testAmount)...');
                          
                          final success = await eftService!.startTransaction(testAmount);
                          
                          print('🏦 EFT DEBUG: startTransaction result: $success');
                          
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(
                                content: Text(success 
                                  ? 'EFT Transaction started successfully! Amount: \$${testAmount.toStringAsFixed(2)}'
                                  : 'EFT Transaction failed to start'),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        } else {
                          print('🏦 EFT DEBUG: EFT service is null');
                          if (Get.context != null) {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              const SnackBar(
                                content: Text('EFT service not available'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('🏦 EFT DEBUG: Exception in EFT test: $e');
                        if (Get.context != null) {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content: Text('EFT test failed: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            
            // Current State Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current State',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Text('Screen: ${controller.appState.value.currentScreen.name}')),
                  Obx(() => Text('Items: ${controller.scannedItems.length}')),
                  Obx(() => Text('Total: \$${controller.totalAmount.toStringAsFixed(2)}')),
                  Obx(() => Text('Alert Active: ${controller.isAlertActive}')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 2,
        shadowColor: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        minimumSize: const Size(0, 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
          children: [
          Icon(icon, size: 14),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
    );
  }

  void _openMqttTestScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MqttTestWidget(),
      ),
    );
  }
}
