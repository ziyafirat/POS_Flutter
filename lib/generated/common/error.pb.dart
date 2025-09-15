// This is a generated file - do not edit.
//
// Generated from common/error.proto.

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
///  Represents a structured business error that can be returned by an RPC call.
///  This provides a standardized way to communicate controlled, non-terminal failures.
class BusinessErrorProto extends $pb.GeneratedMessage {
  factory BusinessErrorProto({
    $core.String? errCode,
    $core.String? errMessage,
  }) {
    final result = create();
    if (errCode != null) result.errCode = errCode;
    if (errMessage != null) result.errMessage = errMessage;
    return result;
  }

  BusinessErrorProto._();

  factory BusinessErrorProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BusinessErrorProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BusinessErrorProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'errCode', protoName: 'errCode')
    ..aOS(2, _omitFieldNames ? '' : 'errMessage', protoName: 'errMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BusinessErrorProto clone() => BusinessErrorProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BusinessErrorProto copyWith(void Function(BusinessErrorProto) updates) =>
      super.copyWith((message) => updates(message as BusinessErrorProto))
          as BusinessErrorProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BusinessErrorProto create() => BusinessErrorProto._();
  @$core.override
  BusinessErrorProto createEmptyInstance() => create();
  static $pb.PbList<BusinessErrorProto> createRepeated() =>
      $pb.PbList<BusinessErrorProto>();
  @$core.pragma('dart2js:noInline')
  static BusinessErrorProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BusinessErrorProto>(create);
  static BusinessErrorProto? _defaultInstance;

  /// A machine-readable, unique code identifying the specific error type.
  /// e.g., "POS_ITEM_NOT_FOUND", "POS_PURCHASE_LIMIT".
  @$pb.TagNumber(1)
  $core.String get errCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set errCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrCode() => $_clearField(1);

  /// A human-readable, user-facing message describing the error.
  /// This message is suitable for display on a client UI.
  @$pb.TagNumber(2)
  $core.String get errMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrMessage() => $_clearField(2);
}

/// *
///  Provides detailed, structured information about a client-side failure.
///  This is embedded in the gRPC Status trailers for rich error propagation.
class ClientErrorDetailsProto extends $pb.GeneratedMessage {
  factory ClientErrorDetailsProto({
    $core.String? exceptionClass,
    $core.String? exceptionMessage,
  }) {
    final result = create();
    if (exceptionClass != null) result.exceptionClass = exceptionClass;
    if (exceptionMessage != null) result.exceptionMessage = exceptionMessage;
    return result;
  }

  ClientErrorDetailsProto._();

  factory ClientErrorDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientErrorDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientErrorDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exceptionClass')
    ..aOS(2, _omitFieldNames ? '' : 'exceptionMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientErrorDetailsProto clone() =>
      ClientErrorDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientErrorDetailsProto copyWith(
          void Function(ClientErrorDetailsProto) updates) =>
      super.copyWith((message) => updates(message as ClientErrorDetailsProto))
          as ClientErrorDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientErrorDetailsProto create() => ClientErrorDetailsProto._();
  @$core.override
  ClientErrorDetailsProto createEmptyInstance() => create();
  static $pb.PbList<ClientErrorDetailsProto> createRepeated() =>
      $pb.PbList<ClientErrorDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static ClientErrorDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientErrorDetailsProto>(create);
  static ClientErrorDetailsProto? _defaultInstance;

  /// The simple class name of the exception that occurred on the client.
  /// e.g., "IllegalArgumentException"
  @$pb.TagNumber(1)
  $core.String get exceptionClass => $_getSZ(0);
  @$pb.TagNumber(1)
  set exceptionClass($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExceptionClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearExceptionClass() => $_clearField(1);

  /// The message from the original exception.
  /// e.g., "okLabel can't be null"
  @$pb.TagNumber(2)
  $core.String get exceptionMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set exceptionMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExceptionMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearExceptionMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
