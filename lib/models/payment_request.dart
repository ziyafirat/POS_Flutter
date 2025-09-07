import 'package:json_annotation/json_annotation.dart';

part 'payment_request.g.dart';

@JsonSerializable()
class PaymentRequest {
  final String orderId;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final List<String> itemIds;

  const PaymentRequest({
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.itemIds,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

enum PaymentMethod {
  cash,
  card,
}

@JsonSerializable()
class PaymentResponse {
  final String transactionId;
  final PaymentStatus status;
  final String? errorMessage;
  final String? receiptData;

  const PaymentResponse({
    required this.transactionId,
    required this.status,
    this.errorMessage,
    this.receiptData,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

enum PaymentStatus {
  success,
  failed,
  processing,
  cancelled,
}
