// This is a generated file - do not edit.
//
// Generated from domain/interaction_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use promptProtoDescriptor instead')
const PromptProto$json = {
  '1': 'PromptProto',
  '2': [
    {'1': 'prompt_id', '3': 1, '4': 1, '5': 9, '10': 'promptId'},
    {'1': 'message_text', '3': 2, '4': 1, '5': 9, '10': 'messageText'},
    {
      '1': 'status_text',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'statusText',
      '17': true
    },
    {
      '1': 'title_text',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'titleText',
      '17': true
    },
    {
      '1': 'timeout_seconds',
      '3': 5,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'timeoutSeconds',
      '17': true
    },
    {
      '1': 'confirmation_prompt',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.domain.ConfirmationPromptProto',
      '9': 0,
      '10': 'confirmationPrompt'
    },
    {
      '1': 'date_prompt',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.domain.DateTimePromptProto',
      '9': 0,
      '10': 'datePrompt'
    },
    {
      '1': 'money_prompt',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.domain.MoneyPromptProto',
      '9': 0,
      '10': 'moneyPrompt'
    },
    {
      '1': 'number_prompt',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.domain.NumberPromptProto',
      '9': 0,
      '10': 'numberPrompt'
    },
    {
      '1': 'select_one_prompt',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.domain.SelectOnePromptProto',
      '9': 0,
      '10': 'selectOnePrompt'
    },
    {
      '1': 'string_prompt',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.domain.StringPromptProto',
      '9': 0,
      '10': 'stringPrompt'
    },
  ],
  '8': [
    {'1': 'prompt_type'},
    {'1': '_status_text'},
    {'1': '_title_text'},
    {'1': '_timeout_seconds'},
  ],
};

/// Descriptor for `PromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promptProtoDescriptor = $convert.base64Decode(
    'CgtQcm9tcHRQcm90bxIbCglwcm9tcHRfaWQYASABKAlSCHByb21wdElkEiEKDG1lc3NhZ2VfdG'
    'V4dBgCIAEoCVILbWVzc2FnZVRleHQSJAoLc3RhdHVzX3RleHQYAyABKAlIAVIKc3RhdHVzVGV4'
    'dIgBARIiCgp0aXRsZV90ZXh0GAQgASgJSAJSCXRpdGxlVGV4dIgBARIsCg90aW1lb3V0X3NlY2'
    '9uZHMYBSABKAVIA1IOdGltZW91dFNlY29uZHOIAQESUgoTY29uZmlybWF0aW9uX3Byb21wdBgK'
    'IAEoCzIfLmRvbWFpbi5Db25maXJtYXRpb25Qcm9tcHRQcm90b0gAUhJjb25maXJtYXRpb25Qcm'
    '9tcHQSPgoLZGF0ZV9wcm9tcHQYCyABKAsyGy5kb21haW4uRGF0ZVRpbWVQcm9tcHRQcm90b0gA'
    'UgpkYXRlUHJvbXB0Ej0KDG1vbmV5X3Byb21wdBgNIAEoCzIYLmRvbWFpbi5Nb25leVByb21wdF'
    'Byb3RvSABSC21vbmV5UHJvbXB0EkAKDW51bWJlcl9wcm9tcHQYDiABKAsyGS5kb21haW4uTnVt'
    'YmVyUHJvbXB0UHJvdG9IAFIMbnVtYmVyUHJvbXB0EkoKEXNlbGVjdF9vbmVfcHJvbXB0GA8gAS'
    'gLMhwuZG9tYWluLlNlbGVjdE9uZVByb21wdFByb3RvSABSD3NlbGVjdE9uZVByb21wdBJACg1z'
    'dHJpbmdfcHJvbXB0GBAgASgLMhkuZG9tYWluLlN0cmluZ1Byb21wdFByb3RvSABSDHN0cmluZ1'
    'Byb21wdEINCgtwcm9tcHRfdHlwZUIOCgxfc3RhdHVzX3RleHRCDQoLX3RpdGxlX3RleHRCEgoQ'
    'X3RpbWVvdXRfc2Vjb25kcw==');

