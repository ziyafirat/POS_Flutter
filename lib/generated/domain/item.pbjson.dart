// This is a generated file - do not edit.
//
// Generated from domain/item.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use itemTypeProtoDescriptor instead')
const ItemTypeProto$json = {
  '1': 'ItemTypeProto',
  '2': [
    {'1': 'ITEM_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NORMAL', '2': 1},
    {'1': 'QUANTITY_REQUIRED', '2': 2},
    {'1': 'WEIGHT_REQUIRED', '2': 3},
    {'1': 'WEIGHT_EMBEDDED', '2': 4},
    {'1': 'PRICE_EMBEDDED', '2': 5},
  ],
};

/// Descriptor for `ItemTypeProto`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List itemTypeProtoDescriptor = $convert.base64Decode(
    'Cg1JdGVtVHlwZVByb3RvEhkKFUlURU1fVFlQRV9VTlNQRUNJRklFRBAAEgoKBk5PUk1BTBABEh'
    'UKEVFVQU5USVRZX1JFUVVJUkVEEAISEwoPV0VJR0hUX1JFUVVJUkVEEAMSEwoPV0VJR0hUX0VN'
    'QkVEREVEEAQSEgoOUFJJQ0VfRU1CRURERUQQBQ==');

@$core.Deprecated('Use normalItemDetailsProtoDescriptor instead')
const NormalItemDetailsProto$json = {
  '1': 'NormalItemDetailsProto',
  '2': [
    {
      '1': 'defined_weight',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '9': 0,
      '10': 'definedWeight',
      '17': true
    },
  ],
  '8': [
    {'1': '_defined_weight'},
  ],
};

/// Descriptor for `NormalItemDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List normalItemDetailsProtoDescriptor = $convert.base64Decode(
    'ChZOb3JtYWxJdGVtRGV0YWlsc1Byb3RvEj8KDmRlZmluZWRfd2VpZ2h0GAEgASgLMhMuY29tbW'
    '9uLldlaWdodFByb3RvSABSDWRlZmluZWRXZWlnaHSIAQFCEQoPX2RlZmluZWRfd2VpZ2h0');

@$core.Deprecated('Use quantityRequiredItemDetailsProtoDescriptor instead')
const QuantityRequiredItemDetailsProto$json = {
  '1': 'QuantityRequiredItemDetailsProto',
  '2': [
    {
      '1': 'min_quantity',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'minQuantity',
      '17': true
    },
    {
      '1': 'max_quantity',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'maxQuantity',
      '17': true
    },
    {
      '1': 'defined_weight',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '9': 2,
      '10': 'definedWeight',
      '17': true
    },
  ],
  '8': [
    {'1': '_min_quantity'},
    {'1': '_max_quantity'},
    {'1': '_defined_weight'},
  ],
};

/// Descriptor for `QuantityRequiredItemDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quantityRequiredItemDetailsProtoDescriptor = $convert.base64Decode(
    'CiBRdWFudGl0eVJlcXVpcmVkSXRlbURldGFpbHNQcm90bxImCgxtaW5fcXVhbnRpdHkYASABKA'
    'VIAFILbWluUXVhbnRpdHmIAQESJgoMbWF4X3F1YW50aXR5GAIgASgFSAFSC21heFF1YW50aXR5'
    'iAEBEj8KDmRlZmluZWRfd2VpZ2h0GAMgASgLMhMuY29tbW9uLldlaWdodFByb3RvSAJSDWRlZm'
    'luZWRXZWlnaHSIAQFCDwoNX21pbl9xdWFudGl0eUIPCg1fbWF4X3F1YW50aXR5QhEKD19kZWZp'
    'bmVkX3dlaWdodA==');

@$core.Deprecated('Use weightEmbeddedItemDetailsProtoDescriptor instead')
const WeightEmbeddedItemDetailsProto$json = {
  '1': 'WeightEmbeddedItemDetailsProto',
  '2': [
    {
      '1': 'embedded_weight',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '10': 'embeddedWeight'
    },
  ],
};

/// Descriptor for `WeightEmbeddedItemDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightEmbeddedItemDetailsProtoDescriptor =
    $convert.base64Decode(
        'Ch5XZWlnaHRFbWJlZGRlZEl0ZW1EZXRhaWxzUHJvdG8SPAoPZW1iZWRkZWRfd2VpZ2h0GAEgAS'
        'gLMhMuY29tbW9uLldlaWdodFByb3RvUg5lbWJlZGRlZFdlaWdodA==');

@$core.Deprecated('Use priceEmbeddedItemDetailsProtoDescriptor instead')
const PriceEmbeddedItemDetailsProto$json = {
  '1': 'PriceEmbeddedItemDetailsProto',
  '2': [
    {
      '1': 'embedded_price',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'embeddedPrice'
    },
    {
      '1': 'calculated_weight',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.common.WeightProto',
      '10': 'calculatedWeight'
    },
  ],
};

/// Descriptor for `PriceEmbeddedItemDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List priceEmbeddedItemDetailsProtoDescriptor =
    $convert.base64Decode(
        'Ch1QcmljZUVtYmVkZGVkSXRlbURldGFpbHNQcm90bxI5Cg5lbWJlZGRlZF9wcmljZRgBIAEoCz'
        'ISLmNvbW1vbi5Nb25leVByb3RvUg1lbWJlZGRlZFByaWNlEkAKEWNhbGN1bGF0ZWRfd2VpZ2h0'
        'GAIgASgLMhMuY29tbW9uLldlaWdodFByb3RvUhBjYWxjdWxhdGVkV2VpZ2h0');

