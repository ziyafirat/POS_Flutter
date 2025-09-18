import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

enum AppScreen {
  start,
  itemScan,
  payment,
  processing,
  printing,
  error,
  alert,
  fraudAlert,
  assistant,
  posCashier,
  parameters,
  terminalClosed,
}

enum ConnectionStatus { connected, disconnected, connecting, error }

@JsonSerializable()
class AppState {
  final AppScreen currentScreen;
  final ConnectionStatus mqttStatus;
  final bool isAlertActive;
  final String? errorMessage;
  final DateTime lastUpdate;

  const AppState({
    required this.currentScreen,
    required this.mqttStatus,
    required this.isAlertActive,
    this.errorMessage,
    required this.lastUpdate,
  });

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    AppScreen? currentScreen,
    ConnectionStatus? mqttStatus,
    bool? isAlertActive,
    String? errorMessage,
    DateTime? lastUpdate,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      mqttStatus: mqttStatus ?? this.mqttStatus,
      isAlertActive: isAlertActive ?? this.isAlertActive,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  bool get isConnected => mqttStatus == ConnectionStatus.connected;
  bool get hasActiveAlert => isAlertActive;
}
