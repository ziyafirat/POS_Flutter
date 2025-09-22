import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

      // Don't show popup if we're already on the fraud alert page
      if (controller.appState.value.currentScreen == AppScreen.fraudAlert) {
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

    print('🔍 [FRAUD POPUP] === IMAGE DATA DEBUG START ===');
    print('🔍 [FRAUD POPUP] Alert object: $alert');
    print('🔍 [FRAUD POPUP] Alert is null: ${alert == null}');

    if (alert != null) {
      print('🔍 [FRAUD POPUP] Alert title: ${alert.title}');
      print('🔍 [FRAUD POPUP] Alert message: ${alert.message}');
      print('🔍 [FRAUD POPUP] Alert imageData: ${alert.imageData}');
      print(
        '🔍 [FRAUD POPUP] Alert imageData is null: ${alert.imageData == null}',
      );
      print(
        '🔍 [FRAUD POPUP] Alert imageData isEmpty: ${alert.imageData?.isEmpty}',
      );

      if (alert.imageData != null) {
        print('🔍 [FRAUD POPUP] ImageData length: ${alert.imageData!.length}');
        // Show complete imageData without truncation
        print('🔍 [FRAUD POPUP] Complete ImageData: "${alert.imageData!}"');
      }
    }
    print('🔍 [FRAUD POPUP] === IMAGE DATA DEBUG END ===');

    // Try to extract image data from alert message (similar to MQTT test approach)
    String? imageData;
    String? mimeType;

    if (alert?.message != null) {
      try {
        // Parse the alert message as JSON to extract image data
        final messageJson = jsonDecode(alert!.message);
        print('🔍 [FRAUD POPUP] Parsed message JSON: $messageJson');

        if (messageJson['image'] != null) {
          imageData = messageJson['image']['data'] as String?;
          mimeType = messageJson['image']['mime'] as String?;
          print('📸 [FRAUD POPUP] Extracted image data from message JSON');
          print('📸 [FRAUD POPUP] MIME type: $mimeType');
          print('📸 [FRAUD POPUP] Image data length: ${imageData?.length}');
          print('📸 [FRAUD POPUP] Complete image data: "$imageData"');
        }
      } catch (e) {
        print('❌ [FRAUD POPUP] Failed to parse message as JSON: $e');
      }
    }

    // Check if there's base64 image data (from direct imageData field or extracted from message)
    final finalImageData = imageData ?? alert?.imageData;
    if (finalImageData != null && finalImageData.isNotEmpty) {
      print(
        '📸 [FRAUD POPUP] Found image data, length: ${finalImageData.length}',
      );

      // Create image info for dialog
      final imageInfo = {
        'data': finalImageData,
        'mime': mimeType ?? alert?.imageMimeType ?? 'image/png',
      };

      // Return small thumbnail that opens dialog when clicked
      return _buildImageThumbnail(imageInfo);
    }

    print('❌ [FRAUD POPUP] No image data available - using default image');
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

  /// Simplified image builder matching MQTT test approach
  Widget _buildImage(String base64, bool isGif, {double maxSide = 340}) {
    try {
      print('🖼️ [FRAUD POPUP] === IMAGE BUILDING START ===');
      print(
        '🖼️ [FRAUD POPUP] Building image widget - base64 length: ${base64.length}',
      );
      print('🖼️ [FRAUD POPUP] IsGif parameter: $isGif');
      print('🖼️ [FRAUD POPUP] MaxSide parameter: $maxSide');

      // Validate base64 string
      if (base64.isEmpty) {
        print('❌ [FRAUD POPUP] Empty base64 string');
        return _imagePlaceholder('No image data', Icons.image_not_supported);
      }

      // Clean the base64 string (remove data URL prefix if present) - but be more careful
      String cleanBase64 = base64;
      print(
        '🖼️ [FRAUD POPUP] Original base64 contains "data:": ${base64.contains('data:')}',
      );
      print(
        '🖼️ [FRAUD POPUP] Original base64 contains ",": ${base64.contains(',')}',
      );

      if (base64.contains('data:') && base64.contains(',')) {
        cleanBase64 = base64.split(',').last;
        print(
          '🧹 [FRAUD POPUP] Cleaned base64, new length: ${cleanBase64.length}',
        );
        print(
          '🧹 [FRAUD POPUP] Cleaned base64 first 50 chars: "${cleanBase64.substring(0, cleanBase64.length > 50 ? 50 : cleanBase64.length)}"',
        );
      } else {
        print('🧹 [FRAUD POPUP] No cleaning needed - using original base64');
      }

      // Debug: Show first and last few characters of base64
      final previewLength = 50;
      if (cleanBase64.length > previewLength * 2) {
        print(
          '🔍 [FRAUD POPUP] Base64 preview: "${cleanBase64.substring(0, previewLength)}...${cleanBase64.substring(cleanBase64.length - previewLength)}"',
        );
      } else {
        print('🔍 [FRAUD POPUP] Full base64: "$cleanBase64"');
      }

      // Decode base64 to bytes using the same approach as MQTT test
      final Uint8List bytes;
      try {
        print('🔄 [FRAUD POPUP] Attempting base64 decode...');
        bytes = base64Decode(cleanBase64);
        print('✅ [FRAUD POPUP] Successfully decoded ${bytes.length} bytes');

        // Log first few bytes to check format
        if (bytes.length >= 10) {
          final firstBytes = bytes.take(10).toList();
          print('🔍 [FRAUD POPUP] First 10 bytes: $firstBytes');

          // Try to identify image format
          if (bytes.length >= 6) {
            final headerStr = String.fromCharCodes(bytes.take(6));
            print('🔍 [FRAUD POPUP] Header string: "$headerStr"');

            if (headerStr.startsWith('GIF87a') ||
                headerStr.startsWith('GIF89a')) {
              print('🎬 [FRAUD POPUP] Detected GIF format from header');
            } else if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
              print('📷 [FRAUD POPUP] Detected JPEG format from header');
            } else if (bytes[0] == 0x89 &&
                bytes[1] == 0x50 &&
                bytes[2] == 0x4E &&
                bytes[3] == 0x47) {
              print('🖼️ [FRAUD POPUP] Detected PNG format from header');
            } else {
              print('❓ [FRAUD POPUP] Unknown image format');
            }
          }
        }
      } catch (e) {
        print('❌ [FRAUD POPUP] Base64 decode error: $e');
        print('❌ [FRAUD POPUP] Error type: ${e.runtimeType}');
        return _imagePlaceholder('Invalid base64 data', Icons.broken_image);
      }

      // Validate decoded data
      if (bytes.isEmpty) {
        print('❌ [FRAUD POPUP] Empty decoded bytes');
        return _imagePlaceholder('Empty image data', Icons.image_not_supported);
      }

      // Use the same simple approach as MQTT test - Image.memory for everything
      // This is what works in MQTT test, so let's use the same approach
      print(
        '🖼️ [FRAUD POPUP] Creating Image.memory widget with ${bytes.length} bytes',
      );
      print('🖼️ [FRAUD POPUP] Image dimensions: ${maxSide}x${maxSide}');

      final media = Image.memory(
        bytes,
        height: maxSide,
        width: maxSide,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('❌ [FRAUD POPUP] Image.memory error: $error');
          print('❌ [FRAUD POPUP] Error type: ${error.runtimeType}');
          print('❌ [FRAUD POPUP] Stack trace: $stackTrace');
          return _imagePlaceholder('Load failed', Icons.broken_image);
        },
      );

      print('✅ [FRAUD POPUP] Image.memory widget created successfully');
      print('🖼️ [FRAUD POPUP] === IMAGE BUILDING END ===');

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(6), child: media),
      );
    } catch (e, stackTrace) {
      print('❌ [FRAUD POPUP] General image error: $e');
      print('❌ [FRAUD POPUP] Error type: ${e.runtimeType}');
      print('❌ [FRAUD POPUP] Stack trace: $stackTrace');
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

  /// Show image dialog similar to mqtt_test_widget
  void _showImageDialog(Map<String, dynamic> imageInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
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
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fraud Alert Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              '${imageInfo['mime']}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Image Display
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: _buildLargeImageWidget(imageInfo),
                  ),
                ),
                // Footer with actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build large image widget for dialog
  Widget _buildLargeImageWidget(Map<String, dynamic> imageInfo) {
    try {
      // Decode base64 data
      final dataString = imageInfo['data'] as String?;
      if (dataString == null || dataString.isEmpty) {
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text('No image data available'),
              ],
            ),
          ),
        );
      }

      final bytes = base64Decode(dataString);
      final mimeType = imageInfo['mime'] as String?;

      if (mimeType == 'image/gif') {
        // For GIF images, display them as regular images
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Error loading image'),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // For regular images
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Error loading image'),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              const SizedBox(height: 8),
              Text('Error: $e'),
            ],
          ),
        ),
      );
    }
  }

  /// Build small thumbnail that opens dialog when clicked
  Widget _buildImageThumbnail(Map<String, dynamic> imageInfo) {
    try {
      final dataString = imageInfo['data'] as String;
      final bytes = base64Decode(dataString);

      return GestureDetector(
        onTap: () => _showImageDialog(imageInfo),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: const Icon(Icons.broken_image, color: Colors.grey, size: 30),
      );
    }
  }

  /// Debug method to test image display with sample data
  static void debugTestImage(String base64Data) {
    print(
      '🧪 [FRAUD POPUP DEBUG] Testing image with ${base64Data.length} chars',
    );

    try {
      // Clean the base64 string (same logic as _buildImage)
      String cleanBase64 = base64Data;
      if (base64Data.contains('data:') && base64Data.contains(',')) {
        cleanBase64 = base64Data.split(',').last;
        print(
          '🧪 [FRAUD POPUP DEBUG] Cleaned base64, new length: ${cleanBase64.length}',
        );
      }

      // Try to decode
      final bytes = base64Decode(cleanBase64);
      print(
        '🧪 [FRAUD POPUP DEBUG] Successfully decoded ${bytes.length} bytes',
      );

      // Check first few bytes for format detection
      if (bytes.length >= 10) {
        final header = bytes.take(10).toList();
        print('🧪 [FRAUD POPUP DEBUG] First 10 bytes: $header');

        // Check for common image headers
        if (bytes.length >= 6) {
          final headerStr = String.fromCharCodes(bytes.take(6));
          print('🧪 [FRAUD POPUP DEBUG] Header string: "$headerStr"');
        }
      }
    } catch (e, stackTrace) {
      print('🧪 [FRAUD POPUP DEBUG] Error: $e');
      print('🧪 [FRAUD POPUP DEBUG] Stack trace: $stackTrace');
    }
  }
}
