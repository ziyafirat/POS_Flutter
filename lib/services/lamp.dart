library;

import 'dart:io';

import 'package:flutter/material.dart';
// Optional Linux GPIO character device access
import 'package:flutter_gpiod/flutter_gpiod.dart' show FlutterGpiod, GpioLine;
import 'package:get/get.dart';

enum LampColor {
  off,
  red,
  green,
  blue,
  yellow,
  purple,
  cyan,
  white,
  redAlert,
  greenAlert,
  blueAlert,
  yellowAlert,
  purpleAlert,
  cyanAlert,
  whiteAlert,
  policeAlert,
}

class LampCommandLogEntry {
  final DateTime timestamp;
  final List<int> channels;
  final bool value;
  final bool simulated;
  final String message;
  final String? rawCommand;
  final int? exitCode;
  final String? stdoutStr;
  final String? stderrStr;

  LampCommandLogEntry({
    required this.timestamp,
    required this.channels,
    required this.value,
    required this.simulated,
    required this.message,
    this.rawCommand,
    this.exitCode,
    this.stdoutStr,
    this.stderrStr,
  });
}

/// LampController hardware abstraction
///
/// Mode precedence for writes (highest first):
///  1. Simulation (if forceSimulation == true or platform unsupported)
///  2. Linux gpiod direct (useGpiod == true)
///  3. Windows Serial mask (windowsSerialPort non-empty & enableWindowsGpio == false)
///  4. Windows GPIO via gpiom utility (enableWindowsGpio == true)
///  5. *nix sysfs echo paths (default Linux/Android fallback)
///
/// Polarity: if activeLow true then logical ON drives line LOW. All pathways
/// mirror this logic consistently.
class LampController extends GetxController {
  static const int _maxLogEntries = 100;
  // Process.run indirection (makes testing / mocking easier)
  static Future<ProcessResult> Function(
    String exe,
    List<String> args, {
    bool runInShell,
  }) processRun = (exe, args, {bool runInShell = false}) =>
      Process.run(exe, args, runInShell: runInShell);
  final RxBool isInitialized = false.obs;
  final RxBool isAlertActive = false.obs;
  final Rx<LampColor> currentColor = LampColor.off.obs;
  // UI brightness simulation factor (0=dark/off, 1=full). Currently only
  // affects UI representation; hardware brightness not supported for GPIO
  // lines (digital). Persisted via LampSettings.defaultBrightness.
  final RxDouble brightness = 1.0.obs;
  final Map<int, bool> _channelState = {1: false, 2: false, 3: false};
  final Map<int, GpioLine> _gpiodLines = {}; // channel -> requested line
  int _patternGeneration = 0;

  bool forceSimulation;
  String? _simulationReason; // diagnostic capture of why simulation forced
  bool _ledTestRunning = false; // guard for full cycle test

  /// Reactive settings so UI can reflect runtime changes.
  final Rx<LampSettings> settings;

  /// Recent command log entries (latest first) for debugging.
  final RxList<LampCommandLogEntry> commandLog = <LampCommandLogEntry>[].obs;

  LampController({this.forceSimulation = false, LampSettings? initialSettings})
      : settings = (initialSettings ?? LampSettings.defaults).obs {
    // Initialize brightness from settings (range clamp for safety)
    final b = settings.value.defaultBrightness;
    brightness.value = b.clamp(0.0, 1.0);
  }

  /// Expose current effective hardware mode for UI/debug.
  String get currentHardwareMode {
    if (_isSimulationPlatform) return 'SIM';
    if (Platform.isLinux && settings.value.useGpiod) return 'GPIOD';
    if (Platform.isWindows &&
        settings.value.windowsSerialPort != null &&
        settings.value.windowsSerialPort!.isNotEmpty &&
        !settings.value.enableWindowsGpio) {
      return 'SERIAL';
    }
    if (Platform.isWindows && settings.value.enableWindowsGpio) {
      return 'GPIO_WIN';
    }
    return 'GPIO_SYSFS';
  }

  String? get simulationReason => _simulationReason;

  bool get _isGpioPlatform =>
      Platform.isAndroid ||
      Platform.isLinux ||
      (Platform.isWindows &&
          (settings.value.enableWindowsGpio ||
              (settings.value.windowsSerialPort != null &&
                  settings.value.windowsSerialPort!.isNotEmpty)));
  bool get _isSimulationPlatform => forceSimulation || !(_isGpioPlatform);
  Future<void> activateColor(LampColor color) async {
    if (!color.name.endsWith('Alert') && color != LampColor.policeAlert) {
      await stopAlert();
    }
    switch (color) {
      case LampColor.off:
        currentColor.value = LampColor.off;
        await setLightStatus([1, 2, 3], false);
        break;
      case LampColor.red:
      case LampColor.green:
      case LampColor.blue:
      case LampColor.yellow:
      case LampColor.purple:
      case LampColor.cyan:
      case LampColor.white:
        currentColor.value = color;
        await setLightStatus(color.channels, true);
        break;
      case LampColor.redAlert:
      case LampColor.greenAlert:
      case LampColor.blueAlert:
      case LampColor.yellowAlert:
      case LampColor.purpleAlert:
      case LampColor.cyanAlert:
      case LampColor.whiteAlert:
        currentColor.value = color;
        await _runPattern(LightPattern(channels: color.channels));
        break;
      case LampColor.policeAlert:
        currentColor.value = color;
        await _runPattern(
          const LightPattern(
            channels: [1, 3],
            onDuration: Duration(milliseconds: 75),
            offDuration: Duration(milliseconds: 150),
          ),
        );
        break;
    }
  }

