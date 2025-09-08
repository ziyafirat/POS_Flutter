import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../models/app_state.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.blueAccent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display text from API
            Obx(() => (controller.displayText.isNotEmpty || controller.posSubState.isNotEmpty)
                ? Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Row(
                      children: [
                        if (controller.posSubState.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              controller.posSubState,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        if (controller.posSubState.isNotEmpty && controller.displayText.isNotEmpty)
                          const SizedBox(width: 10),
                        if (controller.displayText.isNotEmpty)
                          Expanded(
                            child: Text(
                              controller.displayText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(width: 10),
                        // Small POS Cashier button
                        SizedBox(
                          height: 24,
                          child: ElevatedButton(
                            onPressed: () => controller.navigateToPosCashier(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'POS',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
            // Logo/Image placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            
            // App Title
            Obx(() => Text(
              langController.welcomeTitle,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
            const SizedBox(height: 10),
            
            Obx(() => Text(
              langController.welcomeSubtitle,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            )),
            const SizedBox(height: 60),
            
            // Start Button
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.clearScannedItems(); // Clear any previous items
                  controller.navigateToItemScan();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, size: 24),
                    const SizedBox(width: 12),
                    Obx(() => Text(
                      langController.startShopping,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Assistant Page Button
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.navigateToAssistant();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.settings, size: 24),
                    const SizedBox(width: 12),
                    Obx(() => Text(
                      langController.assistant,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Language Toggle Button
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  langController.toggleLanguage();
                },
                icon: const Icon(Icons.language, size: 24),
                label: Obx(() => Text(
                  langController.languageButtonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // gRPC Test Button
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.testGrpcConnection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.network_check, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Test gRPC Connection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // POS Cashier Button
            SizedBox(
              width: 280,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.navigateToPosCashier();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.point_of_sale, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'POS Cashier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Connection Status
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.appState.value.grpcStatus == ConnectionStatus.connected
                        ? Icons.wifi
                        : Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'gRPC: ${controller.appState.value.grpcStatus.name}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    controller.appState.value.mqttStatus == ConnectionStatus.connected
                        ? Icons.cloud_done
                        : Icons.cloud_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'MQTT: ${controller.appState.value.mqttStatus.name}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
