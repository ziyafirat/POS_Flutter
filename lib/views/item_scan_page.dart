import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';

class ItemScanPage extends StatelessWidget {
  const ItemScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // Left Side - Item List and Details
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Display text from API
                  Obx(() => (controller.displayText.isNotEmpty || controller.posSubState.isNotEmpty)
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          color: Colors.blue[100],
                          child: Row(
                            children: [
                              if (controller.posSubState.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    controller.posSubState,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              if (controller.posSubState.isNotEmpty && controller.displayText.isNotEmpty)
                                const SizedBox(width: 8),
                              if (controller.displayText.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    controller.displayText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              const SizedBox(width: 8),
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
                                  'DOĞRUSU CarrefourSA',
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
                                          '$price TL',
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
                  
                  // Scale section
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
            ),
          ),
          
          // Right Side - Instructions and Buttons
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Scan instruction graphic
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 10),
                                Icon(
                                  Icons.arrow_downward,
                                  size: 30,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                Icon(
                                  Icons.shopping_bag,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(() => Text(
                          langController.scanInstruction,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons grid
                  Expanded(
                    child: Column(
                      children: [
                        // Top row buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Product search functionality
                                  },
                                  icon: const Icon(Icons.search, size: 28),
                                  label: Obx(() => Text(
                                    langController.productSearch,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Card functionality
                                  },
                                  icon: const Icon(Icons.card_membership, size: 28),
                                  label: Obx(() => Text(
                                    langController.carrefourCard,
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
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Second row buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    langController.toggleLanguage();
                                  },
                                  icon: const Icon(Icons.language, size: 28),
                                  label: Obx(() => Text(
                                    langController.languageButtonText,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Manual barcode entry
                                  },
                                  icon: const Icon(Icons.grid_on, size: 28),
                                  label: Obx(() => Text(
                                    langController.enterBarcode,
                                    textAlign: TextAlign.center,
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
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Help button
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Help functionality
                            },
                            icon: const Icon(Icons.help, size: 28),
                            label: Obx(() => Text(
                              langController.callHelp,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Finish and Pay button
                  SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: Obx(() {
                      final isEmpty = controller.scannedItems.isEmpty;
                      final totalAmount = controller.totalAmount;
                      final isButtonEnabled = !isEmpty && totalAmount > 0;
                      
                      return ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () => controller.navigateToPayment()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black26,
                        ),
                        child: Obx(() => Text(
                          langController.finishAndPay,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Add test item button
                  SizedBox(
                    width: double.infinity,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
