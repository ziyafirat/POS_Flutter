import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum LampColor { red, green, blue, off }

class LampService extends GetxController {
  final Logger _logger = Logger();

  // Current lamp state
  final Rx<LampColor> _currentColor = LampColor.off.obs;
  final RxBool _isBlinking = false.obs;

  // Blinking timer
  Timer? _blinkTimer;
  bool _blinkState = false;

  // Getters
  LampColor get currentColor => _currentColor.value;
  bool get isBlinking => _isBlinking.value;

  /// Set lamp to solid color
  void setColor(LampColor color) {
    _stopBlinking();
    _currentColor.value = color;
    _logger.i('💡 [LAMP] Set to ${color.name}');
    print('💡 [LAMP] Set to ${color.name}');

    // Here you would send the actual lamp control command
    _sendLampCommand(color, false);
  }

  /// Start blinking with specified color
  void startBlinking(LampColor color) {
    _stopBlinking();
    _currentColor.value = color;
    _isBlinking.value = true;
    _blinkState = true;

    _logger.i('💡 [LAMP] Starting blinking ${color.name}');
    print('💡 [LAMP] Starting blinking ${color.name}');

    // Blink every 1 second
    _blinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _blinkState = !_blinkState;
      _sendLampCommand(_blinkState ? color : LampColor.off, true);
    });
  }

  /// Stop blinking
  void _stopBlinking() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _isBlinking.value = false;
  }

  /// Turn off lamp
  void turnOff() {
    _stopBlinking();
    _currentColor.value = LampColor.off;
    _logger.i('💡 [LAMP] Turned off');
    print('💡 [LAMP] Turned off');
    _sendLampCommand(LampColor.off, false);
  }

  /// Send actual lamp control command (placeholder for hardware integration)
  void _sendLampCommand(LampColor color, bool isBlinking) {
    // This is where you would send the actual command to the lamp hardware
    // For now, just log the command
    final status = isBlinking ? 'blinking' : 'solid';
    _logger.d('💡 [LAMP] Command: $status ${color.name}');

    // Example: Send command to lamp controller via serial/USB/network
    // lampController.setColor(color, isBlinking);
  }

  /// Get current lamp status for debugging
  Map<String, dynamic> getLampStatus() {
    return {
      'currentColor': _currentColor.value.name,
      'isBlinking': _isBlinking.value,
      'blinkTimerActive': _blinkTimer?.isActive ?? false,
    };
  }

  @override
  void onClose() {
    _stopBlinking();
    super.onClose();
  }
}