  /// Read current channel logical state (true means requested ON).
  bool channelIsOn(int channel) => _channelState[channel] == true;

  /// Clear the in-memory command log (UI helper)
  void clearLog() => commandLog.clear();

  /// If in Windows serial mask mode, compute current mask (after last state update).
  int? currentSerialMask() {
    if (!(Platform.isWindows &&
        settings.value.windowsSerialPort != null &&
        settings.value.windowsSerialPort!.isNotEmpty &&
        !settings.value.enableWindowsGpio)) {
      return null;
    }
    return _computeWindowsMask(settings.value.activeLow);
  }

  /// Snapshot of gpiod lines (channel -> line name / requested state).
  Map<String, dynamic>? gpiodSnapshot() {
    if (!(Platform.isLinux && settings.value.useGpiod)) return null;
    final map = <String, dynamic>{
      'chipIndex': settings.value.gpiodChipIndex,
      'lines': <Map<String, dynamic>>[],
    };
    _gpiodLines.forEach((ch, line) {
      map['lines'].add({
        'channel': ch,
        'name': line.info.name,
        'requestedOn': _channelState[ch] == true,
      });
    });
    return map;
  }

  Future<String> init() async {
    try {
      if (_isGpioPlatform) {
        // Android permission self-test for sysfs writes before we proceed.
        await _androidSysfsSelfTest();
        if (Platform.isLinux && settings.value.useGpiod) {
          await _initGpiod();
        }
        await setLightStatus([1, 2, 3], false);
      }
      isInitialized.value = true;
      return 'Lamp initialized';
    } catch (e) {
      return 'Init error: $e';
    }
  }

  @override
  void onClose() {
    _releaseGpiod();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _loadPersistedSettings().then((_) => _initializeLamp());
  }

  /// Re-run the Android sysfs self-test (clears simulationReason first). Only meaningful on Android.
  Future<void> rerunAndroidSelfTest() async {
    if (!Platform.isAndroid) return;
    _simulationReason = null;
    // If user had auto-forced simulation previously, allow attempt again.
    // Do not clear user toggled forceSimulation, only auto one.
    // We'll temporarily clear forceSimulation if reason was auto permission.
    final wasAuto = forceSimulation && simulationReason != null;
    if (wasAuto) {
      forceSimulation = false;
    }
    await _androidSysfsSelfTest();
  }

  /// Run a full LED cycle test (sequential colors) for visual verification.
  Future<String> runFullLedCycleTest({
    Duration stepDelay = const Duration(milliseconds: 300),
  }) async {
    if (_ledTestRunning) return 'LED test already running';
    _ledTestRunning = true;
    final sequence = <Map<String, dynamic>>[
      {
        'label': 'Red',
        'channels': [1],
      },
      {
        'label': 'Green',
        'channels': [2],
      },
      {
        'label': 'Blue',
        'channels': [3],
      },
      {
        'label': 'Yellow',
        'channels': [1, 2],
      },
      {
        'label': 'Cyan',
        'channels': [2, 3],
      },
      {
        'label': 'Purple',
        'channels': [1, 3],
      },
      {
        'label': 'White',
        'channels': [1, 2, 3],
      },
      {'label': 'Off', 'channels': <int>[]},
    ];
    try {
      for (final step in sequence) {
        final ch = (step['channels'] as List<int>);
        if (ch.isEmpty) {
          await setLightStatus([1, 2, 3], false);
        } else {
          await setLightStatus(ch, true);
        }
        await Future.delayed(stepDelay);
      }
      final msg = 'LED cycle test complete';
      _logCommand(
        msg,
        channels: const [],
        value: false,
        simulated: _isSimulationPlatform,
      );
      return msg;
    } finally {
      _ledTestRunning = false;
    }
  }

  /// Run an ad-hoc shell command for testing GPIO; logs a command entry.
  Future<LampCommandLogEntry> runRawShell(String cmd) async {
    final result = await _executeCommand(cmd);
    final msg = '(RAW $currentHardwareMode) "$cmd" exit=${result.exitCode}';
    _logCommand(
      msg,
      channels: const [],
      value: false,
      simulated: _isSimulationPlatform,
      rawCommand: cmd,
      exitCode: result.exitCode,
      stdoutStr: result.stdout.toString(),
      stderrStr: result.stderr.toString(),
    );
    return commandLog.first;
  }

