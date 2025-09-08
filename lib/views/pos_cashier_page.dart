import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../services/web_api_service.dart';

class PosCashierPage extends StatefulWidget {
  const PosCashierPage({super.key});

  @override
  State<PosCashierPage> createState() => _PosCashierPageState();
}

class _PosCashierPageState extends State<PosCashierPage> {
  String _numberInput = '';

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final WebApiService webApiService = Get.find<WebApiService>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // Left Side - Buttons
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header with PosSubState and Display
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
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
                  
                  // Number Input Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        const Text(
                          'Number Input:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _numberInput.isEmpty ? 'Enter numbers...' : _numberInput,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _numberInput.isEmpty ? Colors.grey[400] : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _numberInput.isNotEmpty ? _clearNumberInput : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[100],
                                foregroundColor: Colors.red[700],
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text('Clear', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Top Action Buttons (Dark Gray)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'E VOUCHERS',
                                  Icons.card_giftcard,
                                  Colors.grey[800]!,
                                  () => _sendApiCommand(webApiService, '<67>'), // Using refund for vouchers
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'DONATION',
                                  Icons.favorite,
                                  Colors.grey[800]!,
                                  () => _sendApiCommand(webApiService, '<100>'), // Using nosale for donation
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'CUSTOMER SCREEN',
                                  Icons.monitor,
                                  Colors.grey[800]!,
                                  () => controller.navigateToStart(), // Exit POS Cashier mode
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'Print',
                                  Icons.print,
                                  Colors.grey[800]!,
                                  () => _sendApiCommand(webApiService, '<100>'), // Using nosale
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Function Buttons (Blue and Green)
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // Blue Buttons Row 1
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'CLEAR',
                                  Icons.clear,
                                  Colors.blue[600]!,
                                  () => _sendApiCommand(webApiService, '<73>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'NOSALE',
                                  Icons.flash_on,
                                  Colors.blue[600]!,
                                  () => _sendApiCommand(webApiService, '<100>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'OVERRIDE',
                                  Icons.build,
                                  Colors.blue[600]!,
                                  () => _sendApiCommand(webApiService, '<79>'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Blue Buttons Row 2
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'PRICE',
                                  Icons.attach_money,
                                  Colors.blue[600]!,
                                  () => _sendApiCommand(webApiService, '<74>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'ENTER',
                                  Icons.arrow_forward,
                                  Colors.red[600]!,
                                  () => _sendApiCommand(webApiService, '<80>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'VOID',
                                  Icons.delete,
                                  Colors.blue[600]!,
                                  () => _sendApiCommand(webApiService, '<70>'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Green Buttons Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'RESCAN',
                                  Icons.refresh,
                                  Colors.green[600]!,
                                  () => _sendApiCommand(webApiService, '<75>'), // Using quantity for rescan
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'OFFLINE EFT',
                                  Icons.credit_card,
                                  Colors.green[600]!,
                                  () => _sendApiCommand(webApiService, '<94>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'UNSCANNED',
                                  Icons.camera_alt,
                                  Colors.green[600]!,
                                  () => _sendApiCommand(webApiService, '<100>'), // Using nosale
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Payment Buttons (Red)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'CASH',
                                  Icons.money,
                                  Colors.red[600]!,
                                  () => _sendApiCommand(webApiService, '<91>'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'CREDIT CARD',
                                  Icons.credit_card,
                                  Colors.red[600]!,
                                  () => _sendApiCommand(webApiService, '<92>'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  'AUTO PICKUP',
                                  Icons.local_shipping,
                                  Colors.red[600]!,
                                  () => _sendApiCommand(webApiService, '<100>'), // Using nosale
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'TOTAL',
                                  Icons.grid_view,
                                  Colors.red[600]!,
                                  () => _sendApiCommand(webApiService, '<81>'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Numeric Keypad (Dark Gray)
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // Row 1: 7, 8, 9
                          Row(
                            children: [
                              Expanded(child: _buildNumberButton('7')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('8')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('9')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row 2: 4, 5, 6
                          Row(
                            children: [
                              Expanded(child: _buildNumberButton('4')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('5')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('6')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row 3: 1, 2, 3
                          Row(
                            children: [
                              Expanded(child: _buildNumberButton('1')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('2')),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('3')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row 4: *, 0, SignOn
                          Row(
                            children: [
                              Expanded(child: _buildActionButton('*', Icons.close, Colors.grey[800]!, () {})),
                              const SizedBox(width: 10),
                              Expanded(child: _buildNumberButton('0')),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  'SignOn',
                                  Icons.login,
                                  Colors.grey[800]!,
                                  () => _sendApiCommand(webApiService, '<61>'),
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
          ),
          
          // Right Side - Items List
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    color: Colors.blue[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          'Total: ${controller.totalAmount.toStringAsFixed(2)} TL',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )),
                        Row(
                          children: [
                            Text(
                              'Terminal: 500',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Operator: 500',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Obx(() => Text(
                              controller.posSubState.isNotEmpty ? controller.posSubState : '10-1001',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            )),
                            const SizedBox(width: 15),
                            Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Items List
                  Expanded(
                    child: Obx(() {
                      if (controller.scannedItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'No items scanned',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        padding: const EdgeInsets.all(15),
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
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.blue[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: $qty Unit: $uom',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '$price TL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, size: 24),
                                  onPressed: () => controller.removeScannedItem(index),
                                  color: Colors.red[600],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _numberInput += number;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _clearNumberInput() {
    setState(() {
      _numberInput = '';
    });
  }

  void _sendApiCommand(WebApiService webApiService, String displayLine) {
    // Combine number input with command (e.g., "1<80>" if number input is "1" and command is "<80>")
    String combinedCommand = _numberInput + displayLine;
    
    // Send one-time API request with the combined DisplayLine
    webApiService.sendOneTimeRequest(combinedCommand);
    
    // Clear the number input after sending command
    _clearNumberInput();
  }
}