@$core.Deprecated('Use confirmationPromptProtoDescriptor instead')
const ConfirmationPromptProto$json = {
  '1': 'ConfirmationPromptProto',
  '2': [
    {'1': 'accept_enabled', '3': 1, '4': 1, '5': 8, '10': 'acceptEnabled'},
    {'1': 'reject_enabled', '3': 2, '4': 1, '5': 8, '10': 'rejectEnabled'},
    {'1': 'cancel_enabled', '3': 3, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'accept_label',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'acceptLabel',
      '17': true
    },
    {
      '1': 'reject_label',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'rejectLabel',
      '17': true
    },
    {
      '1': 'cancel_label',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'cancelLabel',
      '17': true
    },
  ],
  '8': [
    {'1': '_accept_label'},
    {'1': '_reject_label'},
    {'1': '_cancel_label'},
  ],
};

/// Descriptor for `ConfirmationPromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmationPromptProtoDescriptor = $convert.base64Decode(
    'ChdDb25maXJtYXRpb25Qcm9tcHRQcm90bxIlCg5hY2NlcHRfZW5hYmxlZBgBIAEoCFINYWNjZX'
    'B0RW5hYmxlZBIlCg5yZWplY3RfZW5hYmxlZBgCIAEoCFINcmVqZWN0RW5hYmxlZBIlCg5jYW5j'
    'ZWxfZW5hYmxlZBgDIAEoCFINY2FuY2VsRW5hYmxlZBImCgxhY2NlcHRfbGFiZWwYBCABKAlIAF'
    'ILYWNjZXB0TGFiZWyIAQESJgoMcmVqZWN0X2xhYmVsGAUgASgJSAFSC3JlamVjdExhYmVsiAEB'
    'EiYKDGNhbmNlbF9sYWJlbBgGIAEoCUgCUgtjYW5jZWxMYWJlbIgBAUIPCg1fYWNjZXB0X2xhYm'
    'VsQg8KDV9yZWplY3RfbGFiZWxCDwoNX2NhbmNlbF9sYWJlbA==');

@$core.Deprecated('Use dateTimePromptProtoDescriptor instead')
const DateTimePromptProto$json = {
  '1': 'DateTimePromptProto',
  '2': [
    {
      '1': 'date_format',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.domain.DateTimePromptProto.DateTimeFormat',
      '10': 'dateFormat'
    },
    {
      '1': 'min_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.SimpleDateTimeProto',
      '9': 0,
      '10': 'minDate',
      '17': true
    },
    {
      '1': 'max_date',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.domain.SimpleDateTimeProto',
      '9': 1,
      '10': 'maxDate',
      '17': true
    },
    {
      '1': 'ok_label',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'okLabel',
      '17': true
    },
    {'1': 'cancel_enabled', '3': 14, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'cancel_label',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'cancelLabel',
      '17': true
    },
    {
      '1': 'defaultValue',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.domain.SimpleDateTimeProto',
      '10': 'defaultValue'
    },
  ],
  '4': [DateTimePromptProto_DateTimeFormat$json],
  '8': [
    {'1': '_min_date'},
    {'1': '_max_date'},
    {'1': '_ok_label'},
    {'1': '_cancel_label'},
  ],
};

