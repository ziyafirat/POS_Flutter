// This is a generated file - do not edit.
//
// Generated from domain/tender.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use tenderProtoDescriptor instead')
const TenderProto$json = {
  '1': 'TenderProto',
  '2': [
    {'1': 'tender_id', '3': 1, '4': 1, '5': 9, '10': 'tenderId'},
    {
      '1': 'tender_description',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'tenderDescription'
    },
    {'1': 'extra_info', '3': 3, '4': 1, '5': 9, '10': 'extraInfo'},
    {
      '1': 'requires_card_to_scan_on_cancel_transaction',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'requiresCardToScanOnCancelTransaction'
    },
    {
      '1': 'static_details',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.domain.StaticTenderDetails',
      '9': 0,
      '10': 'staticDetails'
    },
    {
      '1': 'interactive_details',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.domain.InteractiveTenderDetails',
      '9': 0,
      '10': 'interactiveDetails'
    },
  ],
  '8': [
    {'1': 'tender_type'},
  ],
};

/// Descriptor for `TenderProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tenderProtoDescriptor = $convert.base64Decode(
    'CgtUZW5kZXJQcm90bxIbCgl0ZW5kZXJfaWQYASABKAlSCHRlbmRlcklkEi0KEnRlbmRlcl9kZX'
    'NjcmlwdGlvbhgCIAEoCVIRdGVuZGVyRGVzY3JpcHRpb24SHQoKZXh0cmFfaW5mbxgDIAEoCVIJ'
    'ZXh0cmFJbmZvEloKK3JlcXVpcmVzX2NhcmRfdG9fc2Nhbl9vbl9jYW5jZWxfdHJhbnNhY3Rpb2'
    '4YBCABKAhSJXJlcXVpcmVzQ2FyZFRvU2Nhbk9uQ2FuY2VsVHJhbnNhY3Rpb24SRAoOc3RhdGlj'
    'X2RldGFpbHMYCiABKAsyGy5kb21haW4uU3RhdGljVGVuZGVyRGV0YWlsc0gAUg1zdGF0aWNEZX'
    'RhaWxzElMKE2ludGVyYWN0aXZlX2RldGFpbHMYCyABKAsyIC5kb21haW4uSW50ZXJhY3RpdmVU'
    'ZW5kZXJEZXRhaWxzSABSEmludGVyYWN0aXZlRGV0YWlsc0INCgt0ZW5kZXJfdHlwZQ==');

@$core.Deprecated('Use staticTenderDetailsDescriptor instead')
const StaticTenderDetails$json = {
  '1': 'StaticTenderDetails',
  '2': [
    {'1': 'require_otp', '3': 1, '4': 1, '5': 8, '10': 'requireOtp'},
    {'1': 'require_pin', '3': 2, '4': 1, '5': 8, '10': 'requirePin'},
    {
      '1': 'allow_partial_payment',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'allowPartialPayment'
    },
  ],
};

/// Descriptor for `StaticTenderDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List staticTenderDetailsDescriptor = $convert.base64Decode(
    'ChNTdGF0aWNUZW5kZXJEZXRhaWxzEh8KC3JlcXVpcmVfb3RwGAEgASgIUgpyZXF1aXJlT3RwEh'
    '8KC3JlcXVpcmVfcGluGAIgASgIUgpyZXF1aXJlUGluEjIKFWFsbG93X3BhcnRpYWxfcGF5bWVu'
    'dBgDIAEoCFITYWxsb3dQYXJ0aWFsUGF5bWVudA==');

@$core.Deprecated('Use interactiveTenderDetailsDescriptor instead')
const InteractiveTenderDetails$json = {
  '1': 'InteractiveTenderDetails',
};

/// Descriptor for `InteractiveTenderDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interactiveTenderDetailsDescriptor =
    $convert.base64Decode('ChhJbnRlcmFjdGl2ZVRlbmRlckRldGFpbHM=');

@$core.Deprecated('Use getTendersResponseProtoDescriptor instead')
const GetTendersResponseProto$json = {
  '1': 'GetTendersResponseProto',
  '2': [
    {
      '1': 'tenders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.domain.TenderProto',
      '10': 'tenders'
    },
  ],
};

/// Descriptor for `GetTendersResponseProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTendersResponseProtoDescriptor =
    $convert.base64Decode(
        'ChdHZXRUZW5kZXJzUmVzcG9uc2VQcm90bxItCgd0ZW5kZXJzGAEgAygLMhMuZG9tYWluLlRlbm'
        'RlclByb3RvUgd0ZW5kZXJz');
