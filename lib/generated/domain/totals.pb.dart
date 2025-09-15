// This is a generated file - do not edit.
//
// Generated from domain/totals.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/money.pb.dart' as $0;
import 'payment.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents the complete financial totals for a transaction.
class TotalsProto extends $pb.GeneratedMessage {
  factory TotalsProto({
    $0.MoneyProto? subTotal,
    $0.MoneyProto? discountTotal,
    $0.MoneyProto? grandTotal,
    $0.MoneyProto? taxTotal,
    $0.MoneyProto? balanceDue,
    $core.int? countOfItems,
    $core.Iterable<$1.PaymentProto>? payments,
  }) {
    final result = create();
    if (subTotal != null) result.subTotal = subTotal;
    if (discountTotal != null) result.discountTotal = discountTotal;
    if (grandTotal != null) result.grandTotal = grandTotal;
    if (taxTotal != null) result.taxTotal = taxTotal;
    if (balanceDue != null) result.balanceDue = balanceDue;
    if (countOfItems != null) result.countOfItems = countOfItems;
    if (payments != null) result.payments.addAll(payments);
    return result;
  }

  TotalsProto._();

  factory TotalsProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TotalsProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TotalsProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<$0.MoneyProto>(1, _omitFieldNames ? '' : 'subTotal',
        subBuilder: $0.MoneyProto.create)
    ..aOM<$0.MoneyProto>(2, _omitFieldNames ? '' : 'discountTotal',
        subBuilder: $0.MoneyProto.create)
    ..aOM<$0.MoneyProto>(3, _omitFieldNames ? '' : 'grandTotal',
        subBuilder: $0.MoneyProto.create)
    ..aOM<$0.MoneyProto>(4, _omitFieldNames ? '' : 'taxTotal',
        subBuilder: $0.MoneyProto.create)
    ..aOM<$0.MoneyProto>(5, _omitFieldNames ? '' : 'balanceDue',
        subBuilder: $0.MoneyProto.create)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'countOfItems', $pb.PbFieldType.O3)
    ..pc<$1.PaymentProto>(
        7, _omitFieldNames ? '' : 'payments', $pb.PbFieldType.PM,
        subBuilder: $1.PaymentProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalsProto clone() => TotalsProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalsProto copyWith(void Function(TotalsProto) updates) =>
      super.copyWith((message) => updates(message as TotalsProto))
          as TotalsProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TotalsProto create() => TotalsProto._();
  @$core.override
  TotalsProto createEmptyInstance() => create();
  static $pb.PbList<TotalsProto> createRepeated() => $pb.PbList<TotalsProto>();
  @$core.pragma('dart2js:noInline')
  static TotalsProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TotalsProto>(create);
  static TotalsProto? _defaultInstance;

  /// The sum of all line item extended prices before discounts and taxes.
  @$pb.TagNumber(1)
  $0.MoneyProto get subTotal => $_getN(0);
  @$pb.TagNumber(1)
  set subTotal($0.MoneyProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubTotal() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.MoneyProto ensureSubTotal() => $_ensure(0);

  /// The total value of all discounts.
  @$pb.TagNumber(2)
  $0.MoneyProto get discountTotal => $_getN(1);
  @$pb.TagNumber(2)
  set discountTotal($0.MoneyProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDiscountTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiscountTotal() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.MoneyProto ensureDiscountTotal() => $_ensure(1);

  /// The final amount payable by the customer (sub_total - discount_total + tax_total).
  @$pb.TagNumber(3)
  $0.MoneyProto get grandTotal => $_getN(2);
  @$pb.TagNumber(3)
  set grandTotal($0.MoneyProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGrandTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrandTotal() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.MoneyProto ensureGrandTotal() => $_ensure(2);

  /// The total value of all taxes.
  @$pb.TagNumber(4)
  $0.MoneyProto get taxTotal => $_getN(3);
  @$pb.TagNumber(4)
  set taxTotal($0.MoneyProto value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTaxTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaxTotal() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.MoneyProto ensureTaxTotal() => $_ensure(3);

  /// The remaining amount that still needs to be paid.
  @$pb.TagNumber(5)
  $0.MoneyProto get balanceDue => $_getN(4);
  @$pb.TagNumber(5)
  set balanceDue($0.MoneyProto value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBalanceDue() => $_has(4);
  @$pb.TagNumber(5)
  void clearBalanceDue() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.MoneyProto ensureBalanceDue() => $_ensure(4);

  /// The total number of individual items in the basket.
  @$pb.TagNumber(6)
  $core.int get countOfItems => $_getIZ(5);
  @$pb.TagNumber(6)
  set countOfItems($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCountOfItems() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountOfItems() => $_clearField(6);

  /// A list of all payments that have been applied to the transaction so far.
  @$pb.TagNumber(7)
  $pb.PbList<$1.PaymentProto> get payments => $_getList(6);
}

/// *
///  The response wrapper for a GetTotals RPC call.
class TotalsResponseProto extends $pb.GeneratedMessage {
  factory TotalsResponseProto({
    TotalsProto? totals,
  }) {
    final result = create();
    if (totals != null) result.totals = totals;
    return result;
  }

  TotalsResponseProto._();

  factory TotalsResponseProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TotalsResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TotalsResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<TotalsProto>(1, _omitFieldNames ? '' : 'totals',
        subBuilder: TotalsProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalsResponseProto clone() => TotalsResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalsResponseProto copyWith(void Function(TotalsResponseProto) updates) =>
      super.copyWith((message) => updates(message as TotalsResponseProto))
          as TotalsResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TotalsResponseProto create() => TotalsResponseProto._();
  @$core.override
  TotalsResponseProto createEmptyInstance() => create();
  static $pb.PbList<TotalsResponseProto> createRepeated() =>
      $pb.PbList<TotalsResponseProto>();
  @$core.pragma('dart2js:noInline')
  static TotalsResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TotalsResponseProto>(create);
  static TotalsResponseProto? _defaultInstance;

  @$pb.TagNumber(1)
  TotalsProto get totals => $_getN(0);
  @$pb.TagNumber(1)
  set totals(TotalsProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotals() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotals() => $_clearField(1);
  @$pb.TagNumber(1)
  TotalsProto ensureTotals() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
