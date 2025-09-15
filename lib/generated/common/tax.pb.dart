// This is a generated file - do not edit.
//
// Generated from common/tax.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'money.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents the tax information for an item or transaction.
class TaxProto extends $pb.GeneratedMessage {
  factory TaxProto({
    $core.int? taxFactor,
    $0.MoneyProto? taxAmount,
  }) {
    final result = create();
    if (taxFactor != null) result.taxFactor = taxFactor;
    if (taxAmount != null) result.taxAmount = taxAmount;
    return result;
  }

  TaxProto._();

  factory TaxProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TaxProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TaxProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'taxFactor', $pb.PbFieldType.O3,
        protoName: 'taxFactor')
    ..aOM<$0.MoneyProto>(2, _omitFieldNames ? '' : 'taxAmount',
        protoName: 'taxAmount', subBuilder: $0.MoneyProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxProto clone() => TaxProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxProto copyWith(void Function(TaxProto) updates) =>
      super.copyWith((message) => updates(message as TaxProto)) as TaxProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TaxProto create() => TaxProto._();
  @$core.override
  TaxProto createEmptyInstance() => create();
  static $pb.PbList<TaxProto> createRepeated() => $pb.PbList<TaxProto>();
  @$core.pragma('dart2js:noInline')
  static TaxProto getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaxProto>(create);
  static TaxProto? _defaultInstance;

  /// The tax rate expressed as a factor (e.g., 8 for 8%, 18 for 18%).
  @$pb.TagNumber(1)
  $core.int get taxFactor => $_getIZ(0);
  @$pb.TagNumber(1)
  set taxFactor($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaxFactor() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaxFactor() => $_clearField(1);

  /// The calculated tax amount for the associated item or total.
  @$pb.TagNumber(2)
  $0.MoneyProto get taxAmount => $_getN(1);
  @$pb.TagNumber(2)
  set taxAmount($0.MoneyProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTaxAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaxAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.MoneyProto ensureTaxAmount() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
