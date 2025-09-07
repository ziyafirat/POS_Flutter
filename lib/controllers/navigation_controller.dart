import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/app_state.dart';
import '../controllers/app_controller.dart';
import '../views/start_page.dart';
import '../views/item_scan_page.dart';
import '../views/payment_page.dart';
import '../views/processing_page.dart';
import '../views/printing_page.dart';
import '../views/error_page.dart';
import '../views/alert_page.dart';
import '../views/assistant_page.dart';

class NavigationController extends GetxController {
  final AppController _appController = Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    _listenToAppStateChanges();
  }

  void _listenToAppStateChanges() {
    ever(_appController.appState, (AppState state) {
      print('NavigationController: App state changed to ${state.currentScreen}');
      _navigateToScreen(state.currentScreen);
    });
  }

  void _navigateToScreen(AppScreen screen) {
    // Navigation is handled by MainNavigationWrapper in main.dart
    // This method is kept for potential future use or logging
    print('NavigationController: Screen change requested to $screen');
  }
}
