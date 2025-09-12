import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Help Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Help Title
                    Obx(() => Text(
                      langController.isEnglish ? 'Help & Support' : 'Yardım & Destek',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    )),
                    
                    const SizedBox(height: 10),
                    
                    // Help Subtitle
                    Obx(() => Text(
                      langController.isEnglish ? 'We are here to assist you' : 'Size yardımcı olmak için buradayız',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Help Content Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Help Information
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Contact Information
                            Obx(() => _buildHelpItem(
                              icon: Icons.phone,
                              title: langController.isEnglish ? 'Call for Assistance' : 'Yardım İçin Arayın',
                              subtitle: langController.isEnglish ? 'Press the assistance button on any screen' : 'Herhangi bir ekranda yardım butonuna basın',
                              color: Colors.green,
                            )),
                            
                            const SizedBox(height: 30),
                            
                            Obx(() => _buildHelpItem(
                              icon: Icons.person,
                              title: langController.isEnglish ? 'Staff Support' : 'Personel Desteği',
                              subtitle: langController.isEnglish ? 'A staff member will be with you shortly' : 'Bir personel kısa süre içinde yanınızda olacak',
                              color: Colors.orange,
                            )),
                            
                            const SizedBox(height: 30),
                            
                            Obx(() => _buildHelpItem(
                              icon: Icons.info,
                              title: langController.isEnglish ? 'Self-Service Tips' : 'Self-Servis İpuçları',
                              subtitle: langController.isEnglish ? 'Scan items one at a time and follow the on-screen instructions' : 'Ürünleri tek tek tarayın ve ekrandaki talimatları takip edin',
                              color: Colors.blue,
                            )),
                            
                            const SizedBox(height: 30),
                            
                            Obx(() => _buildHelpItem(
                              icon: Icons.shopping_bag,
                              title: langController.isEnglish ? 'Bagging Items' : 'Ürünleri Poşetleme',
                              subtitle: langController.isEnglish ? 'Place items in the bagging area after scanning' : 'Tarama sonrası ürünleri poşetleme alanına yerleştirin',
                              color: Colors.purple,
                            )),
                          ],
                        ),
                      ),
                      
                      // Close Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black26,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_back, size: 24),
                              const SizedBox(width: 10),
                              Obx(() => Text(
                                langController.isEnglish ? 'Close Help' : 'Yardımı Kapat',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        
        const SizedBox(width: 20),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
