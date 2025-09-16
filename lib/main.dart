import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';
import 'services/scanner_service.dart';
import 'views/start_page.dart';
import 'views/item_scan_page.dart';
import 'views/payment_page.dart';
import 'views/processing_page.dart';
import 'views/printing_page.dart';
import 'views/error_page.dart';
import 'views/alert_page.dart';
import 'views/fraud_alert_page.dart';
import 'views/assistant_page.dart';
import 'views/pos_cashier_page.dart';
import 'views/parameters_page.dart';
import 'widgets/mqtt_status_bar.dart';
import 'widgets/fraud_alert_popup.dart';
import 'models/app_state.dart';
import 'services/usb_printer_service.dart';
import 'services/mqtt_service.dart';

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
    final ScannerService scannerService = Get.find<ScannerService>();
    
    return Obx(() {
      Widget currentPage;
      
      switch (controller.appState.value.currentScreen) {
        case AppScreen.start:
          currentPage = const StartPage();
          break;
        case AppScreen.itemScan:
          currentPage = const ItemScanPage();
          break;
        case AppScreen.payment:
          currentPage = const PaymentPage();
          break;
        case AppScreen.processing:
          currentPage = const ProcessingPage();
          break;
        case AppScreen.printing:
          currentPage = const PrintingPage();
          break;
        case AppScreen.error:
          currentPage = const ErrorPage();
          break;
        case AppScreen.alert:
          currentPage = const AlertPage();
          break;
        case AppScreen.fraudAlert:
          currentPage = const FraudAlertPage();
          break;
        case AppScreen.assistant:
          currentPage = const AssistantPage();
          break;
        case AppScreen.posCashier:
          currentPage = const PosCashierPage();
          break;
        case AppScreen.parameters:
          currentPage = const ParametersPage();
          break;
      }

      return Focus(
        focusNode: scannerService.focusNode,
        autofocus: true,
        child: Stack(
          children: [
            // Main content with status bar
            Column(
              children: [
                // Main content
                Expanded(child: currentPage),
                // MQTT Status Bar (moved to bottom)
                const MqttStatusBar(),
              ],
            ),
            // Fraud alert popup overlay
            const FraudAlertPopup(),
          ],
        ),
      );
    });
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MqttService()); // Register MQTT service first
    Get.put(AppController());
    Get.put(UsbPrinterService());
    // NavigationController removed - navigation is handled by MainNavigationWrapper
  }
}
