// This is a generated file - do not edit.
//
// Generated from domain/line_item.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use quantityBasedDetailsProtoDescriptor instead')
const QuantityBasedDetailsProto$json = {
  '1': 'QuantityBasedDetailsProto',
  '2': [
    {'1': 'quantity', '3': 1, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `QuantityBasedDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quantityBasedDetailsProtoDescriptor =
    $convert.base64Decode(
        'ChlRdWFudGl0eUJhc2VkRGV0YWlsc1Byb3RvEhoKCHF1YW50aXR5GAEgASgFUghxdWFudGl0eQ'
        '==');

@$core.Deprecated('Use weightBasedDetailsProtoDescriptor instead')
const WeightBasedDetailsProto$json = {
  '1': 'WeightBasedDetailsProto',
  '2': [
    {
      '1': 'weight',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '10': 'weight'
    },
  ],
};

/// Descriptor for `WeightBasedDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightBasedDetailsProtoDescriptor =
    $convert.base64Decode(
        'ChdXZWlnaHRCYXNlZERldGFpbHNQcm90bxIrCgZ3ZWlnaHQYASABKAsyEy5jb21tb24uV2VpZ2'
        'h0UHJvdG9SBndlaWdodA==');

@$core.Deprecated('Use lineItemResponseProtoDescriptor instead')
const LineItemResponseProto$json = {
  '1': 'LineItemResponseProto',
  '2': [
    {'1': 'pos_line_item_id', '3': 1, '4': 1, '5': 9, '10': 'posLineItemId'},
    {'1': 'barcode', '3': 2, '4': 1, '5': 9, '10': 'barcode'},
    {
      '1': 'item',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.domain.ItemResponseProto',
      '10': 'item'
    },
    {
      '1': 'effective_unit_price',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'effectiveUnitPrice'
    },
    {
      '1': 'extended_price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'extendedPrice'
    },
    {
      '1': 'applied_campaigns',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.domain.CampaignProto',
      '10': 'appliedCampaigns'
    },
    {'1': 'is_voided', '3': 7, '4': 1, '5': 8, '10': 'isVoided'},
    {
      '1': 'quantity_based',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.domain.QuantityBasedDetailsProto',
      '9': 0,
      '10': 'quantityBased'
    },
    {
      '1': 'weight_based',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.domain.WeightBasedDetailsProto',
      '9': 0,
      '10': 'weightBased'
    },
  ],
  '8': [
    {'1': 'line_item_type'},
  ],
};

/// Descriptor for `LineItemResponseProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineItemResponseProtoDescriptor = $convert.base64Decode(
    'ChVMaW5lSXRlbVJlc3BvbnNlUHJvdG8SJwoQcG9zX2xpbmVfaXRlbV9pZBgBIAEoCVINcG9zTG'
    'luZUl0ZW1JZBIYCgdiYXJjb2RlGAIgASgJUgdiYXJjb2RlEi0KBGl0ZW0YAyABKAsyGS5kb21h'
    'aW4uSXRlbVJlc3BvbnNlUHJvdG9SBGl0ZW0SRAoUZWZmZWN0aXZlX3VuaXRfcHJpY2UYBCABKA'
    'syEi5jb21tb24uTW9uZXlQcm90b1ISZWZmZWN0aXZlVW5pdFByaWNlEjkKDmV4dGVuZGVkX3By'
    'aWNlGAUgASgLMhIuY29tbW9uLk1vbmV5UHJvdG9SDWV4dGVuZGVkUHJpY2USQgoRYXBwbGllZF'
    '9jYW1wYWlnbnMYBiADKAsyFS5kb21haW4uQ2FtcGFpZ25Qcm90b1IQYXBwbGllZENhbXBhaWdu'
    'cxIbCglpc192b2lkZWQYByABKAhSCGlzVm9pZGVkEkoKDnF1YW50aXR5X2Jhc2VkGAsgASgLMi'
    'EuZG9tYWluLlF1YW50aXR5QmFzZWREZXRhaWxzUHJvdG9IAFINcXVhbnRpdHlCYXNlZBJECgx3'
    'ZWlnaHRfYmFzZWQYDCABKAsyHy5kb21haW4uV2VpZ2h0QmFzZWREZXRhaWxzUHJvdG9IAFILd2'
    'VpZ2h0QmFzZWRCEAoObGluZV9pdGVtX3R5cGU=');

@$core.Deprecated('Use addItemByQuantityRequestProtoDescriptor instead')
const AddItemByQuantityRequestProto$json = {
  '1': 'AddItemByQuantityRequestProto',
  '2': [
    {'1': 'pos_tx_id', '3': 1, '4': 1, '5': 9, '10': 'posTxId'},
    {'1': 'barcode', '3': 2, '4': 1, '5': 9, '10': 'barcode'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `AddItemByQuantityRequestProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemByQuantityRequestProtoDescriptor =
    $convert.base64Decode(
        'Ch1BZGRJdGVtQnlRdWFudGl0eVJlcXVlc3RQcm90bxIaCglwb3NfdHhfaWQYASABKAlSB3Bvc1'
        'R4SWQSGAoHYmFyY29kZRgCIAEoCVIHYmFyY29kZRIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRp'
        'dHk=');

@$core.Deprecated('Use addItemByWeightRequestProtoDescriptor instead')
const AddItemByWeightRequestProto$json = {
  '1': 'AddItemByWeightRequestProto',
  '2': [
    {'1': 'pos_tx_id', '3': 1, '4': 1, '5': 9, '10': 'posTxId'},
    {'1': 'barcode', '3': 2, '4': 1, '5': 9, '10': 'barcode'},
    {
      '1': 'weight',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '10': 'weight'
    },
  ],
};

/// Descriptor for `AddItemByWeightRequestProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemByWeightRequestProtoDescriptor =
    $convert.base64Decode(
        'ChtBZGRJdGVtQnlXZWlnaHRSZXF1ZXN0UHJvdG8SGgoJcG9zX3R4X2lkGAEgASgJUgdwb3NUeE'
        'lkEhgKB2JhcmNvZGUYAiABKAlSB2JhcmNvZGUSKwoGd2VpZ2h0GAMgASgLMhMuY29tbW9uLldl'
        'aWdodFByb3RvUgZ3ZWlnaHQ=');
