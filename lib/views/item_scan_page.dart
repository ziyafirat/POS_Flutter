import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../services/web_api_service.dart';

class ItemScanPage extends StatelessWidget {
  const ItemScanPage({super.key});

  static final Logger _logger = Logger();

  static Future<void> _handleFinishAndPay(AppController controller) async {
    try {
      // Set processing state
      controller.setProcessingPayment(true);
      
      // Get WebApiService instance
      final webApiService = Get.find<WebApiService>();
      
      // Log the action button request - using both print and logger for visibility
      print('🔘 ACTION BUTTON REQUEST');
      print('📱 Screen: Item Scan Page');
      print('🛒 Action: Finish and Pay');
      print('📦 Scanned Items Count: ${controller.scannedItems.length}');
      print('💵 Total Amount: ${controller.totalAmount}');
      print('🎯 Display Line: <81>');
      print('📤 Command: "<81>"');
      print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      _logger.i('ACTION BUTTON REQUEST');
      _logger.i('Screen: Item Scan Page');
      _logger.i('Action: Finish and Pay');
      _logger.i('Scanned Items Count: ${controller.scannedItems.length}');
      _logger.i('Total Amount: ${controller.totalAmount}');
      _logger.i('Display Line: <81>');
      _logger.i('Command: "<81>"');
      _logger.i('Timestamp: ${DateTime.now().toIso8601String()}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // Send API request with DisplayLine <81>
      await webApiService.sendOneTimeRequest('<81>');
      
      // Navigate to payment page
      controller.navigateToPayment();
      
    } catch (e) {
      // Log error
      _logger.e('❌ FINISH AND PAY ERROR: $e');
      
      // Handle error - show snackbar or navigate to error page
      Get.snackbar(
        'Error',
        'Failed to process payment request: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Reset processing state
      controller.setProcessingPayment(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header with Almaya logo and status (10% of screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
          // Main content area (80% of screen)
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Top gray area for product display
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  
                  // Product details section
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo area
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'ALMAYA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Scanned items list
                          Expanded(
                            child: Obx(() {
                              if (controller.scannedItems.isEmpty) {
                                return Center(
                                  child: Text(
                                    langController.noItemsScanned,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              
                              return ListView.builder(
                                itemCount: controller.scannedItems.length,
                                itemBuilder: (context, index) {
                                  final itemString = controller.scannedItems[index];
                                  // Parse item format: barcode:displayName:uom:price:qty:vr
                                  final parts = itemString.split(':');
                                  final displayName = parts.length > 1 ? parts[1] : 'Unknown Item';
                                  final price = parts.length > 3 ? parts[3] : '0.00';
                                  final qty = parts.length > 4 ? parts[4] : '1';
                                  final uom = parts.length > 2 ? parts[2] : '';
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue[200]!),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                displayName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (uom.isNotEmpty)
                                                Text(
                                                  'Qty: $qty $uom',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          langController.formatCurrency(double.tryParse(price) ?? 0.0),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle, size: 20),
                                          onPressed: () => controller.removeScannedItem(index),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                          
                          // Shopping total
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(
                                  langController.shoppingTotal,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                Obx(() => Text(
                                  langController.formatCurrency(controller.totalAmount),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          
                          // Disclaimer
                          Obx(() => Text(
                            langController.discountDisclaimer,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom buttons section (10% of screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Left side buttons
                Expanded(
                  child: Row(
                    children: [
                      // Language Button
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              langController.toggleLanguage();
                            },
                            icon: const Icon(Icons.language, size: 20),
                            label: Obx(() => Text(
                              langController.languageButtonText,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE31E24), // Almaya red
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right side buttons
                Row(
                  children: [
                    // Help Button
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Help functionality
                        },
                        icon: const Icon(Icons.help, size: 20),
                        label: Obx(() => Text(
                          langController.callHelp,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Finish and Pay Button
                    SizedBox(
                      width: 180,
                      height: 60,
                      child: Obx(() {
                        final isEmpty = controller.scannedItems.isEmpty;
                        final totalAmount = controller.totalAmount;
                        final isButtonEnabled = !isEmpty && totalAmount > 0;
                        final isProcessing = controller.isProcessingPayment.value;
                        
                        return ElevatedButton(
                          onPressed: (isButtonEnabled && !isProcessing)
                              ? () => _handleFinishAndPay(controller)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isProcessing ? Colors.grey : Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                          ),
                          child: isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Obx(() => Text(
                                  langController.finishAndPay,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
