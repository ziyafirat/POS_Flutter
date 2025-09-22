import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import '../controllers/app_controller.dart';
import '../models/app_state.dart';
import '../config/popup_config.dart';
import 'responsive_button_row.dart';

class FraudAlertPopup extends StatefulWidget {
  const FraudAlertPopup({super.key});

  @override
  State<FraudAlertPopup> createState() => _FraudAlertPopupState();
}

class _FraudAlertPopupState extends State<FraudAlertPopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    // Initialize pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Obx(() {
      final alert = controller.currentAlert;
      if (alert == null || !controller.isAlertActive) {
        return const SizedBox.shrink();
      }

      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Backdrop
            GestureDetector(
              onTap: () {
                // Don't dismiss on backdrop tap for fraud alerts
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.7),
              ),
            ),

            // Popup content
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width *
                            PopupConfig.standardWidth,
                        constraints: const BoxConstraints(
                          maxWidth: PopupConfig.maxWidth,
                          maxHeight: PopupConfig.maxHeight,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          borderRadius: BorderRadius.circular(
                            PopupConfig.borderRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: PopupConfig.shadowBlurRadius,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                PopupConfig.headerPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[800],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    PopupConfig.borderRadius,
                                  ),
                                  topRight: Radius.circular(
                                    PopupConfig.borderRadius,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.security,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '🚨 FRAUD ALERT 🚨',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),

                            // Image/GIF
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildAlertImage(),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Alert info
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Type: ${alert.type.name.toUpperCase()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${alert.id}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Action buttons
                            Padding(
                              padding: const EdgeInsets.all(
                                PopupConfig.headerPadding,
                              ),
                              child: Column(
                                children: [
                                  // First row: Close and Send Feedback (equal width)
                                  ResponsiveButtonRow(
                                    buttons: [
                                      ResponsiveButton.normal(
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            controller.dismissAlert();
                                            controller.navigateToStart();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Close',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ResponsiveButton.normal(
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _sendFraudFeedback();
                                          },
                                          icon: const Icon(
                                            Icons.feedback,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Send Feedback',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    spacing: 15,
                                  ),
                                  const SizedBox(height: 10),
                                  // Second row: View Details (full width)
                                  ResponsiveButtonRow(
                                    buttons: [
                                      ResponsiveButton.normal(
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _showFullAlert();
                                          },
                                          icon: const Icon(
                                            Icons.visibility,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'View Details',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAlertImage() {
    final AppController controller = Get.find<AppController>();
    final alert = controller.currentAlert;

    // Check if there's base64 image data first (priority over video URL)
    if (alert?.imageData != null && alert!.imageData!.isNotEmpty) {
      print(
        '📸 [FRAUD POPUP] Found image data, length: ${alert.imageData!.length}',
      );
      // Determine if it's a GIF based on the base64 data header or file extension
      bool isGif = _isGifData(alert.imageData!);
      print(
        '🎭 [FRAUD POPUP] Image type determined: ${isGif ? 'GIF' : 'Static Image'}',
      );
      return _buildImage(alert.imageData!, isGif);
    }

    // Return default alert image if no image data is available
    return _buildDefaultAlertImage();
  }

  Widget _buildDefaultAlertImage() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(
              'FRAUD DETECTED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullAlert() {
    // Navigate to full fraud alert page
    final AppController controller = Get.find<AppController>();
    controller.navigateToScreen(AppScreen.fraudAlert);
  }

  void _sendFraudFeedback() {
    final AppController controller = Get.find<AppController>();
    final alert = controller.currentAlert;

    if (alert != null) {
      // Send fraud feedback via MQTT
      controller.mqttService.sendFraudFeedback(alert.id, 'fraud_confirmed');

      // Show confirmation dialog instead of snackbar to avoid overlay issues
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.feedback, color: Colors.white, size: 32),
                const SizedBox(height: 12),
                const Text(
                  'Fraud Feedback Sent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fraud feedback sent successfully to security team',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close confirmation dialog
                    // Dismiss alert after sending feedback
                    controller.dismissAlert();
                    controller.navigateToStart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  /// Improved image/GIF builder with better error handling
  Widget _buildImage(String base64, bool isGif, {double maxSide = 340}) {
    try {
      // Validate base64 string
      if (base64.isEmpty) {
        return _imagePlaceholder('No image data', Icons.image_not_supported);
      }

      // Clean the base64 string (remove data URL prefix if present)
      String cleanBase64 = base64;
      if (base64.contains(',')) {
        cleanBase64 = base64.split(',').last;
      }

      // Decode base64 to bytes
      final Uint8List bytes;
      try {
        bytes = base64Decode(cleanBase64);
      } catch (e) {
        return _imagePlaceholder('Invalid base64 data', Icons.broken_image);
      }

      // Validate decoded data
      if (bytes.isEmpty) {
        return _imagePlaceholder('Empty image data', Icons.image_not_supported);
      }

      // Build the media widget
      print(
        '🖼️ [FRAUD POPUP] Building image widget - isGif: $isGif, bytes: ${bytes.length}',
      );

      final media = isGif
          ? GifView.memory(
              bytes,
              height: maxSide,
              width: maxSide,
              fit: BoxFit.contain,
            )
          : Image.memory(
              bytes,
              height: maxSide,
              width: maxSide,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) {
                print('❌ [FRAUD POPUP] Image error: $e');
                return _imagePlaceholder('Load failed', Icons.broken_image);
              },
            );

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(6), child: media),
      );
    } catch (e) {
      return _imagePlaceholder('Image error: ${e.toString()}', Icons.error);
    }
  }

  /// Helper method to create error/placeholder widgets
  Widget _imagePlaceholder(String message, IconData icon) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to detect if base64 data represents a GIF
  bool _isGifData(String base64) {
    try {
      print('🔍 [FRAUD POPUP] Checking if data is GIF...');

      // Check data URL prefix
      if (base64.toLowerCase().contains('data:image/gif')) {
        print('✅ [FRAUD POPUP] Found GIF data URL prefix');
        return true;
      }

      // Clean the base64 string
      String cleanBase64 = base64;
      if (base64.contains(',')) {
        cleanBase64 = base64.split(',').last;
      }

      // Decode and check GIF header (GIF87a or GIF89a)
      final bytes = base64Decode(cleanBase64);
      print('📊 [FRAUD POPUP] Decoded ${bytes.length} bytes');

      if (bytes.length >= 6) {
        final header = String.fromCharCodes(bytes.take(6));
        print('🔤 [FRAUD POPUP] File header: "$header"');
        final isGif =
            header.startsWith('GIF87a') || header.startsWith('GIF89a');
        print('🎬 [FRAUD POPUP] Is GIF: $isGif');
        return isGif;
      }

      print('⚠️ [FRAUD POPUP] Not enough bytes for header check');
      return false;
    } catch (e) {
      print('❌ [FRAUD POPUP] Error checking GIF data: $e');
      return false; // Default to static image if detection fails
    }
  }
}