  /// Scan /sys/class/leds for available LED class devices.
  Future<List<String>> scanSysClassLeds() async {
    if (!(Platform.isAndroid || Platform.isLinux)) return const [];
    try {
      final res = await processRun(
          'sh',
          [
            '-c',
            'ls -1 /sys/class/leds 2>/dev/null',
          ],
          runInShell: true);
      final list = res.stdout
          .toString()
          .trim()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .map((e) => e.trim())
          .toList();
      _logCommand(
        'LED class scan: ${list.join(', ')}',
        channels: const [],
        value: false,
        simulated: _isSimulationPlatform,
      );
      return list;
    } catch (e) {
      _logCommand(
        'LED class scan failed: $e',
        channels: const [],
        value: false,
        simulated: _isSimulationPlatform,
        stderrStr: e.toString(),
      );
      return const [];
    }
  }

  /// Update UI brightness simulation value. Optionally persist by updating
  /// settings.defaultBrightness (persist=true).
  void setBrightness(double value, {bool persist = false}) {
    final v = value.clamp(0.0, 1.0);
    if ((brightness.value - v).abs() < 0.0001) return; // no-op if unchanged
    brightness.value = v;
    if (persist) {
      // Update settings with new defaultBrightness and persist.
      settings.value = settings.value.copyWith(defaultBrightness: v);
      _persistSettings();
    }
  }

  /// Set a single channel state without affecting others (test utility).
  Future<void> setChannel(int channel, bool on) async {
    _channelState[channel] = on;
    final active =
        _channelState.entries.where((e) => e.value).map((e) => e.key).toList();
    if (active.isEmpty) {
      await setLightStatus([1, 2, 3], false);
    } else {
      await setLightStatus(active, true);
    }
  }

  /// Enable/disable simulation mode at runtime (e.g., for Windows testing).
  void setForceSimulation(bool value) {
    forceSimulation = value;
    _persistSettings();
  }

  Future<String> setLightStatus(
    List<int> channels,
    bool value, {
    Duration? delay,
  }) async {
    _applyChannelState(channels, value);
    final desc =
        channels.isEmpty ? 'None' : channels.map(_getColorName).join(', ');
    if (_isSimulationPlatform) {
      if (delay != null) await Future.delayed(delay);
      final msg = '(SIM) $desc => ${value ? 'ON' : 'OFF'}';
      _logCommand(msg, simulated: true, channels: channels, value: value);
      return msg;
    }
    // gpiod direct mode (Linux)
    if (Platform.isLinux && settings.value.useGpiod) {
      await _applyGpiod();
      if (delay != null) await Future.delayed(delay);
      final msg = 'GPIOD $desc => ${value ? 'ON' : 'OFF'}';
      _logCommand(
        msg,
        simulated: false,
        channels: channels,
        value: value,
        rawCommand: 'gpiod-lines:${settings.value.gpiodLineNames}',
      );
      return msg;
    }
    // Determine if we're in Windows direct-serial mask mode.
    final bool serialMode = Platform.isWindows &&
        settings.value.windowsSerialPort != null &&
        settings.value.windowsSerialPort!.isNotEmpty;

    ProcessResult result;
    String rawCommand;
    bool isSerial = false;
    if (serialMode) {
      isSerial = true;
      result = await _executeSerialMask();
      rawCommand = result.stdout is String &&
              (result.stdout as String).startsWith('SERIAL:')
          ? (result.stdout as String)
          : 'SERIAL ${settings.value.windowsSerialPort} mask=${_computeWindowsMask(settings.value.activeLow)}';
    } else {
      final cmd = _buildGpioCommand();
      rawCommand = cmd;
      result = await _executeCommand(cmd);
    }
    if (delay != null) await Future.delayed(delay);
    final msg =
        '${isSerial ? 'SERIAL' : 'GPIO'} $desc => ${value ? 'ON' : 'OFF'} exit=${result.exitCode}';
    _logCommand(
      msg,
      simulated: false,
      channels: channels,
      value: value,
      rawCommand: rawCommand,
      exitCode: result.exitCode,
      stdoutStr: result.stdout.toString(),
      stderrStr: result.stderr.toString(),
    );
    return msg;
  }

  Future<void> stopAlert() async {
    isAlertActive.value = false;
    _patternGeneration++;
  }

  /// Update runtime settings; will affect subsequent GPIO writes & status.
  void updateSettings(LampSettings newSettings) {
    final old = settings.value;
    final gpiodConfigChanged = old.useGpiod != newSettings.useGpiod ||
        old.gpiodLineNames != newSettings.gpiodLineNames;
    settings.value = newSettings;
    if (gpiodConfigChanged && Platform.isLinux) {
      _releaseGpiod();
      if (newSettings.useGpiod) {
        _initGpiod();
      }
    }
    _applyChannelState(currentColor.value.channels, true);
    _persistSettings();
  }

