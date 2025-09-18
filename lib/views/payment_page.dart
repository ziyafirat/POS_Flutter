import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../services/web_api_service.dart';
import '../services/eft.dart';
import '../widgets/card_payment_popup.dart';
import '../widgets/almaya_header.dart';

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

  static Future<void> _handleCardPayment(AppController controller) async {
    // Get the total amount
    double totalAmount = controller.totalAmount;

    // Show card payment popup
    Get.dialog(
      CardPaymentPopup(
        amount: totalAmount,
        onCancel: () {
          Get.back(); // Close popup
          controller.setProcessingPayment(false);
        },
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );

    try {
      // Set processing state
      controller.setProcessingPayment(true);

      // Get EFT service instance (initialize if not registered)
      final eftService = Get.isRegistered<NiVm>()
          ? Get.find<NiVm>()
          : Get.put(NiVm(), permanent: true);

      // Log the action button request
      print('🔘 ACTION BUTTON REQUEST');
      print('📱 Screen: Payment Page');
      print('💳 Payment Method: Card (EFT)');
      print('💵 Total Amount: $totalAmount');
      print('📤 Calling eftService.startTransaction($totalAmount)');
      print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      _logger.i('ACTION BUTTON REQUEST');
      _logger.i('Screen: Payment Page');
      _logger.i('Payment Method: Card (EFT)');
      _logger.i('Total Amount: $totalAmount');
      _logger.i('Calling eftService.startTransaction($totalAmount)');
      _logger.i('Timestamp: ${DateTime.now().toIso8601String()}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Call EFT service to start transaction
      final success = await eftService.startTransaction(totalAmount);

      // Close the popup
      Get.back();

      if (success) {
        _logger.i('✅ EFT transaction started successfully');
        print('✅ EFT transaction started successfully');

        // Send API request with amount + <94> for card payment
        try {
          final webApiService = Get.find<WebApiService>();
          String formattedAmount = _formatAmountForApi(totalAmount);
          String cardCommand = '$formattedAmount<94>';

          // Log the API request
          print('🔘 EFT SUCCESS API REQUEST');
          print('📱 Screen: Payment Page');
          print('💳 Payment Method: Card (EFT Success)');
          print('💵 Total Amount: $totalAmount');
          print('🔢 Formatted Amount: $formattedAmount');
          print('🎯 Display Line: <94>');
          print('📤 Combined Command: "$cardCommand"');
          print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          _logger.i('EFT SUCCESS API REQUEST');
          _logger.i('Screen: Payment Page');
          _logger.i('Payment Method: Card (EFT Success)');
          _logger.i('Total Amount: $totalAmount');
          _logger.i('Formatted Amount: $formattedAmount');
          _logger.i('Display Line: <94>');
          _logger.i('Combined Command: "$cardCommand"');
          _logger.i('Timestamp: ${DateTime.now().toIso8601String()}');
          _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          await webApiService.sendOneTimeRequest(cardCommand);

          _logger.i('✅ EFT success API request sent successfully');
          print('✅ EFT success API request sent successfully');
        } catch (apiError) {
          _logger.e('❌ Failed to send EFT success API request: $apiError');
          print('❌ Failed to send EFT success API request: $apiError');
          // Continue with the flow even if API request fails
        }

        // Process payment after successful EFT start
        controller.processPayment('card');

        // Navigate to printing page
        _logger.i('🖨️ Navigating to printing page after successful EFT');
        print('🖨️ Navigating to printing page after successful EFT');
        controller.navigateToPrinting();
      } else {
        _logger.e('❌ EFT transaction failed to start');
        print('❌ EFT transaction failed to start');

        // Navigate to error page
        _logger.e('🚨 Navigating to error page due to EFT failure');
        print('🚨 Navigating to error page due to EFT failure');
        controller.navigateToError(
          errorMessage: 'EFT transaction failed to start',
        );
      }
    } catch (e) {
      // Close the popup if it's still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Log error
      _logger.e('❌ CARD PAYMENT ERROR: $e');
      print('❌ CARD PAYMENT ERROR: $e');

      // Navigate to error page
      _logger.e('🚨 Navigating to error page due to exception: $e');
      print('🚨 Navigating to error page due to exception: $e');
      controller.navigateToError(errorMessage: 'Card payment failed: $e');
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
          // Header with Almaya logo
          AlmayaHeader(
            pageTitle: 'PAYMENT',
            height: MediaQuery.of(context).size.height * 0.1,
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
                                  final itemString =
                                      controller.scannedItems[index];
                                  // Parse item format: barcode:displayName:uom:price:qty:vr
                                  final parts = itemString.split(':');
                                  final displayName = parts.length > 1
                                      ? parts[1]
                                      : 'Unknown Item';
                                  final price = parts.length > 3
                                      ? parts[3]
                                      : '0.00';
                                  final qty = parts.length > 4 ? parts[4] : '1';
                                  final uom = parts.length > 2 ? parts[2] : '';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                          langController.formatCurrency(
                                            double.tryParse(price) ?? 0.0,
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                          ),
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
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        langController.total,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          langController.formatCurrency(
                                            controller.totalAmount,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                            final isProcessing =
                                controller.isProcessingPayment.value;

                            return ElevatedButton.icon(
                              onPressed: isProcessing
                                  ? null
                                  : () => _handleCashPayment(controller),
                              icon: isProcessing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Icon(Icons.money, size: 20),
                              label: Text(
                                langController.cash,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            onPressed: () => _handleCardPayment(controller),
                            icon: const Icon(Icons.credit_card, size: 20),
                            label: Obx(
                              () => Text(
                                langController.credit,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFE31E24,
                              ), // Almaya red
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
                        label: Obx(
                          () => Text(
                            langController.returnScanMore,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                        label: Obx(
                          () => Text(
                            langController.requestHelp,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
