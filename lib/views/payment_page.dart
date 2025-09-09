import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../services/web_api_service.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  static final Logger _logger = Logger();

  static String _formatAmountForApi(double amount) {
    // Convert to cents (remove decimal point)
    // Example: 12.50 -> 1250
    int amountInCents = (amount * 100).round();
    return amountInCents.toString();
  }

  static Future<void> _handleCashPayment(AppController controller) async {
    try {
      // Set processing state
      controller.setProcessingPayment(true);
      
      // Get WebApiService instance
      final webApiService = Get.find<WebApiService>();
      
      // Get the total amount and format it without decimal point
      double totalAmount = controller.totalAmount;
      String formattedAmount = _formatAmountForApi(totalAmount);
      
      // Send API request with amount + <91>
      String cashCommand = '$formattedAmount<91>';
      
      // Log the action button request - using both print and logger for visibility
      print('🔘 ACTION BUTTON REQUEST');
      print('📱 Screen: Payment Page');
      print('💰 Payment Method: Cash');
      print('💵 Total Amount: $totalAmount');
      print('🔢 Formatted Amount: $formattedAmount');
      print('🎯 Display Line: <91>');
      print('📤 Combined Command: "$cashCommand"');
      print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      _logger.i('ACTION BUTTON REQUEST');
      _logger.i('Screen: Payment Page');
      _logger.i('Payment Method: Cash');
      _logger.i('Total Amount: $totalAmount');
      _logger.i('Formatted Amount: $formattedAmount');
      _logger.i('Display Line: <91>');
      _logger.i('Combined Command: "$cashCommand"');
      _logger.i('Timestamp: ${DateTime.now().toIso8601String()}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      await webApiService.sendOneTimeRequest(cashCommand);
      
      // Process payment after API request
      controller.processPayment('cash');
      
    } catch (e) {
      // Log error
      _logger.e('❌ CASH PAYMENT ERROR: $e');
      
      // Handle error - show snackbar
      Get.snackbar(
        'Error',
        'Failed to process cash payment: $e',
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
                          
                          // Transaction summary
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              children: [
                                Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      langController.subtotal,
                  style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      langController.formatCurrency(controller.totalAmount),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      langController.campaignDiscount,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      langController.formatCurrency(0.0),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                                    Text(
                                      langController.total,
                                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                                      langController.formatCurrency(controller.totalAmount),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )),
              ],
                            ),
                          ),
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
                // Left side payment buttons
                Expanded(
                  child: Row(
                    children: [
                      // Cash Button
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Obx(() {
                            final isProcessing = controller.isProcessingPayment.value;
                            
                            return ElevatedButton.icon(
                              onPressed: isProcessing ? null : () => _handleCashPayment(controller),
                              icon: isProcessing 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.money, size: 20),
                              label: Text(
                                langController.cash,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isProcessing 
                                    ? Colors.grey 
                                    : const Color(0xFFE31E24), // Almaya red
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Credit Card Button
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.processPayment('card');
                            },
                            icon: const Icon(Icons.credit_card, size: 20),
                            label: Obx(() => Text(
                              langController.credit,
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
                    // Return Button
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => controller.navigateToItemScan(),
                        icon: const Icon(Icons.arrow_back, size: 20),
                        label: Obx(() => Text(
                          langController.returnScanMore,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          langController.requestHelp,
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
