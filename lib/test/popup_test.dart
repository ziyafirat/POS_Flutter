import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/app_controller.dart';
import '../models/app_state.dart';

/// Test class for popup behavior with item scan background
class PopupTest {
  static final Logger _logger = Logger();

  /// Test the popup flow while keeping item scan page in background
  static Future<void> testPopupFlow() async {
    _logger.i('🧪 STARTING POPUP FLOW TEST');
    print('🧪 STARTING POPUP FLOW TEST');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Ensure we're on item scan page
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print('📱 Current screen: ${controller.appState.value.currentScreen}');

    if (controller.appState.value.currentScreen == AppScreen.itemScan) {
      print('✅ Successfully on item scan page');

      // Test 1: Payment popup
      print('\n📋 Test 1: Payment popup');
      controller.navigateToPayment();
      await Future.delayed(const Duration(seconds: 2));

      // Test 2: Processing popup (should close payment and show processing)
      print('\n📋 Test 2: Processing popup');
      controller.navigateToProcessing();
      await Future.delayed(const Duration(seconds: 2));

      // Test 3: Printing popup (should close processing and show printing)
      print('\n📋 Test 3: Printing popup');
      controller.navigateToPrinting();
      await Future.delayed(const Duration(seconds: 3));

      // Test 4: Error handling (should close all popups and show error page)
      print('\n📋 Test 4: Error handling');
      controller.navigateToError(
        errorMessage: 'Test error - all popups should close',
      );
      await Future.delayed(const Duration(seconds: 2));

      // Return to item scan for next test
      controller.navigateToItemScan();

      print('\n✅ POPUP FLOW TEST COMPLETED');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } else {
      print('❌ Failed to navigate to item scan page');
      print('Current screen: ${controller.appState.value.currentScreen}');
    }
  }

  /// Test error handling specifically
  static Future<void> testErrorHandling() async {
    _logger.i('🧪 TESTING ERROR HANDLING');
    print('🧪 TESTING ERROR HANDLING');

    final controller = Get.find<AppController>();

    // Go to item scan and open a payment popup
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    controller.navigateToPayment();
    await Future.delayed(const Duration(seconds: 1));

    print('📱 Payment popup should be open');
    print('📱 Dialog open status: ${Get.isDialogOpen}');

    // Trigger error - should close popup and show error page
    controller.navigateToError(errorMessage: 'Test error during payment');
    await Future.delayed(const Duration(milliseconds: 500));

    print('📱 After error - Dialog open status: ${Get.isDialogOpen}');
    print('📱 Current screen: ${controller.appState.value.currentScreen}');

    if (controller.appState.value.currentScreen == AppScreen.error &&
        Get.isDialogOpen == false) {
      print('✅ Error handling working correctly!');
    } else {
      print('❌ Error handling needs adjustment');
    }
  }

  /// Test terminal closed functionality
  static Future<void> testTerminalClosed() async {
    _logger.i('🧪 TESTING TERMINAL CLOSED FUNCTIONALITY');
    print('🧪 TESTING TERMINAL CLOSED FUNCTIONALITY');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Test substate 11043
    print('\n📋 Test 1: Substate 11043 (Terminal Closed)');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Current screen before: ${controller.appState.value.currentScreen}',
    );
    controller.updatePosSubState('11043');
    await Future.delayed(const Duration(milliseconds: 500));
    print(
      '📱 Current screen after 11043: ${controller.appState.value.currentScreen}',
    );

