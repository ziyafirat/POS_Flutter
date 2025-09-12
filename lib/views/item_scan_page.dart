import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../widgets/bag_popup.dart';
import 'barcode_entry_popup.dart';
import 'product_search_popup.dart';
import 'help_page.dart';
import 'card_entry_popup.dart';

class ItemScanPage extends StatelessWidget {
  const ItemScanPage({super.key});

  void _showBagPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const BagPopup();
      },
    );
  }

  void _showBarcodeEntryPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BarcodeEntryPopup(
          onBarcodeEntered: (barcode) {
            final controller = Get.find<AppController>();
            controller.addScannedItem(barcode);
          },
          onCancel: () {
            // Handle cancel if needed
          },
        );
      },
    );
  }

  void _showProductSearchPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ProductSearchPopup(
          onProductSelected: (productName) {
            final controller = Get.find<AppController>();
            controller.addScannedItem(productName);
          },
        );
      },
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HelpPage(),
      ),
    );
  }

  void _showCardEntryPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CardEntryPopup(
          onCardEntered: (cardNumber) {
            final controller = Get.find<AppController>();
            controller.setCardInfo(cardNumber);
          },
          onCancel: () {
            // Handle cancel if needed
          },
        );
      },
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
                  // Top gray area for product display
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                          Colors.grey[400]!,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _BackgroundPatternPainter(),
                          ),
                        ),
                        // Main content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Shopping cart icon with animation effect
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
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
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Scan instruction text
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Obx(() => Text(
                                  langController.scanInstruction,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  // Product details section
          Expanded(
            child: Container(
                      padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                          // Logo area
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
                                  '${controller.totalAmount.toStringAsFixed(2)} TL',
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
                // Instructions
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        size: 30,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(() => Text(
                          langController.scanInstruction,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                
                // Action buttons grid
                Row(
                  children: [
                    // Product Search
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () => _showProductSearchPopup(context),
                          icon: const Icon(Icons.search, size: 24),
                          label: Obx(() => Text(
                            langController.productSearch,
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
                    
                    // Carrefour Card
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () => _showCardEntryPopup(context),
                          icon: const Icon(Icons.card_membership, size: 24),
                          label: Obx(() => Text(
                            langController.carrefourCard,
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
                    
                    // Language
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            langController.toggleLanguage();
                          },
                          icon: const Icon(Icons.language, size: 24),
                          label: Obx(() => Text(
                            langController.languageButtonText,
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
                    
                    // Enter Barcode
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () => _showBarcodeEntryPopup(context),
                          icon: const Icon(Icons.grid_on, size: 24),
                          label: Obx(() => Text(
                            langController.enterBarcode,
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
                    
                    // Help
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateToHelp(context),
                          icon: const Icon(Icons.help, size: 24),
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
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // Main action buttons
                Row(
                  children: [
                    // Add test item button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final itemId = 'ITEM_${DateTime.now().millisecondsSinceEpoch}';
                            controller.addScannedItem(itemId);
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Obx(() => Text(langController.addTestItem)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Finish and Pay button
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                  height: 60,
                  child: Obx(() {
                    final isEmpty = controller.scannedItems.isEmpty;
                    final totalAmount = controller.totalAmount;
                    final isButtonEnabled = !isEmpty && totalAmount > 0;
                    
                    return ElevatedButton(
                      onPressed: isButtonEnabled
                                ? () => _showBagPopup(context)
                          : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black26,
                            ),
                            child: Obx(() => Text(
                              langController.finishAndPay,
                              style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                            )),
                          );
                        }),
                      ),
                    ),
                  ],
                        ),
                      ],
                    ),
          ),
          
          // Scale section - Now at the very bottom below buttons
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
                          const Text('Maks = 15 kg', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text('Min = 0,1 kg', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('Nmax = 3000d', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 10),
                          const Text('Sınıf III', style: TextStyle(fontSize: 10)),
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
                  child: Obx(() => Text(
                    langController.version,
                    style: const TextStyle(fontSize: 10),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw subtle grid pattern
    const gridSize = 30.0;
    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        if ((x / gridSize + y / gridSize).toInt() % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, gridSize, gridSize),
            paint,
          );
        }
      }
    }

    // Draw subtle circles
    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.1,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      size.width * 0.08,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
