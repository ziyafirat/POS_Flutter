// This is a generated file - do not edit.
//
// Generated from domain/totals.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use totalsProtoDescriptor instead')
const TotalsProto$json = {
  '1': 'TotalsProto',
  '2': [
    {
      '1': 'sub_total',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'subTotal'
    },
    {
      '1': 'discount_total',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'discountTotal'
    },
    {
      '1': 'grand_total',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'grandTotal'
    },
    {
      '1': 'tax_total',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'taxTotal'
    },
    {
      '1': 'balance_due',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.common.MoneyProto',
      '10': 'balanceDue'
    },
    {'1': 'count_of_items', '3': 6, '4': 1, '5': 5, '10': 'countOfItems'},
    {
      '1': 'payments',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.domain.PaymentProto',
      '10': 'payments'
    },
  ],
};

/// Descriptor for `TotalsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totalsProtoDescriptor = $convert.base64Decode(
    'CgtUb3RhbHNQcm90bxIvCglzdWJfdG90YWwYASABKAsyEi5jb21tb24uTW9uZXlQcm90b1IIc3'
    'ViVG90YWwSOQoOZGlzY291bnRfdG90YWwYAiABKAsyEi5jb21tb24uTW9uZXlQcm90b1INZGlz'
    'Y291bnRUb3RhbBIzCgtncmFuZF90b3RhbBgDIAEoCzISLmNvbW1vbi5Nb25leVByb3RvUgpncm'
    'FuZFRvdGFsEi8KCXRheF90b3RhbBgEIAEoCzISLmNvbW1vbi5Nb25leVByb3RvUgh0YXhUb3Rh'
    'bBIzCgtiYWxhbmNlX2R1ZRgFIAEoCzISLmNvbW1vbi5Nb25leVByb3RvUgpiYWxhbmNlRHVlEi'
    'QKDmNvdW50X29mX2l0ZW1zGAYgASgFUgxjb3VudE9mSXRlbXMSMAoIcGF5bWVudHMYByADKAsy'
    'FC5kb21haW4uUGF5bWVudFByb3RvUghwYXltZW50cw==');

@$core.Deprecated('Use totalsResponseProtoDescriptor instead')
const TotalsResponseProto$json = {
  '1': 'TotalsResponseProto',
  '2': [
    {
      '1': 'totals',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.domain.TotalsProto',
      '10': 'totals'
    },
  ],
};

/// Descriptor for `TotalsResponseProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totalsResponseProtoDescriptor = $convert.base64Decode(
    'ChNUb3RhbHNSZXNwb25zZVByb3RvEisKBnRvdGFscxgBIAEoCzITLmRvbWFpbi5Ub3RhbHNQcm'
    '90b1IGdG90YWxz');