    // Test substate 11042
    print('\n📋 Test 2: Substate 11042 (Terminal Closed)');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Current screen before: ${controller.appState.value.currentScreen}',
    );
    controller.updatePosSubState('11042');
    await Future.delayed(const Duration(milliseconds: 500));
    print(
      '📱 Current screen after 11042: ${controller.appState.value.currentScreen}',
    );

    // Test normal substate (should not trigger terminal closed)
    print('\n📋 Test 3: Normal substate (should not trigger terminal closed)');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Current screen before: ${controller.appState.value.currentScreen}',
    );
    controller.updatePosSubState('1001');
    await Future.delayed(const Duration(milliseconds: 500));
    print(
      '📱 Current screen after 1001: ${controller.appState.value.currentScreen}',
    );

    print('\n✅ TERMINAL CLOSED TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Test special barcode functionality
  static Future<void> testSpecialBarcode() async {
    _logger.i('🧪 TESTING SPECIAL BARCODE FUNCTIONALITY');
    print('🧪 TESTING SPECIAL BARCODE FUNCTIONALITY');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Test special POS Cashier barcode
    print('\n📋 Test: Special barcode 1111111111116 (POS Cashier)');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Current screen before scan: ${controller.appState.value.currentScreen}',
    );

    // Simulate scanning the special barcode
    controller.simulateBarcodeScanning('1111111111116');
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Current screen after special barcode: ${controller.appState.value.currentScreen}',
    );

    if (controller.appState.value.currentScreen == AppScreen.posCashier) {
      print('✅ Special barcode successfully triggered POS Cashier mode!');
    } else {
      print('❌ Special barcode did not trigger POS Cashier mode');
    }

    print('\n✅ SPECIAL BARCODE TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Test POS override mode functionality
  static Future<void> testPosOverrideMode() async {
    _logger.i('🧪 TESTING POS OVERRIDE MODE');
    print('🧪 TESTING POS OVERRIDE MODE');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Step 1: Trigger terminal closed
    print('\n📋 Step 1: Trigger terminal closed');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));
    controller.simulateTerminalClosed('11043');
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Screen after terminal closed: ${controller.appState.value.currentScreen}',
    );

    // Step 2: Navigate to POS Cashier from terminal closed
    print('\n📋 Step 2: Navigate to POS Cashier from terminal closed');
    controller.navigateToPosCashier();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Screen after POS navigation: ${controller.appState.value.currentScreen}',
    );
    print(
      '🔓 POS Override mode active: ${controller.isPosOverrideModeActive()}',
    );

    // Step 3: Try to trigger terminal closed again (should be ignored)
    print('\n📋 Step 3: Try terminal closed again (should be ignored)');
    controller.simulateTerminalClosed('11042');
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '📱 Screen after second terminal closed: ${controller.appState.value.currentScreen}',
    );

    if (controller.appState.value.currentScreen == AppScreen.posCashier) {
      print('✅ POS Override mode working correctly - stayed in POS Cashier!');
    } else {
      print('❌ POS Override mode failed - returned to terminal closed');
    }

    // Step 4: Return to start (should clear override mode)
    print('\n📋 Step 4: Return to start (should clear override mode)');
    controller.navigateToStart();
    await Future.delayed(const Duration(milliseconds: 500));

    print(
      '🔓 POS Override mode after returning to start: ${controller.isPosOverrideModeActive()}',
    );

    print('\n✅ POS OVERRIDE MODE TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Test substate-driven popup navigation flow
  static Future<void> testSubstatePopupFlow() async {
    _logger.i('🧪 TESTING SUBSTATE POPUP FLOW');
    print('🧪 TESTING SUBSTATE POPUP FLOW');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Start on item scan page
    print('\n📋 Setup: Navigate to item scan page');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print('📱 Current screen: ${controller.appState.value.currentScreen}');

    if (controller.appState.value.currentScreen == AppScreen.itemScan) {
      print('✅ Successfully on item scan page');

      // Test 1: Substate 1001 (Stay on Item Scan - No Popup)
      print('\n📋 Test 1: Substate 1001 → Stay on item scan page (no popup)');
      controller.updatePosSubState('1001');
      await Future.delayed(const Duration(seconds: 1));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 2: Substate 1010 (Payment Popup)
      print(
        '\n📋 Test 2: Substate 1010 → Payment Popup (with Cash/Card options)',
      );
      controller.updatePosSubState('1010');
      await Future.delayed(const Duration(seconds: 2));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 3: Substate 1010 again (Should not open duplicate)
      print('\n📋 Test 3: Substate 1010 again → Should not open duplicate');
      controller.updatePosSubState('1010');
      await Future.delayed(const Duration(seconds: 1));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 4: Substate 7006 (Printing Popup)
      print('\n📋 Test 4: Substate 7006 → Printing Receipt Popup');
      controller.updatePosSubState('7006');
      await Future.delayed(const Duration(seconds: 2));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 5: Substate 1002 without 1010 (Stay on Item Scan)
      print(
        '\n📋 Test 5: Substate 1002 without previous 1010 → Stay on item scan page',
      );
      controller.updatePosSubState('1002');
      await Future.delayed(const Duration(seconds: 1));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 6: Substate 1010 then 1002 (Show Processing Popup)
      print(
        '\n📋 Test 6: Substate 1010 → 1002 → Payment then Processing Popup',
      );
      controller.updatePosSubState('1010');
      await Future.delayed(const Duration(seconds: 1));
      controller.updatePosSubState('1002');
      await Future.delayed(const Duration(seconds: 2));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      // Test 7: Substate 1008 (Complete - Return to Start)
      print('\n📋 Test 7: Substate 1008 → Close popups and return to start');
      controller.updatePosSubState('1008');
      await Future.delayed(const Duration(milliseconds: 500));
      print('📱 Dialog open: ${Get.isDialogOpen}');
      print('📱 Screen: ${controller.appState.value.currentScreen}');

      if (controller.appState.value.currentScreen == AppScreen.start &&
          Get.isDialogOpen == false) {
        print('✅ Substate 1008 successfully completed transaction flow!');
      } else {
        print('❌ Substate 1008 did not complete transaction properly');
        print('Expected: start page with no dialogs');
        print(
          'Actual: ${controller.appState.value.currentScreen}, dialogs: ${Get.isDialogOpen}',
        );
      }
    } else {
      print('❌ Failed to navigate to item scan page');
      print('Current screen: ${controller.appState.value.currentScreen}');
    }

    print('\n✅ SUBSTATE POPUP FLOW TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Test complete checkout flow with substates
  static Future<void> testCompleteCheckoutFlow() async {
    _logger.i('🧪 TESTING COMPLETE CHECKOUT FLOW');
    print('🧪 TESTING COMPLETE CHECKOUT FLOW');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Simulate complete checkout process
    print('\n📋 Step 1: Start on item scan page');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print('\n📋 Step 2: Simulate payment initiation (substate 1010)');
    controller.updatePosSubState('1010');
    await Future.delayed(const Duration(seconds: 1));

    print('\n📋 Step 3: Simulate processing after payment (substate 1002)');
    controller.updatePosSubState('1002');
    await Future.delayed(const Duration(seconds: 1));

    print('\n📋 Step 4: Simulate printing (substate 7006)');
    controller.updatePosSubState('7006');
    await Future.delayed(const Duration(seconds: 2));

    print('\n📋 Step 5: Complete transaction (substate 1008)');
    controller.updatePosSubState('1008');
    await Future.delayed(const Duration(milliseconds: 500));

    // Verify final state
    final finalScreen = controller.appState.value.currentScreen;
    final hasDialogs = Get.isDialogOpen;

    print('\n📊 FINAL RESULTS:');
    print('📱 Final screen: $finalScreen');
    print('📱 Open dialogs: $hasDialogs');

    if (finalScreen == AppScreen.start && hasDialogs == false) {
      print('✅ Complete checkout flow working perfectly!');
    } else {
      print('❌ Checkout flow needs adjustment');
    }

    print('\n✅ COMPLETE CHECKOUT FLOW TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Test startup behavior with substate 1010
  static Future<void> testStartupWith1010() async {
    _logger.i('🚀 TESTING STARTUP WITH SUBSTATE 1010');
    print('🚀 TESTING STARTUP WITH SUBSTATE 1010');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final controller = Get.find<AppController>();

    // Simulate app startup with substate 1010 already set
    print('\n📋 Step 1: Simulate startup - set substate 1010');
    controller.updatePosSubState('1010');

    print('\n📋 Step 2: Navigate to item scan page (as startup would do)');
    controller.navigateToItemScan();
    await Future.delayed(const Duration(milliseconds: 500));

    print('\n📋 Step 3: Show payment popup (as startup would do)');
    controller.testStartupSubstateHandling('1010');
    await Future.delayed(const Duration(seconds: 2));

    // Verify state
    final currentScreen = controller.appState.value.currentScreen;
    final hasDialog = Get.isDialogOpen == true;

    print('\n📊 FINAL STATE:');
    print('📱 Screen: $currentScreen');
    print('💬 Dialog open: $hasDialog');

    if (currentScreen == AppScreen.itemScan && hasDialog) {
      print('✅ Startup with 1010 test PASSED');
      print('📱 State: Item scan page with payment popup open');
    } else {
      print('❌ Startup with 1010 test FAILED');
    }

    // Clean up
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    print('\n✅ STARTUP 1010 TEST COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
