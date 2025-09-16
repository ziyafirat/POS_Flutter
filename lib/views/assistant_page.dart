import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../services/scanner_service.dart';
import '../models/app_state.dart';
import '../test/mqtt_test_widget.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final ScannerService scannerService = Get.find<ScannerService>();

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
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
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
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 8,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
