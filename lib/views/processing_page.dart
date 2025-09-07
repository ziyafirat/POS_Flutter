import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Processing Animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1 + (_animation.value * 0.3)),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3 + (_animation.value * 0.4)),
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.payment,
                    size: 60,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            
            // Processing Text
            const Text(
              'Processing Payment',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Please wait while we process your payment...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Progress Indicator
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            
            // Status Text
            Obx(() => Text(
              'Status: ${controller.appState.value.grpcStatus.name}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )),
            const SizedBox(height: 60),
            
            // Cancel Button (if needed)
            TextButton(
              onPressed: () {
                controller.navigateToPayment();
              },
              child: const Text(
                'Cancel Payment',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
