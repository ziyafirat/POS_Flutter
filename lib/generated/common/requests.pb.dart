// This is a generated file - do not edit.
//
// Generated from common/requests.proto.

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
///  A generic request message used for RPC calls that operate on an existing transaction.
class TransactionRequestProto extends $pb.GeneratedMessage {
  factory TransactionRequestProto({
    $core.String? posTxId,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    return result;
  }

  TransactionRequestProto._();

  factory TransactionRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransactionRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransactionRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionRequestProto clone() =>
      TransactionRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionRequestProto copyWith(
          void Function(TransactionRequestProto) updates) =>
      super.copyWith((message) => updates(message as TransactionRequestProto))
          as TransactionRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransactionRequestProto create() => TransactionRequestProto._();
  @$core.override
  TransactionRequestProto createEmptyInstance() => create();
  static $pb.PbList<TransactionRequestProto> createRepeated() =>
      $pb.PbList<TransactionRequestProto>();
  @$core.pragma('dart2js:noInline')
  static TransactionRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionRequestProto>(create);
  static TransactionRequestProto? _defaultInstance;

  /// The unique identifier for the point-of-sale transaction that this request targets.
  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
