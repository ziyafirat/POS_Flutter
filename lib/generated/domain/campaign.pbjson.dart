// This is a generated file - do not edit.
//
// Generated from domain/campaign.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use campaignProtoDescriptor instead')
const CampaignProto$json = {
  '1': 'CampaignProto',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'campaign_name', '3': 2, '4': 1, '5': 9, '10': 'campaignName'},
    {
      '1': 'discount_amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'discountAmount'
    },
  ],
};

/// Descriptor for `CampaignProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignProtoDescriptor = $convert.base64Decode(
    'Cg1DYW1wYWlnblByb3RvEh8KC2NhbXBhaWduX2lkGAEgASgJUgpjYW1wYWlnbklkEiMKDWNhbX'
    'BhaWduX25hbWUYAiABKAlSDGNhbXBhaWduTmFtZRI7Cg9kaXNjb3VudF9hbW91bnQYAyABKAsy'
    'Ei5jb21tb24uTW9uZXlQcm90b1IOZGlzY291bnRBbW91bnQ=');
