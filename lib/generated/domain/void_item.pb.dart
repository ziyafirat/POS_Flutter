// This is a generated file - do not edit.
//
// Generated from domain/void_item.proto.

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
///  Request to void (remove) a specific line item from a transaction.
class VoidItemRequestProto extends $pb.GeneratedMessage {
  factory VoidItemRequestProto({
    $core.String? posTxId,
    $core.String? posLineItemId,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (posLineItemId != null) result.posLineItemId = posLineItemId;
    return result;
  }

  VoidItemRequestProto._();

  factory VoidItemRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoidItemRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoidItemRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOS(2, _omitFieldNames ? '' : 'posLineItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidItemRequestProto clone() =>
      VoidItemRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidItemRequestProto copyWith(void Function(VoidItemRequestProto) updates) =>
      super.copyWith((message) => updates(message as VoidItemRequestProto))
          as VoidItemRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidItemRequestProto create() => VoidItemRequestProto._();
  @$core.override
  VoidItemRequestProto createEmptyInstance() => create();
  static $pb.PbList<VoidItemRequestProto> createRepeated() =>
      $pb.PbList<VoidItemRequestProto>();
  @$core.pragma('dart2js:noInline')
  static VoidItemRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoidItemRequestProto>(create);
  static VoidItemRequestProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  /// The unique ID of the line item instance to be voided.
  @$pb.TagNumber(2)
  $core.String get posLineItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set posLineItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPosLineItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosLineItemId() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
