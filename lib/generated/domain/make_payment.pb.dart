// This is a generated file - do not edit.
//
// Generated from domain/make_payment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'payment.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  A request to make a simple, non-interactive payment.
class MakePaymentRequestProto extends $pb.GeneratedMessage {
  factory MakePaymentRequestProto({
    $core.String? posTxId,
    $0.PaymentProto? payment,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (payment != null) result.payment = payment;
    return result;
  }

  MakePaymentRequestProto._();

  factory MakePaymentRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MakePaymentRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MakePaymentRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOM<$0.PaymentProto>(2, _omitFieldNames ? '' : 'payment',
        subBuilder: $0.PaymentProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MakePaymentRequestProto clone() =>
      MakePaymentRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MakePaymentRequestProto copyWith(
          void Function(MakePaymentRequestProto) updates) =>
      super.copyWith((message) => updates(message as MakePaymentRequestProto))
          as MakePaymentRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MakePaymentRequestProto create() => MakePaymentRequestProto._();
  @$core.override
  MakePaymentRequestProto createEmptyInstance() => create();
  static $pb.PbList<MakePaymentRequestProto> createRepeated() =>
      $pb.PbList<MakePaymentRequestProto>();
  @$core.pragma('dart2js:noInline')
  static MakePaymentRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MakePaymentRequestProto>(create);
  static MakePaymentRequestProto? _defaultInstance;

  /// The ID of the transaction to which the payment should be applied.
  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  /// The payment details.
  @$pb.TagNumber(2)
  $0.PaymentProto get payment => $_getN(1);
  @$pb.TagNumber(2)
  set payment($0.PaymentProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPayment() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayment() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.PaymentProto ensurePayment() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
