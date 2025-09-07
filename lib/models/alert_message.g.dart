// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertMessage _$AlertMessageFromJson(Map<String, dynamic> json) => AlertMessage(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$AlertTypeEnumMap, json['type']),
      videoUrl: json['videoUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AlertMessageToJson(AlertMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'videoUrl': instance.videoUrl,
      'timestamp': instance.timestamp.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$AlertTypeEnumMap = {
  AlertType.security: 'security',
  AlertType.maintenance: 'maintenance',
  AlertType.promotion: 'promotion',
  AlertType.system: 'system',
};
