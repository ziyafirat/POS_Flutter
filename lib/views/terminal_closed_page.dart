import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';
import '../widgets/almaya_header.dart';

class TerminalClosedPage extends StatelessWidget {
  const TerminalClosedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final LanguageController langController = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Column(
        children: [
          // Header with Almaya logo
          const AlmayaHeader(pageTitle: 'TERMINAL CLOSED'),

          // Main content area
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Terminal Closed Icon/Image
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Terminal icon
                          Icon(
                            Icons.point_of_sale,
                            size: 80,
                            color: Colors.orange[600],
                          ),
                          // Closed/Lock overlay
                          Positioned(
                            bottom: 40,
                            right: 40,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Terminal Closed Title
                    Text(
                      langController.isEnglish
                          ? 'Terminal Closed'
                          : 'المحطة مغلقة',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Subtitle message
                    Text(
                      langController.isEnglish
                          ? 'This terminal is currently closed for service'
                          : 'هذه المحطة مغلقة حاليًا للخدمة',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Additional information
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 32,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            langController.isEnglish
                                ? 'Please use another terminal or contact staff for assistance'
                                : 'يرجى استخدام محطة أخرى أو الاتصال بالموظفين للحصول على المساعدة',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Status information
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Terminal Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.terminal,
                                    color: Colors.orange[600],
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Terminal: 500',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: Colors.orange[600],
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(
                                    () => Text(
                                      'Status: ${controller.posSubState.isNotEmpty ? controller.posSubState : "Closed"}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.orange[600],
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateTime.now().toString().substring(11, 16),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Contact Staff Button
                        SizedBox(
                          width: 180,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Help functionality - could trigger staff alert
                              Get.snackbar(
                                'Staff Notified',
                                'Staff has been notified and will assist you shortly',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 3),
                              );
                            },
                            icon: const Icon(Icons.support_agent, size: 20),
                            label: Text(
                              langController.isEnglish
                                  ? 'Contact Staff'
                                  : 'اتصل بالموظفين',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black26,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // POS Cashier Mode Button (for staff)
                        SizedBox(
                          width: 180,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              controller.navigateToPosCashier();
                            },
                            icon: const Icon(
                              Icons.admin_panel_settings,
                              size: 20,
                            ),
                            label: Text(
                              langController.isEnglish
                                  ? 'Staff Mode'
                                  : 'وضع الموظفين',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange[600],
                              side: BorderSide(color: Colors.orange[600]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
          ),
        ],
      ),
    );
  }
}
