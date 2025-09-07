// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'itemIds': instance.itemIds,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
};

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      transactionId: json['transactionId'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      receiptData: json['receiptData'] as String?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
      'receiptData': instance.receiptData,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
  PaymentStatus.processing: 'processing',
  PaymentStatus.cancelled: 'cancelled',
};
