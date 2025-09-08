import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';
import 'views/start_page.dart';
import 'views/item_scan_page.dart';
import 'views/payment_page.dart';
import 'views/processing_page.dart';
import 'views/printing_page.dart';
import 'views/error_page.dart';
import 'views/alert_page.dart';
import 'views/assistant_page.dart';
import 'views/pos_cashier_page.dart';
import 'models/app_state.dart';

void main() {
  runApp(const SelfCheckoutApp());
}

class SelfCheckoutApp extends StatelessWidget {
  const SelfCheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Self Checkout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigationWrapper(),
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    
    return Obx(() {
      switch (controller.appState.value.currentScreen) {
        case AppScreen.start:
          return const StartPage();
        case AppScreen.itemScan:
          return const ItemScanPage();
        case AppScreen.payment:
          return const PaymentPage();
        case AppScreen.processing:
          return const ProcessingPage();
        case AppScreen.printing:
          return const PrintingPage();
        case AppScreen.error:
          return const ErrorPage();
        case AppScreen.alert:
          return const AlertPage();
        case AppScreen.assistant:
          return const AssistantPage();
        case AppScreen.posCashier:
          return const PosCashierPage();
      }
    });
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    // NavigationController removed - navigation is handled by MainNavigationWrapper
  }
}
