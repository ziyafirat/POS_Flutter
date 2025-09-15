// This is a generated file - do not edit.
//
// Generated from domain/quick_lookup.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use quickLookupItemProtoDescriptor instead')
const QuickLookupItemProto$json = {
  '1': 'QuickLookupItemProto',
  '2': [
    {'1': 'barcode', '3': 1, '4': 1, '5': 9, '10': 'barcode'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'description',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'description',
      '17': true
    },
    {
      '1': 'raw_image',
      '3': 4,
      '4': 1,
      '5': 12,
      '9': 1,
      '10': 'rawImage',
      '17': true
    },
  ],
  '8': [
    {'1': '_description'},
    {'1': '_raw_image'},
  ],
};

/// Descriptor for `QuickLookupItemProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickLookupItemProtoDescriptor = $convert.base64Decode(
    'ChRRdWlja0xvb2t1cEl0ZW1Qcm90bxIYCgdiYXJjb2RlGAEgASgJUgdiYXJjb2RlEhIKBG5hbW'
    'UYAiABKAlSBG5hbWUSJQoLZGVzY3JpcHRpb24YAyABKAlIAFILZGVzY3JpcHRpb26IAQESIAoJ'
    'cmF3X2ltYWdlGAQgASgMSAFSCHJhd0ltYWdliAEBQg4KDF9kZXNjcmlwdGlvbkIMCgpfcmF3X2'
    'ltYWdl');

@$core.Deprecated('Use quickLookupItemListProtoDescriptor instead')
const QuickLookupItemListProto$json = {
  '1': 'QuickLookupItemListProto',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.domain.QuickLookupItemProto',
      '10': 'items'
    },
  ],
};

/// Descriptor for `QuickLookupItemListProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickLookupItemListProtoDescriptor =
    $convert.base64Decode(
        'ChhRdWlja0xvb2t1cEl0ZW1MaXN0UHJvdG8SMgoFaXRlbXMYASADKAsyHC5kb21haW4uUXVpY2'
        'tMb29rdXBJdGVtUHJvdG9SBWl0ZW1z');

@$core.Deprecated('Use getQuickLookupItemsResponseProtoDescriptor instead')
const GetQuickLookupItemsResponseProto$json = {
  '1': 'GetQuickLookupItemsResponseProto',
  '2': [
    {
      '1': 'quick_lookup_categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6':
          '.domain.GetQuickLookupItemsResponseProto.QuickLookupCategoriesEntry',
      '10': 'quickLookupCategories'
    },
  ],
  '3': [GetQuickLookupItemsResponseProto_QuickLookupCategoriesEntry$json],
};

@$core.Deprecated('Use getQuickLookupItemsResponseProtoDescriptor instead')
const GetQuickLookupItemsResponseProto_QuickLookupCategoriesEntry$json = {
  '1': 'QuickLookupCategoriesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.domain.QuickLookupItemListProto',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `GetQuickLookupItemsResponseProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQuickLookupItemsResponseProtoDescriptor = $convert.base64Decode(
    'CiBHZXRRdWlja0xvb2t1cEl0ZW1zUmVzcG9uc2VQcm90bxJ7ChdxdWlja19sb29rdXBfY2F0ZW'
    'dvcmllcxgBIAMoCzJDLmRvbWFpbi5HZXRRdWlja0xvb2t1cEl0ZW1zUmVzcG9uc2VQcm90by5R'
    'dWlja0xvb2t1cENhdGVnb3JpZXNFbnRyeVIVcXVpY2tMb29rdXBDYXRlZ29yaWVzGmoKGlF1aW'
    'NrTG9va3VwQ2F0ZWdvcmllc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EjYKBXZhbHVlGAIgASgL'
    'MiAuZG9tYWluLlF1aWNrTG9va3VwSXRlbUxpc3RQcm90b1IFdmFsdWU6AjgB');