  /// Validate configured GPIO paths (existence & basic write permission attempt).
  Future<String> validateConfiguredPaths() async {
    final b = StringBuffer('GPIO Path Validation\n');
    if (settings.value.gpioPaths.isEmpty) {
      final msg = 'No gpioPaths configured';
      b.writeln(msg);
      _logCommand(
        msg,
        channels: const [],
        value: false,
        simulated: _isSimulationPlatform,
      );
      return b.toString();
    }
    for (final entry in settings.value.gpioPaths.entries) {
      final path = entry.value;
      final ch = entry.key;
      if (!path.startsWith('/')) {
        b.writeln('Ch $ch: $path (SKIPPED non-unix path)');
        continue;
      }
      try {
        final cmd =
            '([ -e "$path" ] && echo EXISTS || echo MISSING); ([ -w "$path" ] && echo WRITABLE || echo NOT_WRITABLE)';
        final res = await processRun('sh', ['-c', cmd], runInShell: true);
        final split = res.stdout.toString().trim().split(RegExp(r'\s+'));
        String existence = split.isNotEmpty ? split[0] : 'UNKNOWN';
        String writable = split.length > 1 ? split[1] : 'UNKNOWN';
        // Try a harmless permission probe (0 write) redirecting stderr capture.
        final probe = await processRun(
            'sh',
            [
              '-c',
              'echo 0 > "$path" 2>&1 || true',
            ],
            runInShell: true);
        final probeErr = probe.stderr.toString();
        final denied = probeErr.contains('Permission denied');
        b.writeln(
          'Ch $ch: $path => $existence, $writable, writeTest=${denied ? 'DENIED' : 'OK'}',
        );
      } catch (e) {
        b.writeln('Ch $ch: $path => ERROR $e');
      }
    }
    final summary = b.toString();
    _logCommand(
      'Path validation run',
      channels: const [],
      value: false,
      simulated: _isSimulationPlatform,
      stdoutStr: summary,
    );
    return summary;
  }

  Future<void> _androidSysfsSelfTest() async {
    if (!Platform.isAndroid) return;
    if (forceSimulation) return; // user forced
    if (settings.value.useGpiod) return; // different backend
    if (settings.value.androidUseSu) return; // will retry with su
    if (settings.value.gpioPaths.isEmpty) return;
    final path = settings.value.gpioPaths.values.first;
    if (!path.startsWith('/sys')) return;
    try {
      final cmd = 'echo 0 > $path';
      final result = await processRun('sh', ['-c', cmd], runInShell: true);
      final stderrStr = result.stderr?.toString() ?? '';
      if (result.exitCode != 0 && stderrStr.contains('Permission denied')) {
        forceSimulation = true;
        _simulationReason = 'Android sysfs permission denied';
        _logCommand(
          'Auto-switched to simulation: sysfs permission denied',
          channels: const [],
          value: false,
          simulated: true,
          stderrStr: stderrStr,
        );
        await _persistSettings();
      }
    } catch (_) {
      // Ignore unexpected errors; only act on explicit permission denied.
    }
  }

  void _applyChannelState(List<int> channels, bool value) {
    for (final c in settings.value.gpioPaths.keys) {
      _channelState[c] = channels.contains(c) && value;
    }
  }

  Future<void> _applyGpiod() async {
    final activeLow = settings.value.activeLow;
    _gpiodLines.forEach((ch, line) {
      final on = _channelState[ch] == true;
      final driveHigh = on ? !activeLow : activeLow; // replicate logic
      try {
        line.setValue(driveHigh);
      } catch (_) {}
    });
  }

  String _buildGpioCommand() {
    final s = settings.value;
    // Windows experimental GPIOM utility path
    if (Platform.isWindows && s.enableWindowsGpio) {
      // Prefer explicit gpioPinNumbers mapping for physical pin, fallback to logical channel.
      final cmds = <String>[];
      for (final ch in s.gpioPaths.keys) {
        final on = _channelState[ch] == true; // logical desired LED on?
        final writeVal = on
            ? (s.activeLow ? 0 : 1)
            : (s.activeLow ? 1 : 0); // 1 = drive high, 0 = drive low
        final pin = s.gpioPinNumbers?[ch] ?? ch; // physical pin or channel id
        final level = writeVal == 1 ? 'H' : 'L';
        // Use bundled gpiom utility (must be in PATH or same dir): gpiom <pin> <H|L>
        cmds.add('gpiom $pin $level');
      }
      return cmds.join(' && ');
    }
    // Default *nix style echo to sysfs paths.
    return s.gpioPaths.keys.map((ch) {
      final on = _channelState[ch] == true;
      final writeVal = on ? (s.activeLow ? 0 : 1) : (s.activeLow ? 1 : 0);
      return 'echo $writeVal > ${s.gpioPaths[ch]}';
    }).join(' && ');
  }

  String _canonicalComPort(String port) {
    final upper = port.toUpperCase();
    final number = int.tryParse(upper.replaceFirst('COM', ''));
    if (number != null && number >= 10) {
      return r'\\.\' + upper; // required for COM10+
    }
    return upper;
  }