@$core.Deprecated('Use dateTimePromptProtoDescriptor instead')
const DateTimePromptProto_DateTimeFormat$json = {
  '1': 'DateTimeFormat',
  '2': [
    {'1': 'DATE_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'DDMMYYYY', '2': 1},
    {'1': 'MMDDYYYY', '2': 2},
    {'1': 'YYYYMMDD', '2': 3},
    {'1': 'DDMMYYYYHHMI', '2': 4},
    {'1': 'MMYYYY', '2': 5},
    {'1': 'HHMI', '2': 6},
  ],
};

/// Descriptor for `DateTimePromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateTimePromptProtoDescriptor = $convert.base64Decode(
    'ChNEYXRlVGltZVByb21wdFByb3RvEksKC2RhdGVfZm9ybWF0GAEgASgOMiouZG9tYWluLkRhdG'
    'VUaW1lUHJvbXB0UHJvdG8uRGF0ZVRpbWVGb3JtYXRSCmRhdGVGb3JtYXQSOwoIbWluX2RhdGUY'
    'AiABKAsyGy5kb21haW4uU2ltcGxlRGF0ZVRpbWVQcm90b0gAUgdtaW5EYXRliAEBEjsKCG1heF'
    '9kYXRlGAMgASgLMhsuZG9tYWluLlNpbXBsZURhdGVUaW1lUHJvdG9IAVIHbWF4RGF0ZYgBARIe'
    'Cghva19sYWJlbBgNIAEoCUgCUgdva0xhYmVsiAEBEiUKDmNhbmNlbF9lbmFibGVkGA4gASgIUg'
    '1jYW5jZWxFbmFibGVkEiYKDGNhbmNlbF9sYWJlbBgPIAEoCUgDUgtjYW5jZWxMYWJlbIgBARI/'
    'CgxkZWZhdWx0VmFsdWUYECABKAsyGy5kb21haW4uU2ltcGxlRGF0ZVRpbWVQcm90b1IMZGVmYX'
    'VsdFZhbHVlIn8KDkRhdGVUaW1lRm9ybWF0EhsKF0RBVEVfRk9STUFUX1VOU1BFQ0lGSUVEEAAS'
    'DAoIRERNTVlZWVkQARIMCghNTUREWVlZWRACEgwKCFlZWVlNTUREEAMSEAoMRERNTVlZWVlISE'
    '1JEAQSCgoGTU1ZWVlZEAUSCAoESEhNSRAGQgsKCV9taW5fZGF0ZUILCglfbWF4X2RhdGVCCwoJ'
    'X29rX2xhYmVsQg8KDV9jYW5jZWxfbGFiZWw=');

@$core.Deprecated('Use moneyPromptProtoDescriptor instead')
const MoneyPromptProto$json = {
  '1': 'MoneyPromptProto',
  '2': [
    {'1': 'currency_code', '3': 1, '4': 1, '5': 9, '10': 'currencyCode'},
    {'1': 'decimal_places', '3': 2, '4': 1, '5': 5, '10': 'decimalPlaces'},
    {
      '1': 'min_amount_in_lowest_denomination',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'minAmountInLowestDenomination',
      '17': true
    },
    {
      '1': 'max_amount_in_lowest_denomination',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'maxAmountInLowestDenomination',
      '17': true
    },
    {
      '1': 'ok_label',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'okLabel',
      '17': true
    },
    {'1': 'cancel_enabled', '3': 14, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'cancel_label',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'cancelLabel',
      '17': true
    },
    {
      '1': 'default_value',
      '3': 16,
      '4': 1,
      '5': 3,
      '9': 4,
      '10': 'defaultValue',
      '17': true
    },
  ],
  '8': [
    {'1': '_min_amount_in_lowest_denomination'},
    {'1': '_max_amount_in_lowest_denomination'},
    {'1': '_ok_label'},
    {'1': '_cancel_label'},
    {'1': '_default_value'},
  ],
};

/// Descriptor for `MoneyPromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyPromptProtoDescriptor = $convert.base64Decode(
    'ChBNb25leVByb21wdFByb3RvEiMKDWN1cnJlbmN5X2NvZGUYASABKAlSDGN1cnJlbmN5Q29kZR'
    'IlCg5kZWNpbWFsX3BsYWNlcxgCIAEoBVINZGVjaW1hbFBsYWNlcxJNCiFtaW5fYW1vdW50X2lu'
    'X2xvd2VzdF9kZW5vbWluYXRpb24YAyABKANIAFIdbWluQW1vdW50SW5Mb3dlc3REZW5vbWluYX'
    'Rpb26IAQESTQohbWF4X2Ftb3VudF9pbl9sb3dlc3RfZGVub21pbmF0aW9uGAQgASgDSAFSHW1h'
    'eEFtb3VudEluTG93ZXN0RGVub21pbmF0aW9uiAEBEh4KCG9rX2xhYmVsGA0gASgJSAJSB29rTG'
    'FiZWyIAQESJQoOY2FuY2VsX2VuYWJsZWQYDiABKAhSDWNhbmNlbEVuYWJsZWQSJgoMY2FuY2Vs'
    'X2xhYmVsGA8gASgJSANSC2NhbmNlbExhYmVsiAEBEigKDWRlZmF1bHRfdmFsdWUYECABKANIBF'
    'IMZGVmYXVsdFZhbHVliAEBQiQKIl9taW5fYW1vdW50X2luX2xvd2VzdF9kZW5vbWluYXRpb25C'
    'JAoiX21heF9hbW91bnRfaW5fbG93ZXN0X2Rlbm9taW5hdGlvbkILCglfb2tfbGFiZWxCDwoNX2'
    'NhbmNlbF9sYWJlbEIQCg5fZGVmYXVsdF92YWx1ZQ==');

