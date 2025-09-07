import 'package:json_annotation/json_annotation.dart';

part 'alert_message.g.dart';

@JsonSerializable()
class AlertMessage {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final String? videoUrl;
  final DateTime timestamp;
  final bool isActive;

  const AlertMessage({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.videoUrl,
    required this.timestamp,
    required this.isActive,
  });

  factory AlertMessage.fromJson(Map<String, dynamic> json) =>
      _$AlertMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AlertMessageToJson(this);

  AlertMessage copyWith({
    String? id,
    String? title,
    String? message,
    AlertType? type,
    String? videoUrl,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return AlertMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      videoUrl: videoUrl ?? this.videoUrl,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum AlertType {
  security,
  maintenance,
  promotion,
  system,
}