  // --- Windows Serial Port Direct Mask Mode Helpers ---
  int _computeWindowsMask(bool activeLow) {
    int mask = 0;
    // Map channel 1->bit0, 2->bit1, 3->bit2
    _channelState.forEach((channel, isOn) {
      final driveHigh =
          isOn ? !activeLow : activeLow; // replicate writeVal logic
      if (driveHigh) {
        final bit = channel - 1;
        if (bit >= 0) mask |= (1 << bit);
      }
    });
    return mask;
  }

  Future<ProcessResult> _executeCommand(String cmd) async {
    if (_isSimulationPlatform) {
      return ProcessResult(0, 0, 'SIMULATED: $cmd', '');
    }
    if (Platform.isWindows && settings.value.enableWindowsGpio) {
      // Run the composed GPIO batch command via cmd.
      return await processRun('cmd', ['/C', cmd], runInShell: true);
    }
    if (Platform.isAndroid) {
      var result = await processRun('sh', ['-c', cmd], runInShell: true);
      final stderrStr = result.stderr?.toString() ?? '';
      if (settings.value.androidUseSu &&
          (stderrStr.contains('Permission denied') || result.exitCode == 13)) {
        // Try with root privileges
        final suCmd = "su -c \"$cmd\"";
        final suResult = await processRun(
            'sh',
            [
              '-c',
              suCmd,
            ],
            runInShell: true);
        if (suResult.exitCode == 0) return suResult;
        return suResult; // return even if failed for logging clarity
      }
      return result;
    }
    return await processRun('bash', ['-c', cmd], runInShell: true);
  }

  Future<ProcessResult> _executeSerialMask() async {
    final s = settings.value;
    final port = s.windowsSerialPort!;
    final mask = _computeWindowsMask(s.activeLow);
    final canonical = _canonicalComPort(port);
    try {
      final result = await processRun(
          'cmd',
          [
            '/C',
            'echo $mask > $canonical',
          ],
          runInShell: true);
      if (result.exitCode != 0) {
        return ProcessResult(result.pid, result.exitCode, '', result.stderr);
      }
      // Embed a descriptive stdout so caller can log rawCommand meaningfully.
      return ProcessResult(result.pid, 0, 'SERIAL:$canonical mask=$mask', '');
    } catch (e) {
      return ProcessResult(0, 1, '', 'SERIAL ERROR: $e');
    }
  }

  Future<void> _initGpiod() async {
    try {
      final chips = FlutterGpiod.instance.chips;
      if (chips.isEmpty) return; // nothing available
      // Chip selection: choose by index or fallback first
      final chipIndex = settings.value.gpiodChipIndex;
      final chip =
          (chipIndex != null && chipIndex >= 0 && chipIndex < chips.length)
              ? chips[chipIndex]
              : chips.first;
      // If explicit line names provided attempt match by name else by offset list
      final lineMap = settings.value.gpiodLineNames;
      if (lineMap != null && lineMap.isNotEmpty) {
        for (final entry in lineMap.entries) {
          final name = entry.value;
          final line = chip.lines.firstWhere(
            (l) => l.info.name == name,
            orElse: () =>
                throw Exception('Line name "$name" not found on chip'),
          );
          line.requestOutput(
            consumer: 'idol_lamp',
            initialValue: settings.value.activeLow ? true : false,
          );
          _gpiodLines[entry.key] = line;
        }
      } else {
        // fallback: assume offsets 0,1,2 for channels 1,2,3
        for (var ch = 1; ch <= 3; ch++) {
          if (chip.lines.length > ch - 1) {
            final line = chip.lines[ch - 1];
            line.requestOutput(
              consumer: 'idol_lamp',
              initialValue: settings.value.activeLow ? true : false,
            );
            _gpiodLines[ch] = line;
          }
        }
      }
    } catch (e) {
      _logCommand(
        'GPIOD init failed: $e (fallback to shell)',
        channels: const [],
        value: false,
        simulated: false,
      );
    }
  }

  Future<void> _initializeLamp() async {
    await init();
  }

  void _releaseGpiod() {
    for (final l in _gpiodLines.values) {
      try {
        l.release();
      } catch (_) {}
    }
    _gpiodLines.clear();
  }

  Future<void> _runPattern(LightPattern pattern) async {
    await stopAlert();
    await Future.delayed(const Duration(milliseconds: 250));
    isAlertActive.value = true;
    try {
      final myGen = ++_patternGeneration;
      while (isAlertActive.value && myGen == _patternGeneration) {
        currentColor.value = pattern.channels.length == 1
            ? LampColor.values[pattern.channels.first]
            : LampColor.white;
        await setLightStatus(pattern.channels, true, delay: pattern.onDuration);
        if (isAlertActive.value && myGen == _patternGeneration) {
          currentColor.value = LampColor.off;
          await setLightStatus([1, 2, 3], false, delay: pattern.offDuration);
        }
      }
    } catch (_) {
      // ignore
    } finally {
      if (!isAlertActive.value) {
        await setLightStatus(currentColor.value.channels, true);
      }
    }
  }