@$core.Deprecated('Use numberPromptProtoDescriptor instead')
const NumberPromptProto$json = {
  '1': 'NumberPromptProto',
  '2': [
    {
      '1': 'min_digits',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'minDigits',
      '17': true
    },
    {
      '1': 'max_digits',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'maxDigits',
      '17': true
    },
    {'1': 'is_secret', '3': 3, '4': 1, '5': 8, '10': 'isSecret'},
    {
      '1': 'ok_label',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'okLabel',
      '17': true
    },
    {'1': 'cancel_enabled', '3': 14, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'cancel_label',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'cancelLabel',
      '17': true
    },
    {
      '1': 'default_value',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'defaultValue',
      '17': true
    },
  ],
  '8': [
    {'1': '_min_digits'},
    {'1': '_max_digits'},
    {'1': '_ok_label'},
    {'1': '_cancel_label'},
    {'1': '_default_value'},
  ],
};

/// Descriptor for `NumberPromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List numberPromptProtoDescriptor = $convert.base64Decode(
    'ChFOdW1iZXJQcm9tcHRQcm90bxIiCgptaW5fZGlnaXRzGAEgASgFSABSCW1pbkRpZ2l0c4gBAR'
    'IiCgptYXhfZGlnaXRzGAIgASgFSAFSCW1heERpZ2l0c4gBARIbCglpc19zZWNyZXQYAyABKAhS'
    'CGlzU2VjcmV0Eh4KCG9rX2xhYmVsGA0gASgJSAJSB29rTGFiZWyIAQESJQoOY2FuY2VsX2VuYW'
    'JsZWQYDiABKAhSDWNhbmNlbEVuYWJsZWQSJgoMY2FuY2VsX2xhYmVsGA8gASgJSANSC2NhbmNl'
    'bExhYmVsiAEBEigKDWRlZmF1bHRfdmFsdWUYECABKAlIBFIMZGVmYXVsdFZhbHVliAEBQg0KC1'
    '9taW5fZGlnaXRzQg0KC19tYXhfZGlnaXRzQgsKCV9va19sYWJlbEIPCg1fY2FuY2VsX2xhYmVs'
    'QhAKDl9kZWZhdWx0X3ZhbHVl');

@$core.Deprecated('Use selectOnePromptProtoDescriptor instead')
const SelectOnePromptProto$json = {
  '1': 'SelectOnePromptProto',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.domain.SelectOnePromptProto.Option',
      '10': 'options'
    },
    {'1': 'column_count', '3': 2, '4': 1, '5': 5, '10': 'columnCount'},
    {
      '1': 'delimited_column_header_texts',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'delimitedColumnHeaderTexts',
      '17': true
    },
    {
      '1': 'ok_label',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'okLabel',
      '17': true
    },
    {'1': 'cancel_enabled', '3': 14, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'cancel_label',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'cancelLabel',
      '17': true
    },
  ],
  '3': [SelectOnePromptProto_Option$json],
  '8': [
    {'1': '_delimited_column_header_texts'},
    {'1': '_ok_label'},
    {'1': '_cancel_label'},
  ],
};

@$core.Deprecated('Use selectOnePromptProtoDescriptor instead')
const SelectOnePromptProto_Option$json = {
  '1': 'Option',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'delimited_display_texts',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'delimitedDisplayTexts'
    },
  ],
};

