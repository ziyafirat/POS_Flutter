import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

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
            ),
          ),
          
          // Right Side - Payment Options and Buttons
          Expanded(
            flex: 2,
            child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                  // Selection prompt
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
                        Obx(() => Text(
                          langController.makeSelection,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        const SizedBox(height: 15),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 40,
                          color: Colors.green[600],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Payment method buttons grid
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
                                    controller.processPayment('cash');
                                  },
                                  icon: const Icon(Icons.money, size: 28),
                                  label: Obx(() => Text(
                                    langController.cash,
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
                                    controller.processPayment('card');
                                  },
                                  icon: const Icon(Icons.credit_card, size: 28),
                                  label: Obx(() => Text(
                                    langController.credit,
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
                                    controller.processPayment('change');
                                  },
                                  icon: const Icon(Icons.monetization_on, size: 28),
                                  label: Obx(() => Text(
                                    langController.paymentWithChange,
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    controller.processPayment('staff_card');
                                  },
                                  icon: const Icon(Icons.badge, size: 28),
                                  label: Obx(() => Text(
                                    langController.paymentWithStaffCard,
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Bottom action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.navigateToItemScan(),
                          icon: const Icon(Icons.arrow_back),
                          label: Obx(() => Text(langController.returnScanMore)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Help functionality
                          },
                          icon: const Icon(Icons.help),
                          label: Obx(() => Text(langController.requestHelp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}
