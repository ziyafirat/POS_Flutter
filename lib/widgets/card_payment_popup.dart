import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';

class CardPaymentPopup extends StatelessWidget {
  final double amount;
  final VoidCallback? onCancel;

  const CardPaymentPopup({
    super.key,
    required this.amount,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langController.cardPaymentProcessing,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          langController.formatCurrency(amount),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onCancel != null)
                    IconButton(
                      onPressed: onCancel,
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
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Credit Card Animation/Image
                    Container(
                      width: 280,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E3A8A), // Dark blue
                            Color(0xFF3B82F6), // Blue
                            Color(0xFF60A5FA), // Light blue
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Card chip
                          Positioned(
                            left: 24,
                            top: 32,
                            child: Container(
                              width: 40,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          
                          // Card number placeholder
                          const Positioned(
                            left: 24,
                            top: 80,
                            child: Text(
                              '**** **** **** ****',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          
                          // Card holder
                          Positioned(
                            left: 24,
                            bottom: 32,
                            child: Text(
                              langController.cardHolder,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          
                          // Contactless symbol
                          const Positioned(
                            right: 24,
                            top: 24,
                            child: Icon(
                              Icons.contactless,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Processing indicator
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E24)),
                      strokeWidth: 4,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Instruction text
                    Text(
                      langController.pleaseTapOrInsertCard,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      langController.processingYourPayment,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer with payment methods
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPaymentMethodIcon(Icons.contactless, 'Tap'),
                  const SizedBox(width: 40),
                  _buildPaymentMethodIcon(Icons.credit_card, 'Insert'),
                  const SizedBox(width: 40),
                  _buildPaymentMethodIcon(Icons.nfc, 'NFC'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6B7280),
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
