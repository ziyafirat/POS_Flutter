// This is a generated file - do not edit.
//
// Generated from domain/get_line_items.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'line_item.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  A response message containing all line items for a given transaction.
class GetLineItemsResponseProto extends $pb.GeneratedMessage {
  factory GetLineItemsResponseProto({
    $core.Iterable<$0.LineItemResponseProto>? lineItems,
  }) {
    final result = create();
    if (lineItems != null) result.lineItems.addAll(lineItems);
    return result;
  }

  GetLineItemsResponseProto._();

  factory GetLineItemsResponseProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLineItemsResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLineItemsResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..pc<$0.LineItemResponseProto>(
        1, _omitFieldNames ? '' : 'lineItems', $pb.PbFieldType.PM,
        subBuilder: $0.LineItemResponseProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLineItemsResponseProto clone() =>
      GetLineItemsResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLineItemsResponseProto copyWith(
          void Function(GetLineItemsResponseProto) updates) =>
      super.copyWith((message) => updates(message as GetLineItemsResponseProto))
          as GetLineItemsResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLineItemsResponseProto create() => GetLineItemsResponseProto._();
  @$core.override
  GetLineItemsResponseProto createEmptyInstance() => create();
  static $pb.PbList<GetLineItemsResponseProto> createRepeated() =>
      $pb.PbList<GetLineItemsResponseProto>();
  @$core.pragma('dart2js:noInline')
  static GetLineItemsResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLineItemsResponseProto>(create);
  static GetLineItemsResponseProto? _defaultInstance;

  /// A list of all items currently in the transaction basket.
  @$pb.TagNumber(1)
  $pb.PbList<$0.LineItemResponseProto> get lineItems => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
