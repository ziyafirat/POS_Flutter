// This is a generated file - do not edit.
//
// Generated from domain/print_report.proto.

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
///  A request to print a specific report.
class PrintReportRequestProto extends $pb.GeneratedMessage {
  factory PrintReportRequestProto({
    $core.String? reportId,
  }) {
    final result = create();
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  PrintReportRequestProto._();

  factory PrintReportRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintReportRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintReportRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportRequestProto clone() =>
      PrintReportRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportRequestProto copyWith(
          void Function(PrintReportRequestProto) updates) =>
      super.copyWith((message) => updates(message as PrintReportRequestProto))
          as PrintReportRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintReportRequestProto create() => PrintReportRequestProto._();
  @$core.override
  PrintReportRequestProto createEmptyInstance() => create();
  static $pb.PbList<PrintReportRequestProto> createRepeated() =>
      $pb.PbList<PrintReportRequestProto>();
  @$core.pragma('dart2js:noInline')
  static PrintReportRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintReportRequestProto>(create);
  static PrintReportRequestProto? _defaultInstance;

  /// The identifier of the report to be printed (e.g., "X_REPORT", "Z_REPORT").
  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
