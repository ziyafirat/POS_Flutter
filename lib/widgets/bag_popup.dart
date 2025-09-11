import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';

class BagPopup extends StatelessWidget {
  const BagPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    color: Colors.green[700],
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Obx(() => Text(
                    langController.addPlasticBag,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Bag count display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Obx(() => Text(
                    langController.bagCount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                    '${controller.bagCount}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                    langController.bagPrice,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Plus and minus buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Minus button
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.red[200]!, width: 2),
                  ),
                  child: Obx(() => IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 40,
                      color: controller.bagCount > 0 ? Colors.red[700] : Colors.grey[400],
                    ),
                    onPressed: controller.bagCount > 0 ? controller.removeBag : null,
                  )),
                ),
                
                // Plus button
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.green[200]!, width: 2),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.green[700],
                    ),
                    onPressed: controller.addBag,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Finish button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close popup
                  controller.navigateToPayment(); // Navigate to payment
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: Obx(() => Text(
                  langController.finishShopping,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
