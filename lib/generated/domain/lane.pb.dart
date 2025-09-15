// This is a generated file - do not edit.
//
// Generated from domain/lane.proto.

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
///  Represents the initial request to open a session with the POSBC server,
///  identifying the specific client lane and operator.
class LaneRequestProto extends $pb.GeneratedMessage {
  factory LaneRequestProto({
    $core.String? companyId,
    $core.String? storeId,
    $core.String? laneId,
    $core.String? userName,
    $core.String? password,
  }) {
    final result = create();
    if (companyId != null) result.companyId = companyId;
    if (storeId != null) result.storeId = storeId;
    if (laneId != null) result.laneId = laneId;
    if (userName != null) result.userName = userName;
    if (password != null) result.password = password;
    return result;
  }

  LaneRequestProto._();

  factory LaneRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LaneRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LaneRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'companyId', protoName: 'companyId')
    ..aOS(2, _omitFieldNames ? '' : 'storeId', protoName: 'storeId')
    ..aOS(3, _omitFieldNames ? '' : 'laneId', protoName: 'laneId')
    ..aOS(4, _omitFieldNames ? '' : 'userName', protoName: 'userName')
    ..aOS(5, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LaneRequestProto clone() => LaneRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LaneRequestProto copyWith(void Function(LaneRequestProto) updates) =>
      super.copyWith((message) => updates(message as LaneRequestProto))
          as LaneRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LaneRequestProto create() => LaneRequestProto._();
  @$core.override
  LaneRequestProto createEmptyInstance() => create();
  static $pb.PbList<LaneRequestProto> createRepeated() =>
      $pb.PbList<LaneRequestProto>();
  @$core.pragma('dart2js:noInline')
  static LaneRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LaneRequestProto>(create);
  static LaneRequestProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get companyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set companyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCompanyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompanyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStoreId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoreId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get laneId => $_getSZ(2);
  @$pb.TagNumber(3)
  set laneId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLaneId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLaneId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userName => $_getSZ(3);
  @$pb.TagNumber(4)
  set userName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserName() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password => $_getSZ(4);
  @$pb.TagNumber(5)
  set password($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
