// This is a generated file - do not edit.
//
// Generated from common/money.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents a monetary value with a specific currency.
///  This structure is used throughout the API to handle all financial amounts.
class MoneyProto extends $pb.GeneratedMessage {
  factory MoneyProto({
    $fixnum.Int64? amountInLowestDenomination,
    $core.String? currencyCode,
  }) {
    final result = create();
    if (amountInLowestDenomination != null)
      result.amountInLowestDenomination = amountInLowestDenomination;
    if (currencyCode != null) result.currencyCode = currencyCode;
    return result;
  }

  MoneyProto._();

  factory MoneyProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoneyProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoneyProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'amountInLowestDenomination')
    ..aOS(2, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyProto clone() => MoneyProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyProto copyWith(void Function(MoneyProto) updates) =>
      super.copyWith((message) => updates(message as MoneyProto)) as MoneyProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoneyProto create() => MoneyProto._();
  @$core.override
  MoneyProto createEmptyInstance() => create();
  static $pb.PbList<MoneyProto> createRepeated() => $pb.PbList<MoneyProto>();
  @$core.pragma('dart2js:noInline')
  static MoneyProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoneyProto>(create);
  static MoneyProto? _defaultInstance;

  /// The total monetary amount expressed in the currency's smallest unit
  /// (e.g., kuruş for TR, cents for USD, yen for JPY).
  @$pb.TagNumber(1)
  $fixnum.Int64 get amountInLowestDenomination => $_getI64(0);
  @$pb.TagNumber(1)
  set amountInLowestDenomination($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmountInLowestDenomination() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmountInLowestDenomination() => $_clearField(1);

  /// The ISO 4217 currency code (e.g., "USD", "EUR", "TRY").
  @$pb.TagNumber(2)
  $core.String get currencyCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set currencyCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrencyCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrencyCode() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