  static String _getColorName(int channel) => channel == 1
      ? 'Red'
      : channel == 2
          ? 'Green'
          : 'Blue';
}

/// Immutable configuration for the lamp hardware & behaviour.
///
/// Provide a custom instance when constructing [LampController] to override
/// defaults (e.g. different GPIO paths, logic level, pattern timings).
class LampSettings {
  /// Default production hardware configuration.
  static const LampSettings defaults = LampSettings(
    model: "HW_3399_V12_GPIO",
    gpioPaths: {
      1: "/sys/devices/platform/gpio_ctrl0/gpioctrl0", // Red
      2: "/sys/devices/platform/gpio_ctrl1/gpioctrl1", // Green
      3: "/sys/devices/platform/gpio_ctrl2/gpioctrl2", // Blue
    },
    gpioPinNumbers: null,
    autoExportPins: false,
    activeLow: true,
    defaultOnDuration: Duration(milliseconds: 500),
    defaultOffDuration: Duration(milliseconds: 500),
    patternStartDelay: Duration(seconds: 1),
    defaultBrightness: 1.0,
    windowsSerialPort: null,
    windowsSerialBaudRate: 9600,
    enableWindowsGpio: false,
    useGpiod: false,
    gpiodLineNames: null,
    androidUseSu: false,
  );

  /// Hardware model identifier (for logging / diagnostics only).
  final String model;

  /// Map of logical channel -> sysfs path (or command target) used to toggle it.
  /// Channels are expected to start at 1 (Red=1, Green=2, Blue=3) but may be
  /// remapped by supplying a different map.
  /// sh -c 'echo 0 > /sys/devices/platform/gpio_ctrl0/gpioctrl0'
  ///  sh -c 'echo 1 > /sys/devices/platform/gpio_ctrl0/gpioctrl0'
  /// sh -c 'echo 0 > /sys/devices/platform/gpio_ctrl1/gpioctrl1'
  ///  sh -c 'echo 1 > /sys/devices/platform/gpio_ctrl1/gpioctrl1'
  final Map<int, String> gpioPaths;

  /// Whether the LEDs are wired active-low (writing 0 turns the LED on).
  final bool activeLow;

  /// Default ON duration for alert/blink patterns when not explicitly specified.
  final Duration defaultOnDuration;

  /// Default OFF duration for alert/blink patterns when not explicitly specified.
  final Duration defaultOffDuration;

  /// Delay inserted before a pattern begins (gives user perceptible transition).
  final Duration patternStartDelay;

  /// Default brightness used when controller instantiated.
  final double defaultBrightness;

  /// Optional GPIO pin numbers for sysfs export (Linux/Android). If provided,
  /// controller will auto-export and set direction for these pins at startup.
  /// Map: channel -> pin number (e.g. {1: 17, 2: 18, 3: 27}).
  final Map<int, int>? gpioPinNumbers;

  /// If true, pins in gpioPinNumbers will be exported and set as output at startup.
  final bool autoExportPins;

  /// Optional Windows COM port (e.g. 'COM3'). When non-null and running on
  /// Windows, serial mode is used instead of sysfs GPIO.
  final String? windowsSerialPort;

  /// Baud rate hint for future, currently informational (echo redirection does
  /// not configure baud). Kept for API completeness when moving to a proper
  /// serial library.
  final int windowsSerialBaudRate;

  /// Enable experimental Windows GPIO mode (executes echo commands via cmd).
  final bool enableWindowsGpio;

  /// Use flutter_gpiod (Linux) instead of shell echo when true.
  final bool useGpiod;

  /// Optional mapping channel -> line name (as exposed by kernel) for gpiod.
  final Map<int, String>? gpiodLineNames;

  /// Optional chip index for gpiod (multi-chip systems).
  final int? gpiodChipIndex;

  /// Attempt to elevate GPIO echo operations using `su -c` on Android when
  /// regular shell write fails due to permission denied. Requires rooted device.
  final bool androidUseSu;

  const LampSettings({
    required this.model,
    required this.gpioPaths,
    this.gpioPinNumbers,
    this.autoExportPins = false,
    this.activeLow = true,
    this.defaultOnDuration = const Duration(milliseconds: 500),
    this.defaultOffDuration = const Duration(milliseconds: 500),
    this.patternStartDelay = const Duration(seconds: 1),
    this.defaultBrightness = 1.0,
    this.windowsSerialPort,
    this.windowsSerialBaudRate = 9600,
    this.enableWindowsGpio = false,
    this.useGpiod = false,
    this.gpiodLineNames,
    this.gpiodChipIndex,
    this.androidUseSu = false,
  });