/// Descriptor for `SelectOnePromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectOnePromptProtoDescriptor = $convert.base64Decode(
    'ChRTZWxlY3RPbmVQcm9tcHRQcm90bxI9CgdvcHRpb25zGAEgAygLMiMuZG9tYWluLlNlbGVjdE'
    '9uZVByb21wdFByb3RvLk9wdGlvblIHb3B0aW9ucxIhCgxjb2x1bW5fY291bnQYAiABKAVSC2Nv'
    'bHVtbkNvdW50EkYKHWRlbGltaXRlZF9jb2x1bW5faGVhZGVyX3RleHRzGAMgASgJSABSGmRlbG'
    'ltaXRlZENvbHVtbkhlYWRlclRleHRziAEBEh4KCG9rX2xhYmVsGA0gASgJSAFSB29rTGFiZWyI'
    'AQESJQoOY2FuY2VsX2VuYWJsZWQYDiABKAhSDWNhbmNlbEVuYWJsZWQSJgoMY2FuY2VsX2xhYm'
    'VsGA8gASgJSAJSC2NhbmNlbExhYmVsiAEBGlAKBk9wdGlvbhIOCgJpZBgBIAEoCVICaWQSNgoX'
    'ZGVsaW1pdGVkX2Rpc3BsYXlfdGV4dHMYAiABKAlSFWRlbGltaXRlZERpc3BsYXlUZXh0c0IgCh'
    '5fZGVsaW1pdGVkX2NvbHVtbl9oZWFkZXJfdGV4dHNCCwoJX29rX2xhYmVsQg8KDV9jYW5jZWxf'
    'bGFiZWw=');

@$core.Deprecated('Use stringPromptProtoDescriptor instead')
const StringPromptProto$json = {
  '1': 'StringPromptProto',
  '2': [
    {
      '1': 'min_length',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'minLength',
      '17': true
    },
    {
      '1': 'max_length',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'maxLength',
      '17': true
    },
    {'1': 'is_secret', '3': 3, '4': 1, '5': 8, '10': 'isSecret'},
    {
      '1': 'ok_label',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'okLabel',
      '17': true
    },
    {'1': 'cancel_enabled', '3': 14, '4': 1, '5': 8, '10': 'cancelEnabled'},
    {
      '1': 'cancel_label',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'cancelLabel',
      '17': true
    },
    {
      '1': 'default_value',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'defaultValue',
      '17': true
    },
  ],
  '8': [
    {'1': '_min_length'},
    {'1': '_max_length'},
    {'1': '_ok_label'},
    {'1': '_cancel_label'},
    {'1': '_default_value'},
  ],
};

/// Descriptor for `StringPromptProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringPromptProtoDescriptor = $convert.base64Decode(
    'ChFTdHJpbmdQcm9tcHRQcm90bxIiCgptaW5fbGVuZ3RoGAEgASgFSABSCW1pbkxlbmd0aIgBAR'
    'IiCgptYXhfbGVuZ3RoGAIgASgFSAFSCW1heExlbmd0aIgBARIbCglpc19zZWNyZXQYAyABKAhS'
    'CGlzU2VjcmV0Eh4KCG9rX2xhYmVsGA0gASgJSAJSB29rTGFiZWyIAQESJQoOY2FuY2VsX2VuYW'
    'JsZWQYDiABKAhSDWNhbmNlbEVuYWJsZWQSJgoMY2FuY2VsX2xhYmVsGA8gASgJSANSC2NhbmNl'
    'bExhYmVsiAEBEigKDWRlZmF1bHRfdmFsdWUYECABKAlIBFIMZGVmYXVsdFZhbHVliAEBQg0KC1'
    '9taW5fbGVuZ3RoQg0KC19tYXhfbGVuZ3RoQgsKCV9va19sYWJlbEIPCg1fY2FuY2VsX2xhYmVs'
    'QhAKDl9kZWZhdWx0X3ZhbHVl');

@$core.Deprecated('Use simpleDateTimeProtoDescriptor instead')
const SimpleDateTimeProto$json = {
  '1': 'SimpleDateTimeProto',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    {'1': 'day', '3': 3, '4': 1, '5': 5, '9': 0, '10': 'day', '17': true},
    {'1': 'hour', '3': 4, '4': 1, '5': 5, '9': 1, '10': 'hour', '17': true},
    {'1': 'minute', '3': 5, '4': 1, '5': 5, '9': 2, '10': 'minute', '17': true},
  ],
  '8': [
    {'1': '_day'},
    {'1': '_hour'},
    {'1': '_minute'},
  ],
};

