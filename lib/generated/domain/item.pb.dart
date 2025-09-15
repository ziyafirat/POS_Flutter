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

import '../common/money.pb.dart' as $1;
import '../common/tax.pb.dart' as $2;
import '../common/weight.pb.dart' as $0;
import 'item.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'item.pbenum.dart';

/// *
///  Details for a standard, non-variable item.
class NormalItemDetailsProto extends $pb.GeneratedMessage {
  factory NormalItemDetailsProto({
    $0.WeightProto? definedWeight,
  }) {
    final result = create();
    if (definedWeight != null) result.definedWeight = definedWeight;
    return result;
  }

  NormalItemDetailsProto._();

  factory NormalItemDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NormalItemDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NormalItemDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$0.WeightProto>(1, _omitFieldNames ? '' : 'definedWeight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NormalItemDetailsProto clone() =>
      NormalItemDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NormalItemDetailsProto copyWith(
          void Function(NormalItemDetailsProto) updates) =>
      super.copyWith((message) => updates(message as NormalItemDetailsProto))
          as NormalItemDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NormalItemDetailsProto create() => NormalItemDetailsProto._();
  @$core.override
  NormalItemDetailsProto createEmptyInstance() => create();
  static $pb.PbList<NormalItemDetailsProto> createRepeated() =>
      $pb.PbList<NormalItemDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static NormalItemDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NormalItemDetailsProto>(create);
  static NormalItemDetailsProto? _defaultInstance;

  /// An optional, pre-defined weight used for security verification.
  @$pb.TagNumber(1)
  $0.WeightProto get definedWeight => $_getN(0);
  @$pb.TagNumber(1)
  set definedWeight($0.WeightProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinedWeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinedWeight() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.WeightProto ensureDefinedWeight() => $_ensure(0);
}

/// *
///  Details for an item that requires a quantity to be entered.
class QuantityRequiredItemDetailsProto extends $pb.GeneratedMessage {
  factory QuantityRequiredItemDetailsProto({
    $core.int? minQuantity,
    $core.int? maxQuantity,
    $0.WeightProto? definedWeight,
  }) {
    final result = create();
    if (minQuantity != null) result.minQuantity = minQuantity;
    if (maxQuantity != null) result.maxQuantity = maxQuantity;
    if (definedWeight != null) result.definedWeight = definedWeight;
    return result;
  }

  QuantityRequiredItemDetailsProto._();

  factory QuantityRequiredItemDetailsProto.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuantityRequiredItemDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuantityRequiredItemDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'minQuantity', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxQuantity', $pb.PbFieldType.O3)
    ..aOM<$0.WeightProto>(3, _omitFieldNames ? '' : 'definedWeight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuantityRequiredItemDetailsProto clone() =>
      QuantityRequiredItemDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuantityRequiredItemDetailsProto copyWith(
          void Function(QuantityRequiredItemDetailsProto) updates) =>
      super.copyWith(
              (message) => updates(message as QuantityRequiredItemDetailsProto))
          as QuantityRequiredItemDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuantityRequiredItemDetailsProto create() =>
      QuantityRequiredItemDetailsProto._();
  @$core.override
  QuantityRequiredItemDetailsProto createEmptyInstance() => create();
  static $pb.PbList<QuantityRequiredItemDetailsProto> createRepeated() =>
      $pb.PbList<QuantityRequiredItemDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static QuantityRequiredItemDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuantityRequiredItemDetailsProto>(
          create);
  static QuantityRequiredItemDetailsProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minQuantity => $_getIZ(0);
  @$pb.TagNumber(1)
  set minQuantity($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinQuantity() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinQuantity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxQuantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxQuantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.WeightProto get definedWeight => $_getN(2);
  @$pb.TagNumber(3)
  set definedWeight($0.WeightProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDefinedWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefinedWeight() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.WeightProto ensureDefinedWeight() => $_ensure(2);
}

/// *
///  Details for an item with weight information encoded in its barcode.
class WeightEmbeddedItemDetailsProto extends $pb.GeneratedMessage {
  factory WeightEmbeddedItemDetailsProto({
    $0.WeightProto? embeddedWeight,
  }) {
    final result = create();
    if (embeddedWeight != null) result.embeddedWeight = embeddedWeight;
    return result;
  }

  WeightEmbeddedItemDetailsProto._();

  factory WeightEmbeddedItemDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeightEmbeddedItemDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WeightEmbeddedItemDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$0.WeightProto>(1, _omitFieldNames ? '' : 'embeddedWeight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightEmbeddedItemDetailsProto clone() =>
      WeightEmbeddedItemDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightEmbeddedItemDetailsProto copyWith(
          void Function(WeightEmbeddedItemDetailsProto) updates) =>
      super.copyWith(
              (message) => updates(message as WeightEmbeddedItemDetailsProto))
          as WeightEmbeddedItemDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeightEmbeddedItemDetailsProto create() =>
      WeightEmbeddedItemDetailsProto._();
  @$core.override
  WeightEmbeddedItemDetailsProto createEmptyInstance() => create();
  static $pb.PbList<WeightEmbeddedItemDetailsProto> createRepeated() =>
      $pb.PbList<WeightEmbeddedItemDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static WeightEmbeddedItemDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeightEmbeddedItemDetailsProto>(create);
  static WeightEmbeddedItemDetailsProto? _defaultInstance;

  @$pb.TagNumber(1)
  $0.WeightProto get embeddedWeight => $_getN(0);
  @$pb.TagNumber(1)
  set embeddedWeight($0.WeightProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEmbeddedWeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmbeddedWeight() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.WeightProto ensureEmbeddedWeight() => $_ensure(0);
}

/// *
///  Details for an item with price information encoded in its barcode.
class PriceEmbeddedItemDetailsProto extends $pb.GeneratedMessage {
  factory PriceEmbeddedItemDetailsProto({
    $1.MoneyProto? embeddedPrice,
    $0.WeightProto? calculatedWeight,
  }) {
    final result = create();
    if (embeddedPrice != null) result.embeddedPrice = embeddedPrice;
    if (calculatedWeight != null) result.calculatedWeight = calculatedWeight;
    return result;
  }

  PriceEmbeddedItemDetailsProto._();

  factory PriceEmbeddedItemDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PriceEmbeddedItemDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PriceEmbeddedItemDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$1.MoneyProto>(1, _omitFieldNames ? '' : 'embeddedPrice',
        subBuilder: $1.MoneyProto.create)
    ..aOM<$0.WeightProto>(2, _omitFieldNames ? '' : 'calculatedWeight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceEmbeddedItemDetailsProto clone() =>
      PriceEmbeddedItemDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PriceEmbeddedItemDetailsProto copyWith(
          void Function(PriceEmbeddedItemDetailsProto) updates) =>
      super.copyWith(
              (message) => updates(message as PriceEmbeddedItemDetailsProto))
          as PriceEmbeddedItemDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PriceEmbeddedItemDetailsProto create() =>
      PriceEmbeddedItemDetailsProto._();
  @$core.override
  PriceEmbeddedItemDetailsProto createEmptyInstance() => create();
  static $pb.PbList<PriceEmbeddedItemDetailsProto> createRepeated() =>
      $pb.PbList<PriceEmbeddedItemDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static PriceEmbeddedItemDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PriceEmbeddedItemDetailsProto>(create);
  static PriceEmbeddedItemDetailsProto? _defaultInstance;

  @$pb.TagNumber(1)
  $1.MoneyProto get embeddedPrice => $_getN(0);
  @$pb.TagNumber(1)
  set embeddedPrice($1.MoneyProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEmbeddedPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmbeddedPrice() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.MoneyProto ensureEmbeddedPrice() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.WeightProto get calculatedWeight => $_getN(1);
  @$pb.TagNumber(2)
  set calculatedWeight($0.WeightProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCalculatedWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearCalculatedWeight() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.WeightProto ensureCalculatedWeight() => $_ensure(1);
}

/// *
///  Details for an item that must be weighed at the time of sale.
///  This message is a placeholder as no extra data is needed.
class WeightRequiredItemDetailsProto extends $pb.GeneratedMessage {
  factory WeightRequiredItemDetailsProto() => create();

  WeightRequiredItemDetailsProto._();

  factory WeightRequiredItemDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeightRequiredItemDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WeightRequiredItemDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightRequiredItemDetailsProto clone() =>
      WeightRequiredItemDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightRequiredItemDetailsProto copyWith(
          void Function(WeightRequiredItemDetailsProto) updates) =>
      super.copyWith(
              (message) => updates(message as WeightRequiredItemDetailsProto))
          as WeightRequiredItemDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeightRequiredItemDetailsProto create() =>
      WeightRequiredItemDetailsProto._();
  @$core.override
  WeightRequiredItemDetailsProto createEmptyInstance() => create();
  static $pb.PbList<WeightRequiredItemDetailsProto> createRepeated() =>
      $pb.PbList<WeightRequiredItemDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static WeightRequiredItemDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeightRequiredItemDetailsProto>(create);
  static WeightRequiredItemDetailsProto? _defaultInstance;
}

enum ItemResponseProto_ItemDetails {
  normalItem,
  quantityRequiredItem,
  weightEmbeddedItem,
  priceEmbeddedItem,
  weightRequiredItem,
  notSet
}

/// *
///  The complete representation of a catalog item.
class ItemResponseProto extends $pb.GeneratedMessage {
  factory ItemResponseProto({
    ItemTypeProto? type,
    $core.String? barcode,
    $core.String? name,
    $core.String? description,
    $1.MoneyProto? unitPrice,
    $2.TaxProto? tax,
    $core.bool? passAroundItem,
    $core.bool? lockedItem,
    $core.bool? ageRestrictedItem,
    NormalItemDetailsProto? normalItem,
    QuantityRequiredItemDetailsProto? quantityRequiredItem,
    WeightEmbeddedItemDetailsProto? weightEmbeddedItem,
    PriceEmbeddedItemDetailsProto? priceEmbeddedItem,
    WeightRequiredItemDetailsProto? weightRequiredItem,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (barcode != null) result.barcode = barcode;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (tax != null) result.tax = tax;
    if (passAroundItem != null) result.passAroundItem = passAroundItem;
    if (lockedItem != null) result.lockedItem = lockedItem;
    if (ageRestrictedItem != null) result.ageRestrictedItem = ageRestrictedItem;
    if (normalItem != null) result.normalItem = normalItem;
    if (quantityRequiredItem != null)
      result.quantityRequiredItem = quantityRequiredItem;
    if (weightEmbeddedItem != null)
      result.weightEmbeddedItem = weightEmbeddedItem;
    if (priceEmbeddedItem != null) result.priceEmbeddedItem = priceEmbeddedItem;
    if (weightRequiredItem != null)
      result.weightRequiredItem = weightRequiredItem;
    return result;
  }

  ItemResponseProto._();

  factory ItemResponseProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ItemResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ItemResponseProto_ItemDetails>
      _ItemResponseProto_ItemDetailsByTag = {
    11: ItemResponseProto_ItemDetails.normalItem,
    12: ItemResponseProto_ItemDetails.quantityRequiredItem,
    13: ItemResponseProto_ItemDetails.weightEmbeddedItem,
    14: ItemResponseProto_ItemDetails.priceEmbeddedItem,
    15: ItemResponseProto_ItemDetails.weightRequiredItem,
    0: ItemResponseProto_ItemDetails.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [11, 12, 13, 14, 15])
    ..e<ItemTypeProto>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: ItemTypeProto.ITEM_TYPE_UNSPECIFIED,
        valueOf: ItemTypeProto.valueOf,
        enumValues: ItemTypeProto.values)
    ..aOS(2, _omitFieldNames ? '' : 'barcode')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOM<$1.MoneyProto>(5, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: $1.MoneyProto.create)
    ..aOM<$2.TaxProto>(6, _omitFieldNames ? '' : 'tax',
        subBuilder: $2.TaxProto.create)
    ..aOB(7, _omitFieldNames ? '' : 'passAroundItem')
    ..aOB(8, _omitFieldNames ? '' : 'lockedItem')
    ..aOB(9, _omitFieldNames ? '' : 'ageRestrictedItem')
    ..aOM<NormalItemDetailsProto>(11, _omitFieldNames ? '' : 'normalItem',
        subBuilder: NormalItemDetailsProto.create)
    ..aOM<QuantityRequiredItemDetailsProto>(
        12, _omitFieldNames ? '' : 'quantityRequiredItem',
        subBuilder: QuantityRequiredItemDetailsProto.create)
    ..aOM<WeightEmbeddedItemDetailsProto>(
        13, _omitFieldNames ? '' : 'weightEmbeddedItem',
        subBuilder: WeightEmbeddedItemDetailsProto.create)
    ..aOM<PriceEmbeddedItemDetailsProto>(
        14, _omitFieldNames ? '' : 'priceEmbeddedItem',
        subBuilder: PriceEmbeddedItemDetailsProto.create)
    ..aOM<WeightRequiredItemDetailsProto>(
        15, _omitFieldNames ? '' : 'weightRequiredItem',
        subBuilder: WeightRequiredItemDetailsProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemResponseProto clone() => ItemResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemResponseProto copyWith(void Function(ItemResponseProto) updates) =>
      super.copyWith((message) => updates(message as ItemResponseProto))
          as ItemResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ItemResponseProto create() => ItemResponseProto._();
  @$core.override
  ItemResponseProto createEmptyInstance() => create();
  static $pb.PbList<ItemResponseProto> createRepeated() =>
      $pb.PbList<ItemResponseProto>();
  @$core.pragma('dart2js:noInline')
  static ItemResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemResponseProto>(create);
  static ItemResponseProto? _defaultInstance;

  ItemResponseProto_ItemDetails whichItemDetails() =>
      _ItemResponseProto_ItemDetailsByTag[$_whichOneof(0)]!;
  void clearItemDetails() => $_clearField($_whichOneof(0));

  /// The type of the item, which determines which `item_details` oneof is set.
  @$pb.TagNumber(1)
  ItemTypeProto get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ItemTypeProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// The item's primary identifier (e.g., UPC, EAN).
  @$pb.TagNumber(2)
  $core.String get barcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set barcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarcode() => $_clearField(2);

  /// The primary, user-facing name of the item.
  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  /// A more detailed description of the item.
  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  /// The base price for a single unit of the item.
  @$pb.TagNumber(5)
  $1.MoneyProto get unitPrice => $_getN(4);
  @$pb.TagNumber(5)
  set unitPrice($1.MoneyProto value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitPrice() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.MoneyProto ensureUnitPrice() => $_ensure(4);

  /// The tax information applicable to this item.
  @$pb.TagNumber(6)
  $2.TaxProto get tax => $_getN(5);
  @$pb.TagNumber(6)
  set tax($2.TaxProto value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTax() => $_has(5);
  @$pb.TagNumber(6)
  void clearTax() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.TaxProto ensureTax() => $_ensure(5);

  /// A flag indicating if this item should be skipped during security weight checks.
  @$pb.TagNumber(7)
  $core.bool get passAroundItem => $_getBF(6);
  @$pb.TagNumber(7)
  set passAroundItem($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPassAroundItem() => $_has(6);
  @$pb.TagNumber(7)
  void clearPassAroundItem() => $_clearField(7);

  /// A flag indicating if the sale of this item requires unlocking from its box and verification.
  @$pb.TagNumber(8)
  $core.bool get lockedItem => $_getBF(7);
  @$pb.TagNumber(8)
  set lockedItem($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLockedItem() => $_has(7);
  @$pb.TagNumber(8)
  void clearLockedItem() => $_clearField(8);

  /// A flag indicating if the sale of this item requires age verification.
  @$pb.TagNumber(9)
  $core.bool get ageRestrictedItem => $_getBF(8);
  @$pb.TagNumber(9)
  set ageRestrictedItem($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAgeRestrictedItem() => $_has(8);
  @$pb.TagNumber(9)
  void clearAgeRestrictedItem() => $_clearField(9);

  @$pb.TagNumber(11)
  NormalItemDetailsProto get normalItem => $_getN(9);
  @$pb.TagNumber(11)
  set normalItem(NormalItemDetailsProto value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasNormalItem() => $_has(9);
  @$pb.TagNumber(11)
  void clearNormalItem() => $_clearField(11);
  @$pb.TagNumber(11)
  NormalItemDetailsProto ensureNormalItem() => $_ensure(9);

  @$pb.TagNumber(12)
  QuantityRequiredItemDetailsProto get quantityRequiredItem => $_getN(10);
  @$pb.TagNumber(12)
  set quantityRequiredItem(QuantityRequiredItemDetailsProto value) =>
      $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasQuantityRequiredItem() => $_has(10);
  @$pb.TagNumber(12)
  void clearQuantityRequiredItem() => $_clearField(12);
  @$pb.TagNumber(12)
  QuantityRequiredItemDetailsProto ensureQuantityRequiredItem() => $_ensure(10);

  @$pb.TagNumber(13)
  WeightEmbeddedItemDetailsProto get weightEmbeddedItem => $_getN(11);
  @$pb.TagNumber(13)
  set weightEmbeddedItem(WeightEmbeddedItemDetailsProto value) =>
      $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasWeightEmbeddedItem() => $_has(11);
  @$pb.TagNumber(13)
  void clearWeightEmbeddedItem() => $_clearField(13);
  @$pb.TagNumber(13)
  WeightEmbeddedItemDetailsProto ensureWeightEmbeddedItem() => $_ensure(11);

  @$pb.TagNumber(14)
  PriceEmbeddedItemDetailsProto get priceEmbeddedItem => $_getN(12);
  @$pb.TagNumber(14)
  set priceEmbeddedItem(PriceEmbeddedItemDetailsProto value) =>
      $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPriceEmbeddedItem() => $_has(12);
  @$pb.TagNumber(14)
  void clearPriceEmbeddedItem() => $_clearField(14);
  @$pb.TagNumber(14)
  PriceEmbeddedItemDetailsProto ensurePriceEmbeddedItem() => $_ensure(12);

  @$pb.TagNumber(15)
  WeightRequiredItemDetailsProto get weightRequiredItem => $_getN(13);
  @$pb.TagNumber(15)
  set weightRequiredItem(WeightRequiredItemDetailsProto value) =>
      $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasWeightRequiredItem() => $_has(13);
  @$pb.TagNumber(15)
  void clearWeightRequiredItem() => $_clearField(15);
  @$pb.TagNumber(15)
  WeightRequiredItemDetailsProto ensureWeightRequiredItem() => $_ensure(13);
}

/// *
///  Request to retrieve item details using a barcode.
class GetItemRequestProto extends $pb.GeneratedMessage {
  factory GetItemRequestProto({
    $core.String? posTxId,
    $core.String? barcode,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (barcode != null) result.barcode = barcode;
    return result;
  }

  GetItemRequestProto._();

  factory GetItemRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetItemRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetItemRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOS(2, _omitFieldNames ? '' : 'barcode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemRequestProto clone() => GetItemRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemRequestProto copyWith(void Function(GetItemRequestProto) updates) =>
      super.copyWith((message) => updates(message as GetItemRequestProto))
          as GetItemRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetItemRequestProto create() => GetItemRequestProto._();
  @$core.override
  GetItemRequestProto createEmptyInstance() => create();
  static $pb.PbList<GetItemRequestProto> createRepeated() =>
      $pb.PbList<GetItemRequestProto>();
  @$core.pragma('dart2js:noInline')
  static GetItemRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetItemRequestProto>(create);
  static GetItemRequestProto? _defaultInstance;

  /// The ID of the transaction this request is part of.
  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  /// The barcode of the item to look up.
  @$pb.TagNumber(2)
  $core.String get barcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set barcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarcode() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
