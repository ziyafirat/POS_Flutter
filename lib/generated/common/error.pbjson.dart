// This is a generated file - do not edit.
//
// Generated from common/error.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use businessErrorProtoDescriptor instead')
const BusinessErrorProto$json = {
  '1': 'BusinessErrorProto',
  '2': [
    {'1': 'errCode', '3': 1, '4': 1, '5': 9, '10': 'errCode'},
    {'1': 'errMessage', '3': 2, '4': 1, '5': 9, '10': 'errMessage'},
  ],
};

/// Descriptor for `BusinessErrorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List businessErrorProtoDescriptor = $convert.base64Decode(
    'ChJCdXNpbmVzc0Vycm9yUHJvdG8SGAoHZXJyQ29kZRgBIAEoCVIHZXJyQ29kZRIeCgplcnJNZX'
    'NzYWdlGAIgASgJUgplcnJNZXNzYWdl');

@$core.Deprecated('Use clientErrorDetailsProtoDescriptor instead')
const ClientErrorDetailsProto$json = {
  '1': 'ClientErrorDetailsProto',
  '2': [
    {'1': 'exception_class', '3': 1, '4': 1, '5': 9, '10': 'exceptionClass'},
    {
      '1': 'exception_message',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'exceptionMessage'
    },
  ],
};

/// Descriptor for `ClientErrorDetailsProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientErrorDetailsProtoDescriptor = $convert.base64Decode(
    'ChdDbGllbnRFcnJvckRldGFpbHNQcm90bxInCg9leGNlcHRpb25fY2xhc3MYASABKAlSDmV4Y2'
    'VwdGlvbkNsYXNzEisKEWV4Y2VwdGlvbl9tZXNzYWdlGAIgASgJUhBleGNlcHRpb25NZXNzYWdl');
