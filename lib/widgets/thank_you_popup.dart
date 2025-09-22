import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../controllers/app_controller.dart';
import '../config/popup_config.dart';

class ThankYouPopup extends StatefulWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final int? autoCloseSeconds;

  const ThankYouPopup({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.autoCloseSeconds,
  });

  @override
  State<ThankYouPopup> createState() => _ThankYouPopupState();
}

class _ThankYouPopupState extends State<ThankYouPopup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  bool _isDisposed = false;
  late AppController _appController;

  @override
  void initState() {
    super.initState();

    // Get app controller to monitor substate changes
    _appController = Get.find<AppController>();

    // Initialize pulse animation for the icon
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize scale animation for the entire popup
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _animationController.repeat(reverse: true);
    _scaleController.forward();

    // Monitor substate changes - close when 1008 received or 7006 changes
    _appController.posSubStateStream.listen((substate) {
      if (mounted && !_isDisposed) {
        if (substate == '1008' || substate != '7006') {
          // Close popup when substate 1008 is received or when substate changes from 7006
          // Use Navigator.of(context).pop() instead of Get.back() to avoid overlay issues
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    if (_scaleController.isAnimating) {
      _scaleController.stop();
    }
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find<LanguageController>();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width:
                  MediaQuery.of(context).size.width * PopupConfig.standardWidth,
              height:
                  MediaQuery.of(context).size.height *
                  PopupConfig.standardHeight,
              constraints: const BoxConstraints(
                maxWidth: PopupConfig.maxWidth,
                maxHeight: PopupConfig.maxHeight,
              ),
              decoration: BoxDecoration(
                color: PopupConfig.popupBackgroundColor,
                borderRadius: BorderRadius.circular(PopupConfig.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(PopupConfig.shadowOpacity),
                    blurRadius: PopupConfig.shadowBlurRadius,
                    spreadRadius: PopupConfig.shadowSpreadRadius,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(PopupConfig.headerPadding),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF059669),
                          Color(0xFF047857),
                        ], // Green gradient for success
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(PopupConfig.borderRadius),
                        topRight: Radius.circular(PopupConfig.borderRadius),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.icon ?? Icons.check_circle,
                          color: Colors.white,
                          size: PopupConfig.headerIconSize,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title ??
                                (langController.isEnglish
                                    ? 'Transaction Complete'
                                    : 'اكتملت المعاملة'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: PopupConfig.headerFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(PopupConfig.contentPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated success icon
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF059669,
                                    ).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF059669),
                                      width: 4,
                                    ),
                                  ),
                                  child: Icon(
                                    widget.icon ?? Icons.check_circle,
                                    size: 60,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          // Thank you message
                          Text(
                            langController.isEnglish
                                ? 'Thank You!'
                                : 'شكراً لك!',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 15),

                          // Come again message
                          Text(
                            widget.message ??
                                (langController.isEnglish
                                    ? 'Come Again!'
                                    : 'تعال مرة أخرى!'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // Additional message
                          Text(
                            langController.isEnglish
                                ? 'Your transaction has been completed successfully.\nWe appreciate your business!'
                                : 'تمت معاملتك بنجاح.\nنحن نقدر عملك!',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          // Decorative elements
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDecorativeIcon(
                                Icons.star,
                                const Color(0xFFFFC107),
                              ),
                              const SizedBox(width: 15),
                              _buildDecorativeIcon(
                                Icons.favorite,
                                const Color(0xFFE91E63),
                              ),
                              const SizedBox(width: 15),
                              _buildDecorativeIcon(
                                Icons.thumb_up,
                                const Color(0xFF2196F3),
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
        );
      },
    );
  }

  Widget _buildDecorativeIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
