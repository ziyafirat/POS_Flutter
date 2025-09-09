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
      body: Column(
        children: [
          // Status Bar (5% of screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red colors
              ),
            ),
            child: Row(
              children: [
                // Almaya Logo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Color(0xFFE31E24),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'almaya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'supermarket',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Display text and POS button - Always visible
                Flexible(
                  child: Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // PosSubState display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              controller.posSubState.isNotEmpty ? controller.posSubState : 'N/A',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Display text
                          Flexible(
                            child: Text(
                              controller.displayText.isNotEmpty ? controller.displayText : 'System Ready',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Small POS Cashier button
                          SizedBox(
                            height: 24,
                            child: ElevatedButton(
                              onPressed: () => controller.navigateToPosCashier(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFE31E24),
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
                      )),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // Main Content Area (60% of screen)
          Expanded(
            flex: 6,
            child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                  // Main promotional image area
            Container(
                    margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE31E24), Color(0xFFC41E3A)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background pattern
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Shopping cart icon
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.shopping_cart,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Welcome text
                                  Obx(() => Text(
                                    langController.welcomeTitle,
                                    style: const TextStyle(
                                      fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
                                    textAlign: TextAlign.center,
                                  )),
            const SizedBox(height: 10),
                                  Obx(() => Text(
                                    langController.welcomeSubtitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom section with buttons (35% of screen)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start Shopping Button (Primary Action)
            SizedBox(
                    width: double.infinity,
                    height: 60,
              child: ElevatedButton(
                onPressed: () {
                  controller.clearScannedItems(); // Clear any previous items
                  controller.navigateToItemScan();
                },
                style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31E24), // Almaya red
                        foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                ),
                      child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          const Icon(Icons.shopping_cart, size: 28),
                          const SizedBox(width: 12),
                          Obx(() => Text(
                            langController.startShopping,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Secondary buttons row
                  Row(
                    children: [
                      // Language Toggle Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              langController.toggleLanguage();
                            },
                            icon: const Icon(Icons.language, size: 20),
                            label: Obx(() => Text(
                              langController.languageButtonText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                ),
              ),
            ),
                      const SizedBox(width: 12),
                      // Assistant Button
                      Expanded(
                        child: SizedBox(
              height: 50,
                          child: ElevatedButton.icon(
                onPressed: () {
                  controller.navigateToAssistant();
                },
                            icon: const Icon(Icons.settings, size: 20),
                            label: Obx(() => Text(
                              langController.assistant,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // POS Cashier Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.navigateToPosCashier();
                      },
                      icon: const Icon(Icons.point_of_sale, size: 20),
                      label: const Text(
                        'POS Cashier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
      ),
    );
  }
}
