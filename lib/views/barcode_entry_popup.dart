import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_checkout_app/controllers/language_controller.dart';

class BarcodeEntryPopup extends StatefulWidget {
  final Function(String) onBarcodeEntered;
  final VoidCallback onCancel;

  const BarcodeEntryPopup({
    Key? key,
    required this.onBarcodeEntered,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<BarcodeEntryPopup> createState() => _BarcodeEntryPopupState();
}

class _BarcodeEntryPopupState extends State<BarcodeEntryPopup> {
  final TextEditingController _barcodeController = TextEditingController();
  final LanguageController langController = Get.find<LanguageController>();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    setState(() {
      _barcodeController.text += digit;
    });
  }

  void _clear() {
    setState(() {
      _barcodeController.clear();
    });
  }

  void _backspace() {
    setState(() {
      if (_barcodeController.text.isNotEmpty) {
        _barcodeController.text = _barcodeController.text.substring(0, _barcodeController.text.length - 1);
      }
    });
  }

  void _enter() {
    if (_barcodeController.text.isNotEmpty) {
      widget.onBarcodeEntered(_barcodeController.text);
      Navigator.of(context).pop();
    }
  }

  void _cancel() {
    widget.onCancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        height: 900,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              height: 120,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // Illustration Row
                  Row(
                    children: [
                      // Package with barcode
                      Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Stack(
                          children: [
                            // Barcode lines
                            Positioned(
                              left: 10,
                              right: 10,
                              top: 20,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(8, (index) => 
                                    Container(
                                      width: 2,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Circle around barcode
                            Positioned(
                              left: 5,
                              right: 5,
                              top: 15,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.green, width: 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Arrow
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Terminal device
                      Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Text(
                                  '123',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Instruction banner
                  Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Obx(() => Center(
                      child: Text(
                        langController.isEnglish ? 'Key in Code and Touch ENTER' : 'Kodu Girin ve ENTER\'a Dokunun',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            
            // Input Field Section
            Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _barcodeController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                autofocus: true,
                readOnly: true,
              ),
            ),
            
            // Keypad Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // Main keypad grid (4x3)
                    Expanded(
                      flex: 2,
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        children: [
                          // Row 1: 1, 2, 3
                          _buildNumberButton('1'),
                          _buildNumberButton('2'),
                          _buildNumberButton('3'),
                          // Row 2: 4, 5, 6
                          _buildNumberButton('4'),
                          _buildNumberButton('5'),
                          _buildNumberButton('6'),
                          // Row 3: 7, 8, 9
                          _buildNumberButton('7'),
                          _buildNumberButton('8'),
                          _buildNumberButton('9'),
                          // Row 4: Clear, 0, Back
                          _buildActionButton('Clear', _clear, Colors.grey[600]!),
                          _buildNumberButton('0'),
                          _buildActionButton('Back', _backspace, Colors.grey[600]!),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Action buttons row
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: ElevatedButton(
                              onPressed: _cancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.close, size: 24),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(langController.cancel, style: const TextStyle(fontSize: 16))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // Enter button
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: ElevatedButton(
                              onPressed: _enter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check, size: 24),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(langController.enter, style: const TextStyle(fontSize: 16))),
                                ],
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

  Widget _buildNumberButton(String number) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _addDigit(number),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Obx(() => Text(
                text == 'Clear' ? langController.clear :
                text == 'Back' ? langController.back : text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