/// Descriptor for `SimpleDateTimeProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simpleDateTimeProtoDescriptor = $convert.base64Decode(
    'ChNTaW1wbGVEYXRlVGltZVByb3RvEhIKBHllYXIYASABKAVSBHllYXISFAoFbW9udGgYAiABKA'
    'VSBW1vbnRoEhUKA2RheRgDIAEoBUgAUgNkYXmIAQESFwoEaG91chgEIAEoBUgBUgRob3VyiAEB'
    'EhsKBm1pbnV0ZRgFIAEoBUgCUgZtaW51dGWIAQFCBgoEX2RheUIHCgVfaG91ckIJCgdfbWludX'
    'Rl');

@$core.Deprecated('Use promptResultProtoDescriptor instead')
const PromptResultProto$json = {
  '1': 'PromptResultProto',
  '2': [
    {'1': 'prompt_id', '3': 1, '4': 1, '5': 9, '10': 'promptId'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.ResultValueProto',
      '9': 0,
      '10': 'value'
    },
    {'1': 'cancelled', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'cancelled'},
  ],
  '8': [
    {'1': 'outcome'},
  ],
};

/// Descriptor for `PromptResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promptResultProtoDescriptor = $convert.base64Decode(
    'ChFQcm9tcHRSZXN1bHRQcm90bxIbCglwcm9tcHRfaWQYASABKAlSCHByb21wdElkEjAKBXZhbH'
    'VlGAIgASgLMhguZG9tYWluLlJlc3VsdFZhbHVlUHJvdG9IAFIFdmFsdWUSHgoJY2FuY2VsbGVk'
    'GAMgASgISABSCWNhbmNlbGxlZEIJCgdvdXRjb21l');

@$core.Deprecated('Use resultValueProtoDescriptor instead')
const ResultValueProto$json = {
  '1': 'ResultValueProto',
  '2': [
    {
      '1': 'confirmation_result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.domain.ConfirmationResultProto',
      '9': 0,
      '10': 'confirmationResult'
    },
    {
      '1': 'date_result',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.DateResultProto',
      '9': 0,
      '10': 'dateResult'
    },
    {
      '1': 'money_result',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.domain.MoneyResultProto',
      '9': 0,
      '10': 'moneyResult'
    },
    {
      '1': 'number_result',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.domain.NumberResultProto',
      '9': 0,
      '10': 'numberResult'
    },
    {
      '1': 'selection_result',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.domain.SelectOneResultProto',
      '9': 0,
      '10': 'selectionResult'
    },
    {
      '1': 'string_result',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.domain.StringResultProto',
      '9': 0,
      '10': 'stringResult'
    },
  ],
  '8': [
    {'1': 'result_type'},
  ],
};

/// Descriptor for `ResultValueProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultValueProtoDescriptor = $convert.base64Decode(
    'ChBSZXN1bHRWYWx1ZVByb3RvElIKE2NvbmZpcm1hdGlvbl9yZXN1bHQYASABKAsyHy5kb21haW'
    '4uQ29uZmlybWF0aW9uUmVzdWx0UHJvdG9IAFISY29uZmlybWF0aW9uUmVzdWx0EjoKC2RhdGVf'
    'cmVzdWx0GAIgASgLMhcuZG9tYWluLkRhdGVSZXN1bHRQcm90b0gAUgpkYXRlUmVzdWx0Ej0KDG'
    '1vbmV5X3Jlc3VsdBgEIAEoCzIYLmRvbWFpbi5Nb25leVJlc3VsdFByb3RvSABSC21vbmV5UmVz'
    'dWx0EkAKDW51bWJlcl9yZXN1bHQYBSABKAsyGS5kb21haW4uTnVtYmVyUmVzdWx0UHJvdG9IAF'
    'IMbnVtYmVyUmVzdWx0EkkKEHNlbGVjdGlvbl9yZXN1bHQYBiABKAsyHC5kb21haW4uU2VsZWN0'
    'T25lUmVzdWx0UHJvdG9IAFIPc2VsZWN0aW9uUmVzdWx0EkAKDXN0cmluZ19yZXN1bHQYByABKA'
    'syGS5kb21haW4uU3RyaW5nUmVzdWx0UHJvdG9IAFIMc3RyaW5nUmVzdWx0Qg0KC3Jlc3VsdF90'
    'eXBl');

