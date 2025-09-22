import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/app_controller.dart';

class FraudAlertPage extends StatefulWidget {
  const FraudAlertPage({super.key});

  @override
  State<FraudAlertPage> createState() => _FraudAlertPageState();
}

class _FraudAlertPageState extends State<FraudAlertPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Start animations
    _pulseController.repeat(reverse: true);
    _shakeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Obx(() {
        final alert = controller.currentAlert;
        if (alert == null) {
          return const Center(
            child: Text(
              'No active fraud alerts',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        return Stack(
          children: [
            // Background with animated gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red[900]!, Colors.red[800]!, Colors.black],
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Alert Header with animations
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Animated warning icon
                            AnimatedBuilder(
                              animation: _shakeAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_shakeAnimation.value, 0),
                                  child: const Icon(
                                    Icons.security,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '🚨 FRAUD ALERT 🚨',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // GIF/Image Display Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildAlertImage(),
                    ),
                  ),
                ),

                // Alert Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: const Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Alert Type: ${alert.type.name.toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'ID: ${alert.id}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Time: ${_formatTimestamp(alert.timestamp)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.dismissAlert();
                            controller
                                .returnToPreviousPageAfterFraudAlert(); // Return to previous page after dismissing
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Close Page',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Call security or report function
                            _reportFraud();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Send Alert Feedback',
                            style: TextStyle(
                              fontSize: 16,
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
          ],
        );
      }),
    );
  }

  Widget _buildAlertImage() {
    final AppController controller = Get.find<AppController>();
    final alert = controller.currentAlert;

    print('🔍 [FRAUD PAGE] === IMAGE DATA DEBUG START ===');
    print('🔍 [FRAUD PAGE] Alert object: $alert');
    print('🔍 [FRAUD PAGE] Alert is null: ${alert == null}');

    if (alert != null) {
      print('🔍 [FRAUD PAGE] Alert title: ${alert.title}');
      print('🔍 [FRAUD PAGE] Alert message: ${alert.message}');
      print('🔍 [FRAUD PAGE] Alert imageData: ${alert.imageData}');
      print(
        '🔍 [FRAUD PAGE] Alert imageData is null: ${alert.imageData == null}',
      );

      // Parse alert message as JSON to extract nested image data
      String? imageData;
      String? mimeType;

      try {
        final messageJson = jsonDecode(alert.message);
        print('🔍 [FRAUD PAGE] Parsed message JSON: $messageJson');

        // Extract image data from nested JSON structure
        if (messageJson['image'] != null) {
          final imageInfo = messageJson['image'];
          imageData = imageInfo['data']?.toString();
          mimeType = imageInfo['mime']?.toString();
          print('📸 [FRAUD PAGE] Extracted image data from message JSON');
          print('📸 [FRAUD PAGE] MIME type: $mimeType');
          print('📸 [FRAUD PAGE] Image data length: ${imageData?.length}');
          print('📸 [FRAUD PAGE] Complete image data: "$imageData"');
        }
      } catch (e) {
        print('❌ [FRAUD PAGE] Failed to parse message as JSON: $e');
      }

      // Check if there's base64 image data (from direct imageData field or extracted from message)
      final finalImageData = imageData ?? alert.imageData;
      if (finalImageData != null && finalImageData.isNotEmpty) {
        print(
          '📸 [FRAUD PAGE] Found image data, length: ${finalImageData.length}',
        );

        // Create image info for dialog
        final imageInfo = {
          'data': finalImageData,
          'mime': mimeType ?? alert.imageMimeType ?? 'image/png',
        };

        // Return large image that can be clicked to open dialog
        return _buildLargeImage(imageInfo);
      }
    }

    // Check if there's a video URL (for GIF or video)
    if (alert?.videoUrl != null && alert!.videoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: alert.videoUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[800],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading Alert Image...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAlertImage(),
      );
    }

    print('❌ [FRAUD PAGE] No image data available - using default image');
    return _buildDefaultAlertImage();
  }

  /// Build large image that can be clicked to open dialog
  Widget _buildLargeImage(Map<String, dynamic> imageInfo) {
    try {
      final dataString = imageInfo['data'] as String;
      final bytes = base64Decode(dataString);

      return Center(
        child: GestureDetector(
          onTap: () => _showImageDialog(imageInfo),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.5, // 50% of screen width
            height:
                MediaQuery.of(context).size.height *
                0.3, // 30% of screen height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.red, size: 80),
                          SizedBox(height: 20),
                          Text(
                            'Error Loading Image',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.red, size: 80),
              SizedBox(height: 20),
              Text(
                'Error Decoding Image',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
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
                    child: _buildDialogImage(imageInfo),
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

  /// Build image for dialog
  Widget _buildDialogImage(Map<String, dynamic> imageInfo) {
    try {
      final dataString = imageInfo['data'] as String;
      final bytes = base64Decode(dataString);

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

  Widget _buildDefaultAlertImage() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: Colors.red, size: 80),
            SizedBox(height: 20),
            Text(
              'FRAUD DETECTED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Security Alert Active',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _reportFraud() async {
    final AppController controller = Get.find<AppController>();
    final alert = controller.currentAlert;

    if (alert == null) {
      _showErrorDialog('No alert data available');
      return;
    }

    try {
      // Send fraud feedback directly to MQTT
      final success = await controller.mqttService.sendFraudFeedback(
        alert.id,
        'true_positive', // Default feedback type
      );

      if (success) {
        // Successfully sent - show success dialog first
        _showSuccessDialog(
          'Fraud alert feedback sent successfully',
          onClose: () {
            // Close the alert page and return to previous page after dialog is closed
            controller.dismissAlert();
            controller.returnToPreviousPageAfterFraudAlert();
          },
        );
      } else {
        // Failed to send - show error popup
        _showErrorDialog(
          'Failed to send fraud alert feedback. Please try again.',
        );
      }
    } catch (e) {
      // Error occurred - show error popup
      _showErrorDialog('Error sending fraud alert feedback: $e');
    }
  }

  void _showSuccessDialog(String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success', style: TextStyle(color: Colors.green)),
            ],
          ),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
