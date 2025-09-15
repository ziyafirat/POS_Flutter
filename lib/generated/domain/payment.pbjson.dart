// This is a generated file - do not edit.
//
// Generated from domain/payment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use paymentProtoDescriptor instead')
const PaymentProto$json = {
  '1': 'PaymentProto',
  '2': [
    {
      '1': 'tender',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.domain.TenderProto',
      '10': 'tender'
    },
    {
      '1': 'amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'amount'
    },
  ],
};

/// Descriptor for `PaymentProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentProtoDescriptor = $convert.base64Decode(
    'CgxQYXltZW50UHJvdG8SKwoGdGVuZGVyGAEgASgLMhMuZG9tYWluLlRlbmRlclByb3RvUgZ0ZW'
    '5kZXISKgoGYW1vdW50GAIgASgLMhIuY29tbW9uLk1vbmV5UHJvdG9SBmFtb3VudA==');