  LampSettings copyWith({
    String? model,
    Map<int, String>? gpioPaths,
    Map<int, int>? gpioPinNumbers,
    bool? autoExportPins,
    bool? activeLow,
    Duration? defaultOnDuration,
    Duration? defaultOffDuration,
    Duration? patternStartDelay,
    double? defaultBrightness,
    String? windowsSerialPort,
    int? windowsSerialBaudRate,
    bool? enableWindowsGpio,
    bool? useGpiod,
    Map<int, String>? gpiodLineNames,
    int? gpiodChipIndex,
    bool? androidUseSu,
  }) =>
      LampSettings(
        model: model ?? this.model,
        gpioPaths: gpioPaths ?? this.gpioPaths,
        gpioPinNumbers: gpioPinNumbers ?? this.gpioPinNumbers,
        autoExportPins: autoExportPins ?? this.autoExportPins,
        activeLow: activeLow ?? this.activeLow,
        defaultOnDuration: defaultOnDuration ?? this.defaultOnDuration,
        defaultOffDuration: defaultOffDuration ?? this.defaultOffDuration,
        patternStartDelay: patternStartDelay ?? this.patternStartDelay,
        defaultBrightness: defaultBrightness ?? this.defaultBrightness,
        windowsSerialPort: windowsSerialPort ?? this.windowsSerialPort,
        windowsSerialBaudRate:
            windowsSerialBaudRate ?? this.windowsSerialBaudRate,
        enableWindowsGpio: enableWindowsGpio ?? this.enableWindowsGpio,
        useGpiod: useGpiod ?? this.useGpiod,
        gpiodLineNames: gpiodLineNames ?? this.gpiodLineNames,
        gpiodChipIndex: gpiodChipIndex ?? this.gpiodChipIndex,
        androidUseSu: androidUseSu ?? this.androidUseSu,
      );

  Map<String, dynamic> toMap({bool? simulation}) => {
        'model': model,
        'gpioPaths': gpioPaths.map((k, v) => MapEntry(k.toString(), v)),
        'gpioPinNumbers':
            gpioPinNumbers?.map((k, v) => MapEntry(k.toString(), v)),
        'autoExportPins': autoExportPins,
        'activeLow': activeLow,
        'defaultOnDurationMs': defaultOnDuration.inMilliseconds,
        'defaultOffDurationMs': defaultOffDuration.inMilliseconds,
        'patternStartDelayMs': patternStartDelay.inMilliseconds,
        'defaultBrightness': defaultBrightness,
        'windowsSerialPort': windowsSerialPort,
        'windowsSerialBaudRate': windowsSerialBaudRate,
        'enableWindowsGpio': enableWindowsGpio,
        'useGpiod': useGpiod,
        'gpiodLineNames':
            gpiodLineNames?.map((k, v) => MapEntry(k.toString(), v)),
        'gpiodChipIndex': gpiodChipIndex,
        'androidUseSu': androidUseSu,
        'simulation': simulation,
      }..removeWhere((_, v) => v == null);

  static LampSettings fromMap(Map<String, dynamic> map) {
    Map<int, String> parseGpioPaths() {
      final raw = map['gpioPaths'];
      if (raw is Map) {
        return raw.map<int, String>(
          (key, value) => MapEntry(int.parse(key.toString()), value.toString()),
        );
      }
      return LampSettings.defaults.gpioPaths;
    }

    Map<int, int>? parseGpioPinNumbers() {
      final raw = map['gpioPinNumbers'];
      if (raw is Map) {
        return raw.map<int, int>(
          (key, value) =>
              MapEntry(int.parse(key.toString()), int.parse(value.toString())),
        );
      }
      return null;
    }

    return LampSettings(
      model: map['model'] as String? ?? LampSettings.defaults.model,
      gpioPaths: parseGpioPaths(),
      gpioPinNumbers: parseGpioPinNumbers(),
      autoExportPins: map['autoExportPins'] as bool? ?? false,
      activeLow: map['activeLow'] as bool? ?? true,
      defaultOnDuration: Duration(
        milliseconds: map['defaultOnDurationMs'] as int? ?? 500,
      ),
      defaultOffDuration: Duration(
        milliseconds: map['defaultOffDurationMs'] as int? ?? 500,
      ),
      patternStartDelay: Duration(
        milliseconds: map['patternStartDelayMs'] as int? ?? 1000,
      ),
      // Be tolerant: value may be num or String. Previous direct cast caused
      // runtime type errors when a String (e.g. "0.8") was supplied.
      defaultBrightness: (() {
        final raw = map['defaultBrightness'];
        if (raw == null) return 1.0;
        if (raw is num) return raw.toDouble();
        if (raw is String) {
          final t = raw.trim();
          // Accept empty string as null -> default 1.0
          if (t.isEmpty) return 1.0;
          // Try parse; if fails, fall back to default
          final parsed = double.tryParse(t);
          return parsed ?? 1.0;
        }
        return 1.0; // fallback for unexpected type
      })(),
      windowsSerialPort: map['windowsSerialPort'] as String?,
      windowsSerialBaudRate: map['windowsSerialBaudRate'] as int? ?? 9600,
      enableWindowsGpio: map['enableWindowsGpio'] as bool? ?? false,
      useGpiod: map['useGpiod'] as bool? ?? false,
      gpiodLineNames: (map['gpiodLineNames'] is Map)
          ? (map['gpiodLineNames'] as Map).map<int, String>(
              (k, v) => MapEntry(int.parse(k.toString()), v.toString()),
            )
          : null,
      gpiodChipIndex: map['gpiodChipIndex'] as int?,
      androidUseSu: map['androidUseSu'] as bool? ?? false,
    );
  }
}

