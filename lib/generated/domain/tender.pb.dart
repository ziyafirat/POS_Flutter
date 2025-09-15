// This is a generated file - do not edit.
//
// Generated from domain/tender.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum TenderProto_TenderType { staticDetails, interactiveDetails, notSet }

/// *
///  Represents a method of payment (e.g., cash, credit card).
class TenderProto extends $pb.GeneratedMessage {
  factory TenderProto({
    $core.String? tenderId,
    $core.String? tenderDescription,
    $core.String? extraInfo,
    $core.bool? requiresCardToScanOnCancelTransaction,
    StaticTenderDetails? staticDetails,
    InteractiveTenderDetails? interactiveDetails,
  }) {
    final result = create();
    if (tenderId != null) result.tenderId = tenderId;
    if (tenderDescription != null) result.tenderDescription = tenderDescription;
    if (extraInfo != null) result.extraInfo = extraInfo;
    if (requiresCardToScanOnCancelTransaction != null)
      result.requiresCardToScanOnCancelTransaction =
          requiresCardToScanOnCancelTransaction;
    if (staticDetails != null) result.staticDetails = staticDetails;
    if (interactiveDetails != null)
      result.interactiveDetails = interactiveDetails;
    return result;
  }

  TenderProto._();

  factory TenderProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TenderProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TenderProto_TenderType>
      _TenderProto_TenderTypeByTag = {
    10: TenderProto_TenderType.staticDetails,
    11: TenderProto_TenderType.interactiveDetails,
    0: TenderProto_TenderType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TenderProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aOS(1, _omitFieldNames ? '' : 'tenderId')
    ..aOS(2, _omitFieldNames ? '' : 'tenderDescription')
    ..aOS(3, _omitFieldNames ? '' : 'extraInfo')
    ..aOB(4, _omitFieldNames ? '' : 'requiresCardToScanOnCancelTransaction')
    ..aOM<StaticTenderDetails>(10, _omitFieldNames ? '' : 'staticDetails',
        subBuilder: StaticTenderDetails.create)
    ..aOM<InteractiveTenderDetails>(
        11, _omitFieldNames ? '' : 'interactiveDetails',
        subBuilder: InteractiveTenderDetails.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TenderProto clone() => TenderProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TenderProto copyWith(void Function(TenderProto) updates) =>
      super.copyWith((message) => updates(message as TenderProto))
          as TenderProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TenderProto create() => TenderProto._();
  @$core.override
  TenderProto createEmptyInstance() => create();
  static $pb.PbList<TenderProto> createRepeated() => $pb.PbList<TenderProto>();
  @$core.pragma('dart2js:noInline')
  static TenderProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TenderProto>(create);
  static TenderProto? _defaultInstance;

  TenderProto_TenderType whichTenderType() =>
      _TenderProto_TenderTypeByTag[$_whichOneof(0)]!;
  void clearTenderType() => $_clearField($_whichOneof(0));

  /// The unique identifier for this tender type.
  @$pb.TagNumber(1)
  $core.String get tenderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tenderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenderId() => $_clearField(1);

  /// A human-readable name for the tender, suitable for UI display (e.g., "Visa Credit").
  @$pb.TagNumber(2)
  $core.String get tenderDescription => $_getSZ(1);
  @$pb.TagNumber(2)
  set tenderDescription($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTenderDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearTenderDescription() => $_clearField(2);

  /// Any additional, unstructured information about the tender.
  @$pb.TagNumber(3)
  $core.String get extraInfo => $_getSZ(2);
  @$pb.TagNumber(3)
  set extraInfo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExtraInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtraInfo() => $_clearField(3);

  /// Requires cars to scan on cancellation of the transaction. UI should behave accordingly.
  @$pb.TagNumber(4)
  $core.bool get requiresCardToScanOnCancelTransaction => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresCardToScanOnCancelTransaction($core.bool value) =>
      $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiresCardToScanOnCancelTransaction() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresCardToScanOnCancelTransaction() => $_clearField(4);

  /// Details for a standard, non-interactive tender.
  @$pb.TagNumber(10)
  StaticTenderDetails get staticDetails => $_getN(4);
  @$pb.TagNumber(10)
  set staticDetails(StaticTenderDetails value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStaticDetails() => $_has(4);
  @$pb.TagNumber(10)
  void clearStaticDetails() => $_clearField(10);
  @$pb.TagNumber(10)
  StaticTenderDetails ensureStaticDetails() => $_ensure(4);

  /// Details for a tender that requires a multi-step, interactive flow.
  @$pb.TagNumber(11)
  InteractiveTenderDetails get interactiveDetails => $_getN(5);
  @$pb.TagNumber(11)
  set interactiveDetails(InteractiveTenderDetails value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasInteractiveDetails() => $_has(5);
  @$pb.TagNumber(11)
  void clearInteractiveDetails() => $_clearField(11);
  @$pb.TagNumber(11)
  InteractiveTenderDetails ensureInteractiveDetails() => $_ensure(5);
}

/// *
///  Defines the properties of a simple, single-step tender.
class StaticTenderDetails extends $pb.GeneratedMessage {
  factory StaticTenderDetails({
    $core.bool? requireOtp,
    $core.bool? requirePin,
    $core.bool? allowPartialPayment,
  }) {
    final result = create();
    if (requireOtp != null) result.requireOtp = requireOtp;
    if (requirePin != null) result.requirePin = requirePin;
    if (allowPartialPayment != null)
      result.allowPartialPayment = allowPartialPayment;
    return result;
  }

  StaticTenderDetails._();

  factory StaticTenderDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StaticTenderDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StaticTenderDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'requireOtp')
    ..aOB(2, _omitFieldNames ? '' : 'requirePin')
    ..aOB(3, _omitFieldNames ? '' : 'allowPartialPayment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaticTenderDetails clone() => StaticTenderDetails()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaticTenderDetails copyWith(void Function(StaticTenderDetails) updates) =>
      super.copyWith((message) => updates(message as StaticTenderDetails))
          as StaticTenderDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StaticTenderDetails create() => StaticTenderDetails._();
  @$core.override
  StaticTenderDetails createEmptyInstance() => create();
  static $pb.PbList<StaticTenderDetails> createRepeated() =>
      $pb.PbList<StaticTenderDetails>();
  @$core.pragma('dart2js:noInline')
  static StaticTenderDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StaticTenderDetails>(create);
  static StaticTenderDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get requireOtp => $_getBF(0);
  @$pb.TagNumber(1)
  set requireOtp($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequireOtp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequireOtp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get requirePin => $_getBF(1);
  @$pb.TagNumber(2)
  set requirePin($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequirePin() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequirePin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get allowPartialPayment => $_getBF(2);
  @$pb.TagNumber(3)
  set allowPartialPayment($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllowPartialPayment() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowPartialPayment() => $_clearField(3);
}

/// *
///  Placeholder for details specific to interactive (multi-step) tenders.
class InteractiveTenderDetails extends $pb.GeneratedMessage {
  factory InteractiveTenderDetails() => create();

  InteractiveTenderDetails._();

  factory InteractiveTenderDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InteractiveTenderDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InteractiveTenderDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractiveTenderDetails clone() =>
      InteractiveTenderDetails()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractiveTenderDetails copyWith(
          void Function(InteractiveTenderDetails) updates) =>
      super.copyWith((message) => updates(message as InteractiveTenderDetails))
          as InteractiveTenderDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InteractiveTenderDetails create() => InteractiveTenderDetails._();
  @$core.override
  InteractiveTenderDetails createEmptyInstance() => create();
  static $pb.PbList<InteractiveTenderDetails> createRepeated() =>
      $pb.PbList<InteractiveTenderDetails>();
  @$core.pragma('dart2js:noInline')
  static InteractiveTenderDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InteractiveTenderDetails>(create);
  static InteractiveTenderDetails? _defaultInstance;
}

/// *
///  A response message containing a list of available tenders.
class GetTendersResponseProto extends $pb.GeneratedMessage {
  factory GetTendersResponseProto({
    $core.Iterable<TenderProto>? tenders,
  }) {
    final result = create();
    if (tenders != null) result.tenders.addAll(tenders);
    return result;
  }

  GetTendersResponseProto._();

  factory GetTendersResponseProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTendersResponseProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTendersResponseProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..pc<TenderProto>(1, _omitFieldNames ? '' : 'tenders', $pb.PbFieldType.PM,
        subBuilder: TenderProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTendersResponseProto clone() =>
      GetTendersResponseProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTendersResponseProto copyWith(
          void Function(GetTendersResponseProto) updates) =>
      super.copyWith((message) => updates(message as GetTendersResponseProto))
          as GetTendersResponseProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTendersResponseProto create() => GetTendersResponseProto._();
  @$core.override
  GetTendersResponseProto createEmptyInstance() => create();
  static $pb.PbList<GetTendersResponseProto> createRepeated() =>
      $pb.PbList<GetTendersResponseProto>();
  @$core.pragma('dart2js:noInline')
  static GetTendersResponseProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTendersResponseProto>(create);
  static GetTendersResponseProto? _defaultInstance;

  /// A list of all tenders available for the current transaction.
  @$pb.TagNumber(1)
  $pb.PbList<TenderProto> get tenders => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
