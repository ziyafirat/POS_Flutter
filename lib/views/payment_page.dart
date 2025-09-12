import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import 'help_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  void _navigateToHelp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HelpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Top gray area for payment display
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green[200]!,
                            Colors.green[300]!,
                            Colors.green[400]!,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _PaymentBackgroundPainter(),
                            ),
                          ),
                          // Main content
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Payment icon with animation effect
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.payment,
                                    size: 60,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Payment instruction text
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Obx(() => Text(
                                    langController.isEnglish ? 'Complete Your Payment' : 'Ödemenizi Tamamlayın',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  )),
                                ),
                                const SizedBox(height: 8),
                                // Payment methods icons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildPaymentMethodIcon(Icons.credit_card, 'Card'),
                                    const SizedBox(width: 12),
                                    _buildPaymentMethodIcon(Icons.account_balance_wallet, 'Wallet'),
                                    const SizedBox(width: 12),
                                    _buildPaymentMethodIcon(Icons.qr_code, 'QR'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                  'DOĞRUSU CarrefourSA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Card information display
                          Obx(() {
                            if (controller.cardNumber.isNotEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.card_membership,
                                      color: Colors.blue[700],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.customerName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                          Text(
                                            'Card: ${controller.cardNumber}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[600],
                                            ),
                                          ),
                                          Text(
                                            'Points: ${controller.loyaltyPoints}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.clearCardInfo();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.blue[700],
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
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
                                  final itemId = controller.scannedItems[index];
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
                                          child: Text(
                                            '$itemId - Item Name',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '4,45 TL',
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
                                      '${controller.totalAmount.toStringAsFixed(2)} TL',
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
                                    const Text(
                                      '0,00 TL',
                                      style: TextStyle(
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
                                      '${controller.totalAmount.toStringAsFixed(2)} TL',
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
          
          // Bottom Button Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Selection prompt
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(() => Text(
                          langController.makeSelection,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                
                // Payment method buttons
                Row(
                  children: [
                    // Cash Payment
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.processPayment('cash');
                          },
                          icon: const Icon(Icons.money, size: 24),
                          label: Obx(() => Text(
                            langController.cash,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Credit Card Payment
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.processPayment('card');
                          },
                          icon: const Icon(Icons.credit_card, size: 24),
                          label: Obx(() => Text(
                            langController.credit,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Payment with Change
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.processPayment('change');
                          },
                          icon: const Icon(Icons.monetization_on, size: 24),
                          label: Obx(() => Text(
                            langController.paymentWithChange,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Staff Card Payment
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.processPayment('staff_card');
                          },
                          icon: const Icon(Icons.badge, size: 24),
                          label: Obx(() => Text(
                            langController.paymentWithStaffCard,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
                
                const SizedBox(height: 15),
                
                // Bottom action buttons
                Row(
                  children: [
                    // Back to scan button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.navigateToItemScan(),
                          icon: const Icon(Icons.arrow_back),
                          label: Obx(() => Text(langController.returnScanMore)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Help button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateToHelp(context),
                          icon: const Icon(Icons.help),
                          label: Obx(() => Text(langController.requestHelp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
              ],
            ),
          ),
          
          // Scale section - At the very bottom below buttons
          Container(
            height: 80,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Weight display
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '0,000 kg',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Scale specifications
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text('d = 0,005 kg', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('e = 0,005 kg', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('Max = 15 kg', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text('Min = 0,1 kg', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('Nmax = 3000d', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('Class III', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text('+10°C to +40°C', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('CC: 03-104', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Version button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.black,
                    minimumSize: const Size(60, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text(
                    langController.version,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.green[600],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw subtle diamond pattern
    const diamondSize = 40.0;
    for (double x = 0; x < size.width; x += diamondSize) {
      for (double y = 0; y < size.height; y += diamondSize) {
        if ((x / diamondSize + y / diamondSize).toInt() % 2 == 0) {
          final path = Path();
          path.moveTo(x + diamondSize / 2, y);
          path.lineTo(x + diamondSize, y + diamondSize / 2);
          path.lineTo(x + diamondSize / 2, y + diamondSize);
          path.lineTo(x, y + diamondSize / 2);
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }

    // Draw subtle payment symbols
    final symbolPaint = Paint()
      ..color = Colors.green.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // Draw dollar signs
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25),
      size.width * 0.06,
      symbolPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.75),
      size.width * 0.05,
      symbolPaint,
    );

    // Draw check marks
    final checkPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.9),
      checkPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.9),
      Offset(size.width * 0.3, size.height * 0.7),
      checkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
