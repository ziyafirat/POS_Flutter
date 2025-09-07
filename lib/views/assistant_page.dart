import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../models/app_state.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

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
                        controller.appState.value.grpcStatus == ConnectionStatus.connected
                            ? Icons.wifi
                            : Icons.wifi_off,
                        color: controller.appState.value.grpcStatus == ConnectionStatus.connected
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text('gRPC: ${controller.appState.value.grpcStatus.name}'),
                      const SizedBox(width: 20),
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
                    'Test gRPC Connection',
                    Icons.wifi,
                    Colors.blue,
                    () => controller.testGrpcConnection(),
                  ),
                  _buildTestButton(
                    'Test MQTT Connection',
                    Icons.cloud,
                    Colors.green,
                    () => controller.testMqttConnection(),
                  ),
                  _buildTestButton(
                    'gRPC Happy Test',
                    Icons.rocket_launch,
                    Colors.purple,
                    () => controller.runGrpcHappyTestScenario(),
                  ),
                  _buildTestButton(
                    'gRPC Health Check',
                    Icons.health_and_safety,
                    Colors.teal,
                    () => controller.runGrpcQuickHealthCheck(),
                  ),
                  _buildTestButton(
                    'Check Server',
                    Icons.dns,
                    Colors.cyan,
                    () => controller.testServerRunning(),
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
                      controller.clearScannedItems();
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
                      controller.clearScannedItems();
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
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6,
        shadowColor: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
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
}