// Event & persistence related classes removed in simplified version.
// Light pattern definition
class LightPattern {
  final List<int> channels;
  final Duration onDuration;
  final Duration offDuration;

  const LightPattern({
    required this.channels,
    this.onDuration = const Duration(milliseconds: 500),
    this.offDuration = const Duration(milliseconds: 500),
  });

  LightPattern copyWith({
    List<int>? channels,
    Duration? onDuration,
    Duration? offDuration,
  }) {
    return LightPattern(
      channels: channels ?? this.channels,
      onDuration: onDuration ?? this.onDuration,
      offDuration: offDuration ?? this.offDuration,
    );
  }
}

// /// Extension for LampColor with utility methods
extension LampColorExtension on LampColor {
  List<int> get channels {
    switch (this) {
      case LampColor.red:
      case LampColor.redAlert:
        return [1];
      case LampColor.green:
      case LampColor.greenAlert:
        return [2];
      case LampColor.blue:
      case LampColor.blueAlert:
        return [3];
      case LampColor.yellow:
      case LampColor.yellowAlert:
        return [1, 2];
      case LampColor.purple:
      case LampColor.purpleAlert:
        return [1, 3];
      case LampColor.cyan:
      case LampColor.cyanAlert:
        return [2, 3];
      case LampColor.white:
      case LampColor.whiteAlert:
        return [1, 2, 3];
      case LampColor.policeAlert:
        return [1, 3];
      default:
        return [];
    }
  }

  Color get color {
    switch (this) {
      case LampColor.red:
      case LampColor.redAlert:
        return Colors.red;
      case LampColor.green:
      case LampColor.greenAlert:
        return Colors.green;
      case LampColor.blue:
      case LampColor.blueAlert:
        return Colors.blue;
      case LampColor.yellow:
      case LampColor.yellowAlert:
        return Colors.yellow;
      case LampColor.purple:
      case LampColor.purpleAlert:
        return Colors.purple;
      case LampColor.cyan:
      case LampColor.cyanAlert:
        return Colors.cyan;
      case LampColor.white:
      case LampColor.whiteAlert:
        return Colors.white;
      case LampColor.policeAlert:
        return Colors.blue;
      case LampColor.off:
        return Colors.grey;
    }
  }
}

extension LampLogging on LampController {
  void _logCommand(
    String message, {
    required List<int> channels,
    required bool value,
    required bool simulated,
    String? rawCommand,
    int? exitCode,
    String? stdoutStr,
    String? stderrStr,
  }) {
    final entry = LampCommandLogEntry(
      timestamp: DateTime.now(),
      channels: List<int>.from(channels),
      value: value,
      simulated: simulated,
      message: message,
      rawCommand: rawCommand,
      exitCode: exitCode,
      stdoutStr: stdoutStr,
      stderrStr: stderrStr,
    );
    commandLog.insert(0, entry);
    if (commandLog.length > LampController._maxLogEntries) {
      commandLog.removeRange(LampController._maxLogEntries, commandLog.length);
    }
  }

  // Exposed for UI to clear logs.
  // (moved into LampController class)
}

/// Extension for LightPattern to create copies with modified properties
extension LightPatternMetrics on LightPattern {
  /// Total cycle time (on + off) for one blink iteration.
  Duration get cycleDuration => onDuration + offDuration;

  /// Approximate cycles per second (Hz). Returns 0 if cycleDuration is zero.
  double get frequencyHz {
    final micros = cycleDuration.inMicroseconds;
    if (micros == 0) return 0;
    return 1000000 / micros;
  }
}

// Persistence helpers (kept private to this file scope)
extension _LampPersistence on LampController {
  Future<void> _loadPersistedSettings() async {
    try {
      // For now, skip persistence - use defaults
      const Map<String, dynamic>? raw = null;
      if (raw != null) {
        final map = raw.cast<String, dynamic>();
        final loaded = LampSettings.fromMap(map);
        settings.value = loaded;
        if (map.containsKey('simulation')) {
          final sim = map['simulation'];
          if (sim is bool) {
            forceSimulation = sim;
          }
        }
        if (map.containsKey('simulationReason')) {
          final sr = map['simulationReason'];
          if (sr is String && sr.isNotEmpty) {
            _simulationReason = sr;
          }
        }
      }
    } catch (_) {
      // ignore errors: fallback to defaults
    }
  }

  Future<void> _persistSettings() async {
    try {
      // For now, just log the settings persistence
      // In production, you could save to SharedPreferences or Hive
      print('Lamp settings would be persisted: ${settings.value}');
    } catch (_) {
      // ignore errors
    }
  }

}
