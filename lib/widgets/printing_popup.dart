import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../config/popup_config.dart';

class PrintingPopup extends StatefulWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final int? autoCloseSeconds;

  const PrintingPopup({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.autoCloseSeconds,
  });

  @override
  State<PrintingPopup> createState() => _PrintingPopupState();
}

class _PrintingPopupState extends State<PrintingPopup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize pulse animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation
    _animationController.repeat(reverse: true);

    // Auto-close after specified seconds if provided
    if (widget.autoCloseSeconds != null && widget.autoCloseSeconds! > 0) {
      Future.delayed(Duration(seconds: widget.autoCloseSeconds!), () {
        if (mounted && Get.isDialogOpen == true && !_isDisposed) {
          Get.back();
        }
      });
    }
    // Note: No default auto-close behavior - popup management is handled by AppController
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find<LanguageController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * PopupConfig.standardWidth,
        height: MediaQuery.of(context).size.height * PopupConfig.standardHeight,
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
                  colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(PopupConfig.borderRadius),
                  topRight: Radius.circular(PopupConfig.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon ?? Icons.print,
                    color: Colors.white,
                    size: PopupConfig.headerIconSize,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title ??
                          (langController.isEnglish
                              ? 'Printing Receipt'
                              : 'طباعة الإيصال'),
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
                    // Animated printer icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE31E24).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.icon ?? Icons.print,
                              size: 60,
                              color: const Color(0xFFE31E24),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Title
                    Text(
                      widget.title ??
                          (langController.isEnglish
                              ? 'Printing Receipt'
                              : 'طباعة الإيصال'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    // Message
                    Text(
                      widget.message ??
                          (langController.isEnglish
                              ? 'Please wait while we print your receipt...'
                              : 'يرجى الانتظار بينما نقوم بطباعة إيصالك...'),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Progress indicator
                    const LinearProgressIndicator(
                      backgroundColor: Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE31E24),
                      ),
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
}
