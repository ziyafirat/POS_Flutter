// This is a generated file - do not edit.
//
// Generated from domain/payment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/money.pb.dart' as $1;
import 'tender.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents a single payment applied to a transaction.
class PaymentProto extends $pb.GeneratedMessage {
  factory PaymentProto({
    $0.TenderProto? tender,
    $1.MoneyProto? amount,
  }) {
    final result = create();
    if (tender != null) result.tender = tender;
    if (amount != null) result.amount = amount;
    return result;
  }

  PaymentProto._();

  factory PaymentProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PaymentProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$0.TenderProto>(1, _omitFieldNames ? '' : 'tender',
        subBuilder: $0.TenderProto.create)
    ..aOM<$1.MoneyProto>(2, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.MoneyProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentProto clone() => PaymentProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentProto copyWith(void Function(PaymentProto) updates) =>
      super.copyWith((message) => updates(message as PaymentProto))
          as PaymentProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentProto create() => PaymentProto._();
  @$core.override
  PaymentProto createEmptyInstance() => create();
  static $pb.PbList<PaymentProto> createRepeated() =>
      $pb.PbList<PaymentProto>();
  @$core.pragma('dart2js:noInline')
  static PaymentProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentProto>(create);
  static PaymentProto? _defaultInstance;

  /// The method of payment used. See `domain/tender.proto`.
  @$pb.TagNumber(1)
  $0.TenderProto get tender => $_getN(0);
  @$pb.TagNumber(1)
  set tender($0.TenderProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTender() => $_has(0);
  @$pb.TagNumber(1)
  void clearTender() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.TenderProto ensureTender() => $_ensure(0);

  /// The amount of the payment.
  @$pb.TagNumber(2)
  $1.MoneyProto get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($1.MoneyProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.MoneyProto ensureAmount() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
