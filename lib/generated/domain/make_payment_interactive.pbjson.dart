// This is a generated file - do not edit.
//
// Generated from domain/make_payment_interactive.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use clientPaymentActionProtoDescriptor instead')
const ClientPaymentActionProto$json = {
  '1': 'ClientPaymentActionProto',
  '2': [
    {
      '1': 'interaction_attempt_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'interactionAttemptId'
    },
    {
      '1': 'start_payment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.StartPaymentProto',
      '9': 0,
      '10': 'startPayment'
    },
    {
      '1': 'prompt_result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.domain.PromptResultProto',
      '9': 0,
      '10': 'promptResult'
    },
  ],
  '8': [
    {'1': 'action_type'},
  ],
};

/// Descriptor for `ClientPaymentActionProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientPaymentActionProtoDescriptor = $convert.base64Decode(
    'ChhDbGllbnRQYXltZW50QWN0aW9uUHJvdG8SNAoWaW50ZXJhY3Rpb25fYXR0ZW1wdF9pZBgBIA'
    'EoCVIUaW50ZXJhY3Rpb25BdHRlbXB0SWQSQAoNc3RhcnRfcGF5bWVudBgCIAEoCzIZLmRvbWFp'
    'bi5TdGFydFBheW1lbnRQcm90b0gAUgxzdGFydFBheW1lbnQSQAoNcHJvbXB0X3Jlc3VsdBgDIA'
    'EoCzIZLmRvbWFpbi5Qcm9tcHRSZXN1bHRQcm90b0gAUgxwcm9tcHRSZXN1bHRCDQoLYWN0aW9u'
    'X3R5cGU=');

@$core.Deprecated('Use startPaymentProtoDescriptor instead')
const StartPaymentProto$json = {
  '1': 'StartPaymentProto',
  '2': [
    {'1': 'pos_tx_id', '3': 1, '4': 1, '5': 9, '10': 'posTxId'},
    {
      '1': 'payment_details',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.PaymentProto',
      '10': 'paymentDetails'
    },
  ],
};

/// Descriptor for `StartPaymentProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPaymentProtoDescriptor = $convert.base64Decode(
    'ChFTdGFydFBheW1lbnRQcm90bxIaCglwb3NfdHhfaWQYASABKAlSB3Bvc1R4SWQSPQoPcGF5bW'
    'VudF9kZXRhaWxzGAIgASgLMhQuZG9tYWluLlBheW1lbnRQcm90b1IOcGF5bWVudERldGFpbHM=');

@$core.Deprecated('Use serverActionProtoDescriptor instead')
const ServerActionProto$json = {
  '1': 'ServerActionProto',
  '2': [
    {
      '1': 'interaction_attempt_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'interactionAttemptId'
    },
    {
      '1': 'prompt',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.PromptProto',
      '9': 0,
      '10': 'prompt'
    },
    {
      '1': 'completion_status',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.domain.CompletionStatusProto',
      '9': 0,
      '10': 'completionStatus'
    },
    {
      '1': 'close_prompt',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.domain.ClosePromptProto',
      '9': 0,
      '10': 'closePrompt'
    },
  ],
  '8': [
    {'1': 'action_type'},
  ],
};

/// Descriptor for `ServerActionProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverActionProtoDescriptor = $convert.base64Decode(
    'ChFTZXJ2ZXJBY3Rpb25Qcm90bxI0ChZpbnRlcmFjdGlvbl9hdHRlbXB0X2lkGAEgASgJUhRpbn'
    'RlcmFjdGlvbkF0dGVtcHRJZBItCgZwcm9tcHQYAiABKAsyEy5kb21haW4uUHJvbXB0UHJvdG9I'
    'AFIGcHJvbXB0EkwKEWNvbXBsZXRpb25fc3RhdHVzGAMgASgLMh0uZG9tYWluLkNvbXBsZXRpb2'
    '5TdGF0dXNQcm90b0gAUhBjb21wbGV0aW9uU3RhdHVzEj0KDGNsb3NlX3Byb21wdBgEIAEoCzIY'
    'LmRvbWFpbi5DbG9zZVByb21wdFByb3RvSABSC2Nsb3NlUHJvbXB0Qg0KC2FjdGlvbl90eXBl');

@$core.Deprecated('Use closePromptProtoDescriptor instead')
const ClosePromptProto$json = {
  '1': 'ClosePromptProto',
  '2': [
    {'1': 'prompt_id', '3': 1, '4': 1, '5': 9, '10': 'promptId'},
  ],
};

/// Descriptor for `ClosePromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closePromptProtoDescriptor = $convert.base64Decode(
    'ChBDbG9zZVByb21wdFByb3RvEhsKCXByb21wdF9pZBgBIAEoCVIIcHJvbXB0SWQ=');

@$core.Deprecated('Use completionStatusProtoDescriptor instead')
const CompletionStatusProto$json = {
  '1': 'CompletionStatusProto',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'final_message', '3': 2, '4': 1, '5': 9, '10': 'finalMessage'},
  ],
};

/// Descriptor for `CompletionStatusProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completionStatusProtoDescriptor = $convert.base64Decode(
    'ChVDb21wbGV0aW9uU3RhdHVzUHJvdG8SGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1maW'
    '5hbF9tZXNzYWdlGAIgASgJUgxmaW5hbE1lc3NhZ2U=');
