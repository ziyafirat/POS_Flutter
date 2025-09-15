// This is a generated file - do not edit.
//
// Generated from domain/make_payment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use makePaymentRequestProtoDescriptor instead')
const MakePaymentRequestProto$json = {
  '1': 'MakePaymentRequestProto',
  '2': [
    {'1': 'pos_tx_id', '3': 1, '4': 1, '5': 9, '10': 'posTxId'},
    {
      '1': 'payment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.PaymentProto',
      '10': 'payment'
    },
  ],
};

/// Descriptor for `MakePaymentRequestProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List makePaymentRequestProtoDescriptor =
    $convert.base64Decode(
        'ChdNYWtlUGF5bWVudFJlcXVlc3RQcm90bxIaCglwb3NfdHhfaWQYASABKAlSB3Bvc1R4SWQSLg'
        'oHcGF5bWVudBgCIAEoCzIULmRvbWFpbi5QYXltZW50UHJvdG9SB3BheW1lbnQ=');
