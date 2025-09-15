// This is a generated file - do not edit.
//
// Generated from domain/set_customer.proto.

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
///  Request to associate a customer with the current transaction.
class SetCustomerRequestProto extends $pb.GeneratedMessage {
  factory SetCustomerRequestProto({
    $core.String? posTxId,
    $core.String? customerNumber,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (customerNumber != null) result.customerNumber = customerNumber;
    return result;
  }

  SetCustomerRequestProto._();

  factory SetCustomerRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetCustomerRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCustomerRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOS(2, _omitFieldNames ? '' : 'customerNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCustomerRequestProto clone() =>
      SetCustomerRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCustomerRequestProto copyWith(
          void Function(SetCustomerRequestProto) updates) =>
      super.copyWith((message) => updates(message as SetCustomerRequestProto))
          as SetCustomerRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetCustomerRequestProto create() => SetCustomerRequestProto._();
  @$core.override
  SetCustomerRequestProto createEmptyInstance() => create();
  static $pb.PbList<SetCustomerRequestProto> createRepeated() =>
      $pb.PbList<SetCustomerRequestProto>();
  @$core.pragma('dart2js:noInline')
  static SetCustomerRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCustomerRequestProto>(create);
  static SetCustomerRequestProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  /// The customer's unique identifier (e.g., loyalty card number, phone number).
  @$pb.TagNumber(2)
  $core.String get customerNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerNumber() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
