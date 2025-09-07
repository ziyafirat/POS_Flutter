// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      currentScreen: $enumDecode(_$AppScreenEnumMap, json['currentScreen']),
      grpcStatus: $enumDecode(_$ConnectionStatusEnumMap, json['grpcStatus']),
      mqttStatus: $enumDecode(_$ConnectionStatusEnumMap, json['mqttStatus']),
      isAlertActive: json['isAlertActive'] as bool,
      errorMessage: json['errorMessage'] as String?,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'currentScreen': _$AppScreenEnumMap[instance.currentScreen]!,
      'grpcStatus': _$ConnectionStatusEnumMap[instance.grpcStatus]!,
      'mqttStatus': _$ConnectionStatusEnumMap[instance.mqttStatus]!,
      'isAlertActive': instance.isAlertActive,
      'errorMessage': instance.errorMessage,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

const _$AppScreenEnumMap = {
  AppScreen.start: 'start',
  AppScreen.itemScan: 'itemScan',
  AppScreen.payment: 'payment',
  AppScreen.processing: 'processing',
  AppScreen.printing: 'printing',
  AppScreen.error: 'error',
  AppScreen.alert: 'alert',
  AppScreen.assistant: 'assistant',
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.connected: 'connected',
  ConnectionStatus.disconnected: 'disconnected',
  ConnectionStatus.connecting: 'connecting',
  ConnectionStatus.error: 'error',
};
