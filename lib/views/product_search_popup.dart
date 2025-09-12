import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import 'help_page.dart';

class ProductSearchPopup extends StatefulWidget {
  final Function(String) onProductSelected;

  const ProductSearchPopup({
    Key? key,
    required this.onProductSelected,
  }) : super(key: key);

  @override
  State<ProductSearchPopup> createState() => _ProductSearchPopupState();
}

class _ProductSearchPopupState extends State<ProductSearchPopup> {
  final TextEditingController _searchController = TextEditingController();
  final LanguageController langController = Get.find<LanguageController>();
  
  String _selectedTab = 'Alphabet';
  String _selectedFilter = 'C';
  String _searchQuery = 'Coca-Cola';
  int _currentPage = 1;
  bool _showKeyboard = true;

  // Sample products data
  final List<Map<String, dynamic>> _products = [
    {'name': 'Coca-Cola', 'image': 'assets/coca_cola_can.png', 'price': 2.50},
    {'name': 'Coca-Cola', 'image': 'assets/coca_cola_bottle.png', 'price': 3.00},
    {'name': 'Coca-Cola 6-Pack', 'image': 'assets/coca_cola_6pack.png', 'price': 12.00},
    {'name': 'Coca-Cola Cherry', 'image': 'assets/coca_cola_cherry.png', 'price': 2.50},
    {'name': 'Coca-Cola Zero', 'image': 'assets/coca_cola_zero.png', 'price': 2.50},
    {'name': 'Coca-Cola Vanilla', 'image': 'assets/coca_cola_vanilla.png', 'price': 2.50},
  ];

  final List<String> _alphabetFilters = ['A-B', 'C', 'D-G', 'H-L', 'M-O', 'P-R', 'S-T', 'U-Z'];

  @override
  void initState() {
    super.initState();
    _searchController.text = _searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToSearch(String text) {
    setState(() {
      _searchController.text += text;
      _searchQuery = _searchController.text;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _backspace() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _searchController.text = _searchController.text.substring(0, _searchController.text.length - 1);
        _searchQuery = _searchController.text;
      }
    });
  }

  void _selectProduct(String productName) {
    widget.onProductSelected(productName);
    Navigator.of(context).pop();
  }

  void _toggleKeyboard() {
    setState(() {
      _showKeyboard = !_showKeyboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1000,
        height: 1200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
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
            // Top Navigation and Search Bar
            Container(
              height: 80,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Tabs
                  Row(
                    children: [
                      _buildTab('Alphabet', _selectedTab == 'Alphabet'),
                      const SizedBox(width: 5),
                      _buildTab('Categories', _selectedTab == 'Categories'),
                    ],
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(Icons.search, color: Colors.grey, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search products...',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: _clearSearch,
                              child: Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Alphabetical Filters
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: _alphabetFilters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue[700] : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
                        minimumSize: const Size(100, 60),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        filter,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Product Display Area
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
            ),

            // Middle Action Buttons
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  // Left side buttons
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[700],
                              minimumSize: const Size(140, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Obx(() => Text(langController.backToScanning, style: TextStyle(fontSize: 16))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close popup first
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HelpPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[700],
                              minimumSize: const Size(140, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Obx(() => Text(langController.assistance, style: TextStyle(fontSize: 16))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Right side buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _currentPage > 1 ? () {
                          setState(() {
                            _currentPage--;
                          });
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Obx(() => Text(langController.previousPage, style: TextStyle(fontSize: 16))),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentPage++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Obx(() => Text(langController.nextPage, style: TextStyle(fontSize: 16))),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Keyboard Section
            if (_showKeyboard)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      // QWERTY Keyboard
                      Expanded(
                        flex: 3,
                        child: _buildQWERTYKeyboard(),
                      ),
                      
                      const SizedBox(width: 15),
                      
                      // Numeric Keypad
                      Expanded(
                        flex: 1,
                        child: _buildNumericKeypad(),
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

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => _selectProduct(product['name']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Product Image Placeholder
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Icon(
                  Icons.local_drink,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            
            // Product Name
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  product['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQWERTYKeyboard() {
    const List<List<String>> keyboard = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Column(
      children: [
        // Keyboard header
        Row(
          children: [
            IconButton(
              onPressed: _toggleKeyboard,
              icon: const Icon(Icons.keyboard_arrow_up, size: 20),
            ),
            const Spacer(),
            IconButton(
              onPressed: _toggleKeyboard,
              icon: const Icon(Icons.keyboard_hide, size: 20),
            ),
          ],
        ),
        
        // Keyboard rows
        Expanded(
          child: Column(
            children: keyboard.map((row) {
              return Expanded(
                child: Row(
                  children: [
                    if (row == keyboard[1]) const SizedBox(width: 20), // Offset for second row
                    if (row == keyboard[2]) const SizedBox(width: 40), // Offset for third row
                    ...row.map((key) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          child: ElevatedButton(
                            onPressed: () => _addToSearch(key),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey[800],
                              minimumSize: const Size(70, 70),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 1,
                            ),
                            child: Text(
                              key,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    if (row == keyboard[0]) // First row special keys
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          child: ElevatedButton(
                            onPressed: _backspace,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey[800],
                              minimumSize: const Size(70, 70),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 1,
                            ),
                            child: const Icon(Icons.backspace, size: 24),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        // Bottom row with special keys
        Expanded(
          child: Row(
            children: [
              // Shift key
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      minimumSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: const Icon(Icons.keyboard_arrow_up, size: 24),
                  ),
                ),
              ),
              
              // @ key
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () => _addToSearch('@'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      minimumSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: const Text('@', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              
              // Globe key
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      minimumSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: const Icon(Icons.language, size: 24),
                  ),
                ),
              ),
              
              // Space bar
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () => _addToSearch(' '),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      minimumSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: Obx(() => Text(langController.space, style: TextStyle(fontSize: 16))),
                  ),
                ),
              ),
              
              // Enter key
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[800],
                      minimumSize: const Size(30, 30),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: Obx(() => Text(langController.enter, style: TextStyle(fontSize: 16))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumericKeypad() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1.0, // Makes buttons square
      children: [
        // Numbers 7-9
        _buildNumericButton('7'),
        _buildNumericButton('8'),
        _buildNumericButton('9'),
        
        // Numbers 4-6
        _buildNumericButton('4'),
        _buildNumericButton('5'),
        _buildNumericButton('6'),
        
        // Numbers 1-3
        _buildNumericButton('1'),
        _buildNumericButton('2'),
        _buildNumericButton('3'),
        
        // Bottom row: 0, -, +
        _buildNumericButton('0'),
        _buildNumericButton('-'),
        _buildNumericButton('+'),
      ],
    );
  }

  Widget _buildNumericButton(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _addToSearch(text),
          borderRadius: BorderRadius.circular(6),
                child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
