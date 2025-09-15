// This is a generated file - do not edit.
//
// Generated from domain/quick_lookup.proto.

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
///  Represents a single item in a Quick Lookup (PLU) list.
class QuickLookupItemProto extends $pb.GeneratedMessage {
  factory QuickLookupItemProto({
    $core.String? barcode,
    $core.String? name,
    $core.String? description,
    $core.List<$core.int>? rawImage,
  }) {
    final result = create();
    if (barcode != null) result.barcode = barcode;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (rawImage != null) result.rawImage = rawImage;
    return result;
  }

  QuickLookupItemProto._();

  factory QuickLookupItemProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuickLookupItemProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLookupItemProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'barcode')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'rawImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLookupItemProto clone() =>
      QuickLookupItemProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLookupItemProto copyWith(void Function(QuickLookupItemProto) updates) =>
      super.copyWith((message) => updates(message as QuickLookupItemProto))
          as QuickLookupItemProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuickLookupItemProto create() => QuickLookupItemProto._();
  @$core.override
  QuickLookupItemProto createEmptyInstance() => create();
  static $pb.PbList<QuickLookupItemProto> createRepeated() =>
      $pb.PbList<QuickLookupItemProto>();
  @$core.pragma('dart2js:noInline')
  static QuickLookupItemProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuickLookupItemProto>(create);
  static QuickLookupItemProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get barcode => $_getSZ(0);
  @$pb.TagNumber(1)
  set barcode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBarcode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBarcode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  /// An optional image of the item, encoded as raw bytes (e.g., JPEG or PNG).
  @$pb.TagNumber(4)
  $core.List<$core.int> get rawImage => $_getN(3);
  @$pb.TagNumber(4)
  set rawImage($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRawImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearRawImage() => $_clearField(4);
}

/// *
///  A list of quick lookup items belonging to a single category.
class QuickLookupItemListProto extends $pb.GeneratedMessage {
  factory QuickLookupItemListProto({
    $core.Iterable<QuickLookupItemProto>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  QuickLookupItemListProto._();

  factory QuickLookupItemListProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuickLookupItemListProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLookupItemListProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..pc<QuickLookupItemProto>(
        1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM,
        subBuilder: QuickLookupItemProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLookupItemListProto clone() =>
      QuickLookupItemListProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLookupItemListProto copyWith(
          void Function(QuickLookupItemListProto) updates) =>
      super.copyWith((message) => updates(message as QuickLookupItemListProto))
          as QuickLookupItemListProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuickLookupItemListProto create() => QuickLookupItemListProto._();
  @$core.override
  QuickLookupItemListProto createEmptyInstance() => create();
  static $pb.PbList<QuickLookupItemListProto> createRepeated() =>
      $pb.PbList<QuickLookupItemListProto>();
  @$core.pragma('dart2js:noInline')
  static QuickLookupItemListProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuickLookupItemListProto>(create);
  static QuickLookupItemListProto? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QuickLookupItemProto> get items => $_getList(0);
}

/// *
///  The response containing all quick lookup items, organized by category.
class GetQuickLookupItemsResponseProto extends $pb.GeneratedMessage {
  factory GetQuickLookupItemsResponseProto({
    $core.Iterable<$core.MapEntry<$core.String, QuickLookupItemListProto>>?
        quickLookupCategories,
  }) {
    final result = create();
    if (quickLookupCategories != null)
      result.quickLookupCategories.addEntries(quickLookupCategories);
    return result;
  }

  GetQuickLookupItemsResponseProto._();

  factory GetQuickLookupItemsResponseProto.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetQuickLookupItemsResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQuickLookupItemsResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..m<$core.String, QuickLookupItemListProto>(
        1, _omitFieldNames ? '' : 'quickLookupCategories',
        entryClassName:
            'GetQuickLookupItemsResponseProto.QuickLookupCategoriesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: QuickLookupItemListProto.create,
        valueDefaultOrMaker: QuickLookupItemListProto.getDefault,
        packageName: const $pb.PackageName('domain'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLookupItemsResponseProto clone() =>
      GetQuickLookupItemsResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLookupItemsResponseProto copyWith(
          void Function(GetQuickLookupItemsResponseProto) updates) =>
      super.copyWith(
              (message) => updates(message as GetQuickLookupItemsResponseProto))
          as GetQuickLookupItemsResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetQuickLookupItemsResponseProto create() =>
      GetQuickLookupItemsResponseProto._();
  @$core.override
  GetQuickLookupItemsResponseProto createEmptyInstance() => create();
  static $pb.PbList<GetQuickLookupItemsResponseProto> createRepeated() =>
      $pb.PbList<GetQuickLookupItemsResponseProto>();
  @$core.pragma('dart2js:noInline')
  static GetQuickLookupItemsResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQuickLookupItemsResponseProto>(
          create);
  static GetQuickLookupItemsResponseProto? _defaultInstance;

  /// A map where the key is the category name (e.g., "Fruits", "Bakery")
  /// and the value is the list of items in that category.
  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, QuickLookupItemListProto> get quickLookupCategories =>
      $_getMap(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
