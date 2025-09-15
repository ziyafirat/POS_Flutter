// This is a generated file - do not edit.
//
// Generated from domain/interaction_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// *
///  An enumeration of supported, structured date formats, providing a
///  type-safe contract for the client's renderer and a hint for the user.
class DateTimePromptProto_DateTimeFormat extends $pb.ProtobufEnum {
  static const DateTimePromptProto_DateTimeFormat DATE_FORMAT_UNSPECIFIED =
      DateTimePromptProto_DateTimeFormat._(
          0, _omitEnumNames ? '' : 'DATE_FORMAT_UNSPECIFIED');
  static const DateTimePromptProto_DateTimeFormat DDMMYYYY =
      DateTimePromptProto_DateTimeFormat._(1, _omitEnumNames ? '' : 'DDMMYYYY');
  static const DateTimePromptProto_DateTimeFormat MMDDYYYY =
      DateTimePromptProto_DateTimeFormat._(2, _omitEnumNames ? '' : 'MMDDYYYY');
  static const DateTimePromptProto_DateTimeFormat YYYYMMDD =
      DateTimePromptProto_DateTimeFormat._(3, _omitEnumNames ? '' : 'YYYYMMDD');
  static const DateTimePromptProto_DateTimeFormat DDMMYYYYHHMI =
      DateTimePromptProto_DateTimeFormat._(
          4, _omitEnumNames ? '' : 'DDMMYYYYHHMI');
  static const DateTimePromptProto_DateTimeFormat MMYYYY =
      DateTimePromptProto_DateTimeFormat._(5, _omitEnumNames ? '' : 'MMYYYY');
  static const DateTimePromptProto_DateTimeFormat HHMI =
      DateTimePromptProto_DateTimeFormat._(6, _omitEnumNames ? '' : 'HHMI');

  static const $core.List<DateTimePromptProto_DateTimeFormat> values =
      <DateTimePromptProto_DateTimeFormat>[
    DATE_FORMAT_UNSPECIFIED,
    DDMMYYYY,
    MMDDYYYY,
    YYYYMMDD,
    DDMMYYYYHHMI,
    MMYYYY,
    HHMI,
  ];

  static final $core.List<DateTimePromptProto_DateTimeFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static DateTimePromptProto_DateTimeFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DateTimePromptProto_DateTimeFormat._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
