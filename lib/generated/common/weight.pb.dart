// This is a generated file - do not edit.
//
// Generated from common/weight.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents a weight measurement with a specific unit.
class WeightProto extends $pb.GeneratedMessage {
  factory WeightProto({
    $core.int? weightValue,
    $core.String? weightUnit,
    $core.int? tolerance,
  }) {
    final result = create();
    if (weightValue != null) result.weightValue = weightValue;
    if (weightUnit != null) result.weightUnit = weightUnit;
    if (tolerance != null) result.tolerance = tolerance;
    return result;
  }

  WeightProto._();

  factory WeightProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeightProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WeightProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'weightValue', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'weightUnit')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'tolerance', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightProto clone() => WeightProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightProto copyWith(void Function(WeightProto) updates) =>
      super.copyWith((message) => updates(message as WeightProto))
          as WeightProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeightProto create() => WeightProto._();
  @$core.override
  WeightProto createEmptyInstance() => create();
  static $pb.PbList<WeightProto> createRepeated() => $pb.PbList<WeightProto>();
  @$core.pragma('dart2js:noInline')
  static WeightProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeightProto>(create);
  static WeightProto? _defaultInstance;

  /// The measured weight value, typically in the smallest common unit like grams.
  @$pb.TagNumber(1)
  $core.int get weightValue => $_getIZ(0);
  @$pb.TagNumber(1)
  set weightValue($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWeightValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearWeightValue() => $_clearField(1);

  /// The unit of measurement (e.g., "GR", "KG", "LB").
  /// Using a string provides flexibility for different unit systems.
  @$pb.TagNumber(2)
  $core.String get weightUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set weightUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeightUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeightUnit() => $_clearField(2);

  /// An optional tolerance value used for weight verification,
  /// typically expressed in the same unit as `weight_value`.
  @$pb.TagNumber(3)
  $core.int get tolerance => $_getIZ(2);
  @$pb.TagNumber(3)
  set tolerance($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTolerance() => $_has(2);
  @$pb.TagNumber(3)
  void clearTolerance() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