@$core.Deprecated('Use confirmationResultProtoDescriptor instead')
const ConfirmationResultProto$json = {
  '1': 'ConfirmationResultProto',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
  ],
};

/// Descriptor for `ConfirmationResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmationResultProtoDescriptor =
    $convert.base64Decode(
        'ChdDb25maXJtYXRpb25SZXN1bHRQcm90bxIaCghhY2NlcHRlZBgBIAEoCFIIYWNjZXB0ZWQ=');

@$core.Deprecated('Use dateResultProtoDescriptor instead')
const DateResultProto$json = {
  '1': 'DateResultProto',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.domain.SimpleDateTimeProto',
      '10': 'value'
    },
  ],
};

/// Descriptor for `DateResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateResultProtoDescriptor = $convert.base64Decode(
    'Cg9EYXRlUmVzdWx0UHJvdG8SMQoFdmFsdWUYASABKAsyGy5kb21haW4uU2ltcGxlRGF0ZVRpbW'
    'VQcm90b1IFdmFsdWU=');

@$core.Deprecated('Use moneyResultProtoDescriptor instead')
const MoneyResultProto$json = {
  '1': 'MoneyResultProto',
  '2': [
    {
      '1': 'amount_in_lowest_denomination',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'amountInLowestDenomination'
    },
    {'1': 'currency_code', '3': 2, '4': 1, '5': 9, '10': 'currencyCode'},
  ],
};

/// Descriptor for `MoneyResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyResultProtoDescriptor = $convert.base64Decode(
    'ChBNb25leVJlc3VsdFByb3RvEkEKHWFtb3VudF9pbl9sb3dlc3RfZGVub21pbmF0aW9uGAEgAS'
    'gDUhphbW91bnRJbkxvd2VzdERlbm9taW5hdGlvbhIjCg1jdXJyZW5jeV9jb2RlGAIgASgJUgxj'
    'dXJyZW5jeUNvZGU=');

@$core.Deprecated('Use numberResultProtoDescriptor instead')
const NumberResultProto$json = {
  '1': 'NumberResultProto',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `NumberResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List numberResultProtoDescriptor = $convert
    .base64Decode('ChFOdW1iZXJSZXN1bHRQcm90bxIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');

@$core.Deprecated('Use selectOneResultProtoDescriptor instead')
const SelectOneResultProto$json = {
  '1': 'SelectOneResultProto',
  '2': [
    {'1': 'selected_id', '3': 1, '4': 1, '5': 9, '10': 'selectedId'},
  ],
};

/// Descriptor for `SelectOneResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectOneResultProtoDescriptor = $convert.base64Decode(
    'ChRTZWxlY3RPbmVSZXN1bHRQcm90bxIfCgtzZWxlY3RlZF9pZBgBIAEoCVIKc2VsZWN0ZWRJZA'
    '==');

@$core.Deprecated('Use stringResultProtoDescriptor instead')
const StringResultProto$json = {
  '1': 'StringResultProto',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringResultProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringResultProtoDescriptor = $convert
    .base64Decode('ChFTdHJpbmdSZXN1bHRQcm90bxIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');

@$core.Deprecated('Use localeProtoDescriptor instead')
const LocaleProto$json = {
  '1': 'LocaleProto',
  '2': [
    {'1': 'locale_code', '3': 1, '4': 1, '5': 9, '10': 'localeCode'},
  ],
};

/// Descriptor for `LocaleProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localeProtoDescriptor = $convert.base64Decode(
    'CgtMb2NhbGVQcm90bxIfCgtsb2NhbGVfY29kZRgBIAEoCVIKbG9jYWxlQ29kZQ==');
