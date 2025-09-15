// This is a generated file - do not edit.
//
// Generated from domain/item.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// *
///  An enumeration of all possible item types, determining how the item is handled at the POS.
class ItemTypeProto extends $pb.ProtobufEnum {
  static const ItemTypeProto ITEM_TYPE_UNSPECIFIED =
      ItemTypeProto._(0, _omitEnumNames ? '' : 'ITEM_TYPE_UNSPECIFIED');
  static const ItemTypeProto NORMAL =
      ItemTypeProto._(1, _omitEnumNames ? '' : 'NORMAL');
  static const ItemTypeProto QUANTITY_REQUIRED =
      ItemTypeProto._(2, _omitEnumNames ? '' : 'QUANTITY_REQUIRED');
  static const ItemTypeProto WEIGHT_REQUIRED =
      ItemTypeProto._(3, _omitEnumNames ? '' : 'WEIGHT_REQUIRED');
  static const ItemTypeProto WEIGHT_EMBEDDED =
      ItemTypeProto._(4, _omitEnumNames ? '' : 'WEIGHT_EMBEDDED');
  static const ItemTypeProto PRICE_EMBEDDED =
      ItemTypeProto._(5, _omitEnumNames ? '' : 'PRICE_EMBEDDED');

  static const $core.List<ItemTypeProto> values = <ItemTypeProto>[
    ITEM_TYPE_UNSPECIFIED,
    NORMAL,
    QUANTITY_REQUIRED,
    WEIGHT_REQUIRED,
    WEIGHT_EMBEDDED,
    PRICE_EMBEDDED,
  ];

  static final $core.List<ItemTypeProto?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ItemTypeProto? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ItemTypeProto._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