@$core.Deprecated('Use weightRequiredItemDetailsProtoDescriptor instead')
const WeightRequiredItemDetailsProto$json = {
  '1': 'WeightRequiredItemDetailsProto',
};

/// Descriptor for `WeightRequiredItemDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weightRequiredItemDetailsProtoDescriptor =
    $convert.base64Decode('Ch5XZWlnaHRSZXF1aXJlZEl0ZW1EZXRhaWxzUHJvdG8=');

@$core.Deprecated('Use itemResponseProtoDescriptor instead')
const ItemResponseProto$json = {
  '1': 'ItemResponseProto',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.domain.ItemTypeProto',
      '10': 'type'
    },
    {'1': 'barcode', '3': 2, '4': 1, '5': 9, '10': 'barcode'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'unit_price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'unitPrice'
    },
    {'1': 'tax', '3': 6, '4': 1, '5': 11, '6': '.common.TaxProto', '10': 'tax'},
    {'1': 'pass_around_item', '3': 7, '4': 1, '5': 8, '10': 'passAroundItem'},
    {'1': 'locked_item', '3': 8, '4': 1, '5': 8, '10': 'lockedItem'},
    {
      '1': 'age_restricted_item',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'ageRestrictedItem'
    },
    {
      '1': 'normal_item',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.domain.NormalItemDetailsProto',
      '9': 0,
      '10': 'normalItem'
    },
    {
      '1': 'quantity_required_item',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.domain.QuantityRequiredItemDetailsProto',
      '9': 0,
      '10': 'quantityRequiredItem'
    },
    {
      '1': 'weight_embedded_item',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.domain.WeightEmbeddedItemDetailsProto',
      '9': 0,
      '10': 'weightEmbeddedItem'
    },
    {
      '1': 'price_embedded_item',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.domain.PriceEmbeddedItemDetailsProto',
      '9': 0,
      '10': 'priceEmbeddedItem'
    },
    {
      '1': 'weight_required_item',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.domain.WeightRequiredItemDetailsProto',
      '9': 0,
      '10': 'weightRequiredItem'
    },
  ],
  '8': [
    {'1': 'item_details'},
  ],
};

/// Descriptor for `ItemResponseProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemResponseProtoDescriptor = $convert.base64Decode(
    'ChFJdGVtUmVzcG9uc2VQcm90bxIpCgR0eXBlGAEgASgOMhUuZG9tYWluLkl0ZW1UeXBlUHJvdG'
    '9SBHR5cGUSGAoHYmFyY29kZRgCIAEoCVIHYmFyY29kZRISCgRuYW1lGAMgASgJUgRuYW1lEiAK'
    'C2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIxCgp1bml0X3ByaWNlGAUgASgLMhIuY2'
    '9tbW9uLk1vbmV5UHJvdG9SCXVuaXRQcmljZRIiCgN0YXgYBiABKAsyEC5jb21tb24uVGF4UHJv'
    'dG9SA3RheBIoChBwYXNzX2Fyb3VuZF9pdGVtGAcgASgIUg5wYXNzQXJvdW5kSXRlbRIfCgtsb2'
    'NrZWRfaXRlbRgIIAEoCFIKbG9ja2VkSXRlbRIuChNhZ2VfcmVzdHJpY3RlZF9pdGVtGAkgASgI'
    'UhFhZ2VSZXN0cmljdGVkSXRlbRJBCgtub3JtYWxfaXRlbRgLIAEoCzIeLmRvbWFpbi5Ob3JtYW'
    'xJdGVtRGV0YWlsc1Byb3RvSABSCm5vcm1hbEl0ZW0SYAoWcXVhbnRpdHlfcmVxdWlyZWRfaXRl'
    'bRgMIAEoCzIoLmRvbWFpbi5RdWFudGl0eVJlcXVpcmVkSXRlbURldGFpbHNQcm90b0gAUhRxdW'
    'FudGl0eVJlcXVpcmVkSXRlbRJaChR3ZWlnaHRfZW1iZWRkZWRfaXRlbRgNIAEoCzImLmRvbWFp'
    'bi5XZWlnaHRFbWJlZGRlZEl0ZW1EZXRhaWxzUHJvdG9IAFISd2VpZ2h0RW1iZWRkZWRJdGVtEl'
    'cKE3ByaWNlX2VtYmVkZGVkX2l0ZW0YDiABKAsyJS5kb21haW4uUHJpY2VFbWJlZGRlZEl0ZW1E'
    'ZXRhaWxzUHJvdG9IAFIRcHJpY2VFbWJlZGRlZEl0ZW0SWgoUd2VpZ2h0X3JlcXVpcmVkX2l0ZW'
    '0YDyABKAsyJi5kb21haW4uV2VpZ2h0UmVxdWlyZWRJdGVtRGV0YWlsc1Byb3RvSABSEndlaWdo'
    'dFJlcXVpcmVkSXRlbUIOCgxpdGVtX2RldGFpbHM=');

@$core.Deprecated('Use getItemRequestProtoDescriptor instead')
const GetItemRequestProto$json = {
  '1': 'GetItemRequestProto',
  '2': [
    {'1': 'pos_tx_id', '3': 1, '4': 1, '5': 9, '10': 'posTxId'},
    {'1': 'barcode', '3': 2, '4': 1, '5': 9, '10': 'barcode'},
  ],
};

/// Descriptor for `GetItemRequestProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getItemRequestProtoDescriptor = $convert.base64Decode(
    'ChNHZXRJdGVtUmVxdWVzdFByb3RvEhoKCXBvc190eF9pZBgBIAEoCVIHcG9zVHhJZBIYCgdiYX'
    'Jjb2RlGAIgASgJUgdiYXJjb2Rl');
