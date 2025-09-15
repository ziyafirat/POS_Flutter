// This is a generated file - do not edit.
//
// Generated from domain/line_item.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/money.pb.dart' as $2;
import '../common/weight.pb.dart' as $0;
import 'campaign.pb.dart' as $3;
import 'item.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Details for a line item sold by quantity.
class QuantityBasedDetailsProto extends $pb.GeneratedMessage {
  factory QuantityBasedDetailsProto({
    $core.int? quantity,
  }) {
    final result = create();
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  QuantityBasedDetailsProto._();

  factory QuantityBasedDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuantityBasedDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuantityBasedDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuantityBasedDetailsProto clone() =>
      QuantityBasedDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuantityBasedDetailsProto copyWith(
          void Function(QuantityBasedDetailsProto) updates) =>
      super.copyWith((message) => updates(message as QuantityBasedDetailsProto))
          as QuantityBasedDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuantityBasedDetailsProto create() => QuantityBasedDetailsProto._();
  @$core.override
  QuantityBasedDetailsProto createEmptyInstance() => create();
  static $pb.PbList<QuantityBasedDetailsProto> createRepeated() =>
      $pb.PbList<QuantityBasedDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static QuantityBasedDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuantityBasedDetailsProto>(create);
  static QuantityBasedDetailsProto? _defaultInstance;

  /// The number of units for this line item.
  @$pb.TagNumber(1)
  $core.int get quantity => $_getIZ(0);
  @$pb.TagNumber(1)
  set quantity($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuantity() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuantity() => $_clearField(1);
}

/// *
///  Details for a line item sold by weight.
class WeightBasedDetailsProto extends $pb.GeneratedMessage {
  factory WeightBasedDetailsProto({
    $0.WeightProto? weight,
  }) {
    final result = create();
    if (weight != null) result.weight = weight;
    return result;
  }

  WeightBasedDetailsProto._();

  factory WeightBasedDetailsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeightBasedDetailsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WeightBasedDetailsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$0.WeightProto>(1, _omitFieldNames ? '' : 'weight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightBasedDetailsProto clone() =>
      WeightBasedDetailsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeightBasedDetailsProto copyWith(
          void Function(WeightBasedDetailsProto) updates) =>
      super.copyWith((message) => updates(message as WeightBasedDetailsProto))
          as WeightBasedDetailsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeightBasedDetailsProto create() => WeightBasedDetailsProto._();
  @$core.override
  WeightBasedDetailsProto createEmptyInstance() => create();
  static $pb.PbList<WeightBasedDetailsProto> createRepeated() =>
      $pb.PbList<WeightBasedDetailsProto>();
  @$core.pragma('dart2js:noInline')
  static WeightBasedDetailsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeightBasedDetailsProto>(create);
  static WeightBasedDetailsProto? _defaultInstance;

  /// The measured weight for this line item.
  @$pb.TagNumber(1)
  $0.WeightProto get weight => $_getN(0);
  @$pb.TagNumber(1)
  set weight($0.WeightProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearWeight() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.WeightProto ensureWeight() => $_ensure(0);
}

enum LineItemResponseProto_LineItemType { quantityBased, weightBased, notSet }

/// *
///  Represents a single line item within a transaction basket.
class LineItemResponseProto extends $pb.GeneratedMessage {
  factory LineItemResponseProto({
    $core.String? posLineItemId,
    $core.String? barcode,
    $1.ItemResponseProto? item,
    $2.MoneyProto? effectiveUnitPrice,
    $2.MoneyProto? extendedPrice,
    $core.Iterable<$3.CampaignProto>? appliedCampaigns,
    $core.bool? isVoided,
    QuantityBasedDetailsProto? quantityBased,
    WeightBasedDetailsProto? weightBased,
  }) {
    final result = create();
    if (posLineItemId != null) result.posLineItemId = posLineItemId;
    if (barcode != null) result.barcode = barcode;
    if (item != null) result.item = item;
    if (effectiveUnitPrice != null)
      result.effectiveUnitPrice = effectiveUnitPrice;
    if (extendedPrice != null) result.extendedPrice = extendedPrice;
    if (appliedCampaigns != null)
      result.appliedCampaigns.addAll(appliedCampaigns);
    if (isVoided != null) result.isVoided = isVoided;
    if (quantityBased != null) result.quantityBased = quantityBased;
    if (weightBased != null) result.weightBased = weightBased;
    return result;
  }

  LineItemResponseProto._();

  factory LineItemResponseProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LineItemResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, LineItemResponseProto_LineItemType>
      _LineItemResponseProto_LineItemTypeByTag = {
    11: LineItemResponseProto_LineItemType.quantityBased,
    12: LineItemResponseProto_LineItemType.weightBased,
    0: LineItemResponseProto_LineItemType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LineItemResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [11, 12])
    ..aOS(1, _omitFieldNames ? '' : 'posLineItemId')
    ..aOS(2, _omitFieldNames ? '' : 'barcode')
    ..aOM<$1.ItemResponseProto>(3, _omitFieldNames ? '' : 'item',
        subBuilder: $1.ItemResponseProto.create)
    ..aOM<$2.MoneyProto>(4, _omitFieldNames ? '' : 'effectiveUnitPrice',
        subBuilder: $2.MoneyProto.create)
    ..aOM<$2.MoneyProto>(5, _omitFieldNames ? '' : 'extendedPrice',
        subBuilder: $2.MoneyProto.create)
    ..pc<$3.CampaignProto>(
        6, _omitFieldNames ? '' : 'appliedCampaigns', $pb.PbFieldType.PM,
        subBuilder: $3.CampaignProto.create)
    ..aOB(7, _omitFieldNames ? '' : 'isVoided')
    ..aOM<QuantityBasedDetailsProto>(11, _omitFieldNames ? '' : 'quantityBased',
        subBuilder: QuantityBasedDetailsProto.create)
    ..aOM<WeightBasedDetailsProto>(12, _omitFieldNames ? '' : 'weightBased',
        subBuilder: WeightBasedDetailsProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineItemResponseProto clone() =>
      LineItemResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineItemResponseProto copyWith(
          void Function(LineItemResponseProto) updates) =>
      super.copyWith((message) => updates(message as LineItemResponseProto))
          as LineItemResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LineItemResponseProto create() => LineItemResponseProto._();
  @$core.override
  LineItemResponseProto createEmptyInstance() => create();
  static $pb.PbList<LineItemResponseProto> createRepeated() =>
      $pb.PbList<LineItemResponseProto>();
  @$core.pragma('dart2js:noInline')
  static LineItemResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LineItemResponseProto>(create);
  static LineItemResponseProto? _defaultInstance;

  LineItemResponseProto_LineItemType whichLineItemType() =>
      _LineItemResponseProto_LineItemTypeByTag[$_whichOneof(0)]!;
  void clearLineItemType() => $_clearField($_whichOneof(0));

  /// A unique ID for this specific line item instance within the transaction.
  @$pb.TagNumber(1)
  $core.String get posLineItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posLineItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosLineItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosLineItemId() => $_clearField(1);

  /// The barcode of the item associated with this line.
  @$pb.TagNumber(2)
  $core.String get barcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set barcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarcode() => $_clearField(2);

  /// The full catalog details of the item. See `domain/item.proto`.
  @$pb.TagNumber(3)
  $1.ItemResponseProto get item => $_getN(2);
  @$pb.TagNumber(3)
  set item($1.ItemResponseProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearItem() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.ItemResponseProto ensureItem() => $_ensure(2);

  /// The price per unit after any applicable item-level discounts.
  @$pb.TagNumber(4)
  $2.MoneyProto get effectiveUnitPrice => $_getN(3);
  @$pb.TagNumber(4)
  set effectiveUnitPrice($2.MoneyProto value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEffectiveUnitPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearEffectiveUnitPrice() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.MoneyProto ensureEffectiveUnitPrice() => $_ensure(3);

  /// The total price for this line item (effective_unit_price * quantity/weight).
  @$pb.TagNumber(5)
  $2.MoneyProto get extendedPrice => $_getN(4);
  @$pb.TagNumber(5)
  set extendedPrice($2.MoneyProto value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExtendedPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtendedPrice() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.MoneyProto ensureExtendedPrice() => $_ensure(4);

  /// A list of all promotional campaigns applied to this line item.
  @$pb.TagNumber(6)
  $pb.PbList<$3.CampaignProto> get appliedCampaigns => $_getList(5);

  /// A flag indicating if this line item has been voided.
  @$pb.TagNumber(7)
  $core.bool get isVoided => $_getBF(6);
  @$pb.TagNumber(7)
  set isVoided($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsVoided() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsVoided() => $_clearField(7);

  @$pb.TagNumber(11)
  QuantityBasedDetailsProto get quantityBased => $_getN(7);
  @$pb.TagNumber(11)
  set quantityBased(QuantityBasedDetailsProto value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasQuantityBased() => $_has(7);
  @$pb.TagNumber(11)
  void clearQuantityBased() => $_clearField(11);
  @$pb.TagNumber(11)
  QuantityBasedDetailsProto ensureQuantityBased() => $_ensure(7);

  @$pb.TagNumber(12)
  WeightBasedDetailsProto get weightBased => $_getN(8);
  @$pb.TagNumber(12)
  set weightBased(WeightBasedDetailsProto value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasWeightBased() => $_has(8);
  @$pb.TagNumber(12)
  void clearWeightBased() => $_clearField(12);
  @$pb.TagNumber(12)
  WeightBasedDetailsProto ensureWeightBased() => $_ensure(8);
}

/// *
///  Request to add a quantity-based item to the transaction.
class AddItemByQuantityRequestProto extends $pb.GeneratedMessage {
  factory AddItemByQuantityRequestProto({
    $core.String? posTxId,
    $core.String? barcode,
    $core.int? quantity,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (barcode != null) result.barcode = barcode;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  AddItemByQuantityRequestProto._();

  factory AddItemByQuantityRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemByQuantityRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemByQuantityRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOS(2, _omitFieldNames ? '' : 'barcode')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemByQuantityRequestProto clone() =>
      AddItemByQuantityRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemByQuantityRequestProto copyWith(
          void Function(AddItemByQuantityRequestProto) updates) =>
      super.copyWith(
              (message) => updates(message as AddItemByQuantityRequestProto))
          as AddItemByQuantityRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemByQuantityRequestProto create() =>
      AddItemByQuantityRequestProto._();
  @$core.override
  AddItemByQuantityRequestProto createEmptyInstance() => create();
  static $pb.PbList<AddItemByQuantityRequestProto> createRepeated() =>
      $pb.PbList<AddItemByQuantityRequestProto>();
  @$core.pragma('dart2js:noInline')
  static AddItemByQuantityRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemByQuantityRequestProto>(create);
  static AddItemByQuantityRequestProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get barcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set barcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarcode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);
}

/// *
///  Request to add a weight-based item to the transaction.
class AddItemByWeightRequestProto extends $pb.GeneratedMessage {
  factory AddItemByWeightRequestProto({
    $core.String? posTxId,
    $core.String? barcode,
    $0.WeightProto? weight,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (barcode != null) result.barcode = barcode;
    if (weight != null) result.weight = weight;
    return result;
  }

  AddItemByWeightRequestProto._();

  factory AddItemByWeightRequestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemByWeightRequestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemByWeightRequestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOS(2, _omitFieldNames ? '' : 'barcode')
    ..aOM<$0.WeightProto>(3, _omitFieldNames ? '' : 'weight',
        subBuilder: $0.WeightProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemByWeightRequestProto clone() =>
      AddItemByWeightRequestProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemByWeightRequestProto copyWith(
          void Function(AddItemByWeightRequestProto) updates) =>
      super.copyWith(
              (message) => updates(message as AddItemByWeightRequestProto))
          as AddItemByWeightRequestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemByWeightRequestProto create() =>
      AddItemByWeightRequestProto._();
  @$core.override
  AddItemByWeightRequestProto createEmptyInstance() => create();
  static $pb.PbList<AddItemByWeightRequestProto> createRepeated() =>
      $pb.PbList<AddItemByWeightRequestProto>();
  @$core.pragma('dart2js:noInline')
  static AddItemByWeightRequestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemByWeightRequestProto>(create);
  static AddItemByWeightRequestProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get barcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set barcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarcode() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.WeightProto get weight => $_getN(2);
  @$pb.TagNumber(3)
  set weight($0.WeightProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.WeightProto ensureWeight() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
