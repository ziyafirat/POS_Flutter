// This is a generated file - do not edit.
//
// Generated from domain/campaign.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/money.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// *
///  Represents a promotional campaign or discount applied to a line item.
class CampaignProto extends $pb.GeneratedMessage {
  factory CampaignProto({
    $core.String? campaignId,
    $core.String? campaignName,
    $0.MoneyProto? discountAmount,
  }) {
    final result = create();
    if (campaignId != null) result.campaignId = campaignId;
    if (campaignName != null) result.campaignName = campaignName;
    if (discountAmount != null) result.discountAmount = discountAmount;
    return result;
  }

  CampaignProto._();

  factory CampaignProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CampaignProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignName')
    ..aOM<$0.MoneyProto>(3, _omitFieldNames ? '' : 'discountAmount',
        subBuilder: $0.MoneyProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignProto clone() => CampaignProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignProto copyWith(void Function(CampaignProto) updates) =>
      super.copyWith((message) => updates(message as CampaignProto))
          as CampaignProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CampaignProto create() => CampaignProto._();
  @$core.override
  CampaignProto createEmptyInstance() => create();
  static $pb.PbList<CampaignProto> createRepeated() =>
      $pb.PbList<CampaignProto>();
  @$core.pragma('dart2js:noInline')
  static CampaignProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignProto>(create);
  static CampaignProto? _defaultInstance;

  /// The unique identifier for the campaign.
  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  /// The human-readable name of the campaign, suitable for display.
  @$pb.TagNumber(2)
  $core.String get campaignName => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignName() => $_clearField(2);

  /// The monetary value of the discount applied by this campaign.
  @$pb.TagNumber(3)
  $0.MoneyProto get discountAmount => $_getN(2);
  @$pb.TagNumber(3)
  set discountAmount($0.MoneyProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscountAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.MoneyProto ensureDiscountAmount() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
