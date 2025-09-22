import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../services/web_api_service.dart';
import '../services/eft.dart';
import '../widgets/card_payment_popup.dart';
import '../widgets/processing_popup.dart';
import '../config/popup_config.dart';

class PaymentPopup extends StatelessWidget {
  const PaymentPopup({super.key});

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
      print('📱 Screen: Payment Popup');
      print('💰 Payment Method: Cash');
      print('💵 Total Amount: $totalAmount');
      print('🔢 Formatted Amount: $formattedAmount');
      print('🎯 Display Line: <91>');
      print('📤 Combined Command: "$cashCommand"');
      print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      _logger.i('ACTION BUTTON REQUEST');
      _logger.i('Screen: Payment Popup');
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

      // Close popup and show processing popup
      Get.back(); // Close payment popup

      // Show processing popup
      Get.dialog(const ProcessingPopup(), barrierDismissible: false);
    } catch (e) {
      // Log error
      _logger.e('❌ CASH PAYMENT ERROR: $e');

      // Close popup and show error
      Get.back(); // Close payment popup
      controller.navigateToError(
        errorMessage: 'Failed to process cash payment: $e',
      );
    } finally {
      // Reset processing state
      controller.setProcessingPayment(false);
    }
  }

  static Future<void> _handleCardPayment(AppController controller) async {
    // Get the total amount
    double totalAmount = controller.totalAmount;

    // Close payment popup first
    Get.back();

    // Show card payment popup with processing state
    Get.dialog(
      CardPaymentPopup(
        amount: totalAmount,
        onCancel: () {
          Get.back(); // Close card popup
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
      print('📱 Screen: Payment Popup');
      print('💳 Payment Method: Card (EFT)');
      print('💵 Total Amount: $totalAmount');
      print('📤 Calling eftService.startTransaction($totalAmount)');
      print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      _logger.i('ACTION BUTTON REQUEST');
      _logger.i('Screen: Payment Popup');
      _logger.i('Payment Method: Card (EFT)');
      _logger.i('Total Amount: $totalAmount');
      _logger.i('Calling eftService.startTransaction($totalAmount)');
      _logger.i('Timestamp: ${DateTime.now().toIso8601String()}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Call EFT service to start transaction
      final success = await eftService.startTransaction(totalAmount);

      // Close the card popup
      if (Get.isDialogOpen == true) {
        Get.back();
      }

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
          print('📱 Screen: Payment Popup');
          print('💳 Payment Method: Card (EFT Success)');
          print('💵 Total Amount: $totalAmount');
          print('🔢 Formatted Amount: $formattedAmount');
          print('🎯 Display Line: <94>');
          print('📤 Combined Command: "$cardCommand"');
          print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          _logger.i('EFT SUCCESS API REQUEST');
          _logger.i('Screen: Payment Popup');
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

        // Show processing popup
        _logger.i('🖨️ Showing processing popup after successful EFT');
        print('🖨️ Showing processing popup after successful EFT');

        Get.dialog(const ProcessingPopup(), barrierDismissible: false);
      } else {
        _logger.e('❌ EFT transaction failed to start');
        print('❌ EFT transaction failed to start');

        // Close all popups before navigating to error page
        controller.closeAllPopups();

        // Navigate to error page
        _logger.e('🚨 Navigating to error page due to EFT failure');
        print('🚨 Navigating to error page due to EFT failure');
        controller.navigateToError(
          errorMessage: 'EFT transaction failed to start',
        );
      }
    } catch (e) {
      // Close all popups before navigating to error page
      controller.closeAllPopups();

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

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * PopupConfig.standardWidth,
        height: MediaQuery.of(context).size.height * PopupConfig.standardHeight,
        constraints: const BoxConstraints(
          maxWidth: PopupConfig.maxWidth,
          maxHeight: PopupConfig.maxHeight,
        ),
        decoration: BoxDecoration(
          color: PopupConfig.popupBackgroundColor,
          borderRadius: BorderRadius.circular(PopupConfig.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(PopupConfig.shadowOpacity),
              blurRadius: PopupConfig.shadowBlurRadius,
              spreadRadius: PopupConfig.shadowSpreadRadius,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PopupConfig.headerPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(PopupConfig.borderRadius),
                  topRight: Radius.circular(PopupConfig.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: PopupConfig.headerIconSize,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langController.makeSelection,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: PopupConfig.headerFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          langController.isEnglish
                              ? 'Choose your payment method'
                              : 'اختر طريقة الدفع',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(PopupConfig.contentPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total Amount Display
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: PopupConfig.contentBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            langController.isEnglish
                                ? 'Total Amount:'
                                : 'المبلغ الإجمالي:',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Obx(
                            () => Text(
                              langController.formatCurrency(
                                controller.totalAmount,
                              ),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE31E24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Payment Buttons
                    Row(
                      children: [
                        // Cash Button
                        Expanded(
                          child: Obx(() {
                            final isProcessing =
                                controller.isProcessingPayment.value;

                            return SizedBox(
                              height: PopupConfig.buttonHeight,
                              child: ElevatedButton.icon(
                                onPressed: isProcessing
                                    ? null
                                    : () => _handleCashPayment(controller),
                                icon: isProcessing
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.money, size: 28),
                                label: Text(
                                  langController.cash,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isProcessing
                                      ? Colors.grey
                                      : const Color(
                                          0xFF059669,
                                        ), // Green for cash
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(width: 20),

                        // Card Button
                        Expanded(
                          child: SizedBox(
                            height: PopupConfig.buttonHeight,
                            child: ElevatedButton.icon(
                              onPressed: () => _handleCardPayment(controller),
                              icon: const Icon(Icons.credit_card, size: 28),
                              label: Text(
                                langController.credit,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFE31E24,
                                ), // Almaya red
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
