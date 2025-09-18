import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/language_controller.dart';

class ProcessingPopup extends StatefulWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final int? autoCloseSeconds;

  const ProcessingPopup({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.autoCloseSeconds,
  });

  @override
  State<ProcessingPopup> createState() => _ProcessingPopupState();
}

class _ProcessingPopupState extends State<ProcessingPopup>
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
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon ?? Icons.hourglass_empty,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title ??
                          (langController.isEnglish
                              ? 'Processing Payment'
                              : 'معالجة الدفع'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated processing icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE31E24).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE31E24),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.credit_card_outlined,
                              size: 40,
                              color: Color(0xFFE31E24),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Processing text
                    Text(
                      widget.message ??
                          (langController.isEnglish
                              ? 'Processing your payment...'
                              : 'جاري معالجة دفعتك...'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      langController.isEnglish
                          ? 'Please wait...'
                          : 'يرجى الانتظار...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Progress indicator
                    const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE31E24),
                      ),
                      backgroundColor: Color(0xFFE5E7EB),
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

class PrintingPopup extends StatefulWidget {
  const PrintingPopup({super.key});

  @override
  State<PrintingPopup> createState() => _PrintingPopupState();
}

class _PrintingPopupState extends State<PrintingPopup> {
  bool _printingCompleted = false;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();

    // Simulate printing process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _printingCompleted = true;
        });

        // Start countdown
        _startCountdown();
      }
    });
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _countdown > 0) {
        setState(() {
          _countdown--;
        });

        if (_countdown > 0) {
          _startCountdown();
        } else {
          // Close popup and return to start
          Get.back();
          final controller = Get.find<AppController>();
          controller.navigateToStart();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.find<LanguageController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _printingCompleted
                      ? [Colors.green, Colors.green.shade700]
                      : [const Color(0xFFE31E24), const Color(0xFFC41E3A)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _printingCompleted ? Icons.check_circle : Icons.print,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _printingCompleted
                          ? (langController.isEnglish
                                ? 'Receipt Printed'
                                : 'تم طباعة الإيصال')
                          : (langController.isEnglish
                                ? 'Printing Receipt'
                                : 'طباعة الإيصال'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Print icon or success icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            (_printingCompleted
                                    ? Colors.green
                                    : const Color(0xFFE31E24))
                                .withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _printingCompleted
                              ? Colors.green
                              : const Color(0xFFE31E24),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        _printingCompleted ? Icons.check : Icons.receipt_long,
                        size: 40,
                        color: _printingCompleted
                            ? Colors.green
                            : const Color(0xFFE31E24),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Status text
                    Text(
                      _printingCompleted
                          ? langController.thankYouForShopping
                          : (langController.isEnglish
                                ? 'Printing Receipt'
                                : 'طباعة الإيصال'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _printingCompleted
                            ? Colors.green
                            : const Color(0xFF374151),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Countdown or processing text
                    Text(
                      _printingCompleted
                          ? '${langController.returningToStart} $_countdown...'
                          : (langController.isEnglish
                                ? 'Please wait...'
                                : 'يرجى الانتظار...'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Progress indicator or countdown
                    if (!_printingCompleted)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE31E24),
                        ),
                      )
                    else
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$_countdown',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
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
    );
  }
}
