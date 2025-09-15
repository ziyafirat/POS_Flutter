// This is a generated file - do not edit.
//
// Generated from domain/interaction_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'interaction_message.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'interaction_message.pbenum.dart';

enum PromptProto_PromptType {
  confirmationPrompt,
  datePrompt,
  moneyPrompt,
  numberPrompt,
  selectOnePrompt,
  stringPrompt,
  notSet
}

/// *
///  A generic, data-driven message sent from the server to the client that
///  describes a UI element for the client to render and await a user response.
///  This is the core message for all interactive flows.
class PromptProto extends $pb.GeneratedMessage {
  factory PromptProto({
    $core.String? promptId,
    $core.String? messageText,
    $core.String? statusText,
    $core.String? titleText,
    $core.int? timeoutSeconds,
    ConfirmationPromptProto? confirmationPrompt,
    DateTimePromptProto? datePrompt,
    MoneyPromptProto? moneyPrompt,
    NumberPromptProto? numberPrompt,
    SelectOnePromptProto? selectOnePrompt,
    StringPromptProto? stringPrompt,
  }) {
    final result = create();
    if (promptId != null) result.promptId = promptId;
    if (messageText != null) result.messageText = messageText;
    if (statusText != null) result.statusText = statusText;
    if (titleText != null) result.titleText = titleText;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (confirmationPrompt != null)
      result.confirmationPrompt = confirmationPrompt;
    if (datePrompt != null) result.datePrompt = datePrompt;
    if (moneyPrompt != null) result.moneyPrompt = moneyPrompt;
    if (numberPrompt != null) result.numberPrompt = numberPrompt;
    if (selectOnePrompt != null) result.selectOnePrompt = selectOnePrompt;
    if (stringPrompt != null) result.stringPrompt = stringPrompt;
    return result;
  }

  PromptProto._();

  factory PromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PromptProto_PromptType>
      _PromptProto_PromptTypeByTag = {
    10: PromptProto_PromptType.confirmationPrompt,
    11: PromptProto_PromptType.datePrompt,
    13: PromptProto_PromptType.moneyPrompt,
    14: PromptProto_PromptType.numberPrompt,
    15: PromptProto_PromptType.selectOnePrompt,
    16: PromptProto_PromptType.stringPrompt,
    0: PromptProto_PromptType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 13, 14, 15, 16])
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..aOS(2, _omitFieldNames ? '' : 'messageText')
    ..aOS(3, _omitFieldNames ? '' : 'statusText')
    ..aOS(4, _omitFieldNames ? '' : 'titleText')
    ..a<$core.int>(
        5, _omitFieldNames ? '' : 'timeoutSeconds', $pb.PbFieldType.O3)
    ..aOM<ConfirmationPromptProto>(
        10, _omitFieldNames ? '' : 'confirmationPrompt',
        subBuilder: ConfirmationPromptProto.create)
    ..aOM<DateTimePromptProto>(11, _omitFieldNames ? '' : 'datePrompt',
        subBuilder: DateTimePromptProto.create)
    ..aOM<MoneyPromptProto>(13, _omitFieldNames ? '' : 'moneyPrompt',
        subBuilder: MoneyPromptProto.create)
    ..aOM<NumberPromptProto>(14, _omitFieldNames ? '' : 'numberPrompt',
        subBuilder: NumberPromptProto.create)
    ..aOM<SelectOnePromptProto>(15, _omitFieldNames ? '' : 'selectOnePrompt',
        subBuilder: SelectOnePromptProto.create)
    ..aOM<StringPromptProto>(16, _omitFieldNames ? '' : 'stringPrompt',
        subBuilder: StringPromptProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptProto clone() => PromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptProto copyWith(void Function(PromptProto) updates) =>
      super.copyWith((message) => updates(message as PromptProto))
          as PromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptProto create() => PromptProto._();
  @$core.override
  PromptProto createEmptyInstance() => create();
  static $pb.PbList<PromptProto> createRepeated() => $pb.PbList<PromptProto>();
  @$core.pragma('dart2js:noInline')
  static PromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromptProto>(create);
  static PromptProto? _defaultInstance;

  PromptProto_PromptType whichPromptType() =>
      _PromptProto_PromptTypeByTag[$_whichOneof(0)]!;
  void clearPromptType() => $_clearField($_whichOneof(0));

  /// A unique ID generated by the server for this specific prompt. The client
  /// MUST send this ID back in the corresponding `PromptResultProto`.
  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);

  /// Required: The main instructional text to display to the user.
  /// e.g., "Please enter your PIN".
  @$pb.TagNumber(2)
  $core.String get messageText => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageText() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageText() => $_clearField(2);

  /// Optional: Secondary text, often used to display a validation error or
  /// status update without changing the main prompt. e.g., "Invalid PIN".
  @$pb.TagNumber(3)
  $core.String get statusText => $_getSZ(2);
  @$pb.TagNumber(3)
  set statusText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatusText() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatusText() => $_clearField(3);

  /// Optional: The title of the dialog window or screen.
  @$pb.TagNumber(4)
  $core.String get titleText => $_getSZ(3);
  @$pb.TagNumber(4)
  set titleText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitleText() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitleText() => $_clearField(4);

  /// Optional: A server-suggested timeout in seconds. The client should start a
  /// timer and automatically fail the prompt if the user does not respond in time.
  @$pb.TagNumber(5)
  $core.int get timeoutSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set timeoutSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimeoutSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeoutSeconds() => $_clearField(5);

  @$pb.TagNumber(10)
  ConfirmationPromptProto get confirmationPrompt => $_getN(5);
  @$pb.TagNumber(10)
  set confirmationPrompt(ConfirmationPromptProto value) =>
      $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConfirmationPrompt() => $_has(5);
  @$pb.TagNumber(10)
  void clearConfirmationPrompt() => $_clearField(10);
  @$pb.TagNumber(10)
  ConfirmationPromptProto ensureConfirmationPrompt() => $_ensure(5);

  @$pb.TagNumber(11)
  DateTimePromptProto get datePrompt => $_getN(6);
  @$pb.TagNumber(11)
  set datePrompt(DateTimePromptProto value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDatePrompt() => $_has(6);
  @$pb.TagNumber(11)
  void clearDatePrompt() => $_clearField(11);
  @$pb.TagNumber(11)
  DateTimePromptProto ensureDatePrompt() => $_ensure(6);

  /// InformationPromptProto information_prompt = 12;
  @$pb.TagNumber(13)
  MoneyPromptProto get moneyPrompt => $_getN(7);
  @$pb.TagNumber(13)
  set moneyPrompt(MoneyPromptProto value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasMoneyPrompt() => $_has(7);
  @$pb.TagNumber(13)
  void clearMoneyPrompt() => $_clearField(13);
  @$pb.TagNumber(13)
  MoneyPromptProto ensureMoneyPrompt() => $_ensure(7);

  @$pb.TagNumber(14)
  NumberPromptProto get numberPrompt => $_getN(8);
  @$pb.TagNumber(14)
  set numberPrompt(NumberPromptProto value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasNumberPrompt() => $_has(8);
  @$pb.TagNumber(14)
  void clearNumberPrompt() => $_clearField(14);
  @$pb.TagNumber(14)
  NumberPromptProto ensureNumberPrompt() => $_ensure(8);

  @$pb.TagNumber(15)
  SelectOnePromptProto get selectOnePrompt => $_getN(9);
  @$pb.TagNumber(15)
  set selectOnePrompt(SelectOnePromptProto value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSelectOnePrompt() => $_has(9);
  @$pb.TagNumber(15)
  void clearSelectOnePrompt() => $_clearField(15);
  @$pb.TagNumber(15)
  SelectOnePromptProto ensureSelectOnePrompt() => $_ensure(9);

  @$pb.TagNumber(16)
  StringPromptProto get stringPrompt => $_getN(10);
  @$pb.TagNumber(16)
  set stringPrompt(StringPromptProto value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStringPrompt() => $_has(10);
  @$pb.TagNumber(16)
  void clearStringPrompt() => $_clearField(16);
  @$pb.TagNumber(16)
  StringPromptProto ensureStringPrompt() => $_ensure(10);
}

/// *
///  A prompt asking for a simple Yes/No or Accept/Reject response.
class ConfirmationPromptProto extends $pb.GeneratedMessage {
  factory ConfirmationPromptProto({
    $core.bool? acceptEnabled,
    $core.bool? rejectEnabled,
    $core.bool? cancelEnabled,
    $core.String? acceptLabel,
    $core.String? rejectLabel,
    $core.String? cancelLabel,
  }) {
    final result = create();
    if (acceptEnabled != null) result.acceptEnabled = acceptEnabled;
    if (rejectEnabled != null) result.rejectEnabled = rejectEnabled;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (acceptLabel != null) result.acceptLabel = acceptLabel;
    if (rejectLabel != null) result.rejectLabel = rejectLabel;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    return result;
  }

  ConfirmationPromptProto._();

  factory ConfirmationPromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmationPromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmationPromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'acceptEnabled')
    ..aOB(2, _omitFieldNames ? '' : 'rejectEnabled')
    ..aOB(3, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(4, _omitFieldNames ? '' : 'acceptLabel')
    ..aOS(5, _omitFieldNames ? '' : 'rejectLabel')
    ..aOS(6, _omitFieldNames ? '' : 'cancelLabel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmationPromptProto clone() =>
      ConfirmationPromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmationPromptProto copyWith(
          void Function(ConfirmationPromptProto) updates) =>
      super.copyWith((message) => updates(message as ConfirmationPromptProto))
          as ConfirmationPromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmationPromptProto create() => ConfirmationPromptProto._();
  @$core.override
  ConfirmationPromptProto createEmptyInstance() => create();
  static $pb.PbList<ConfirmationPromptProto> createRepeated() =>
      $pb.PbList<ConfirmationPromptProto>();
  @$core.pragma('dart2js:noInline')
  static ConfirmationPromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmationPromptProto>(create);
  static ConfirmationPromptProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get acceptEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set acceptEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAcceptEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcceptEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get rejectEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set rejectEnabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRejectEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejectEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get cancelEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set cancelEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCancelEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearCancelEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get acceptLabel => $_getSZ(3);
  @$pb.TagNumber(4)
  set acceptLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAcceptLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearAcceptLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rejectLabel => $_getSZ(4);
  @$pb.TagNumber(5)
  set rejectLabel($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRejectLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearRejectLabel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cancelLabel => $_getSZ(5);
  @$pb.TagNumber(6)
  set cancelLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCancelLabel() => $_has(5);
  @$pb.TagNumber(6)
  void clearCancelLabel() => $_clearField(6);
}

/// *
///  A prompt for date and/or time input.
class DateTimePromptProto extends $pb.GeneratedMessage {
  factory DateTimePromptProto({
    DateTimePromptProto_DateTimeFormat? dateFormat,
    SimpleDateTimeProto? minDate,
    SimpleDateTimeProto? maxDate,
    $core.String? okLabel,
    $core.bool? cancelEnabled,
    $core.String? cancelLabel,
    SimpleDateTimeProto? defaultValue,
  }) {
    final result = create();
    if (dateFormat != null) result.dateFormat = dateFormat;
    if (minDate != null) result.minDate = minDate;
    if (maxDate != null) result.maxDate = maxDate;
    if (okLabel != null) result.okLabel = okLabel;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  DateTimePromptProto._();

  factory DateTimePromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DateTimePromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateTimePromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..e<DateTimePromptProto_DateTimeFormat>(
        1, _omitFieldNames ? '' : 'dateFormat', $pb.PbFieldType.OE,
        defaultOrMaker:
            DateTimePromptProto_DateTimeFormat.DATE_FORMAT_UNSPECIFIED,
        valueOf: DateTimePromptProto_DateTimeFormat.valueOf,
        enumValues: DateTimePromptProto_DateTimeFormat.values)
    ..aOM<SimpleDateTimeProto>(2, _omitFieldNames ? '' : 'minDate',
        subBuilder: SimpleDateTimeProto.create)
    ..aOM<SimpleDateTimeProto>(3, _omitFieldNames ? '' : 'maxDate',
        subBuilder: SimpleDateTimeProto.create)
    ..aOS(13, _omitFieldNames ? '' : 'okLabel')
    ..aOB(14, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(15, _omitFieldNames ? '' : 'cancelLabel')
    ..aOM<SimpleDateTimeProto>(16, _omitFieldNames ? '' : 'defaultValue',
        protoName: 'defaultValue', subBuilder: SimpleDateTimeProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateTimePromptProto clone() => DateTimePromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateTimePromptProto copyWith(void Function(DateTimePromptProto) updates) =>
      super.copyWith((message) => updates(message as DateTimePromptProto))
          as DateTimePromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DateTimePromptProto create() => DateTimePromptProto._();
  @$core.override
  DateTimePromptProto createEmptyInstance() => create();
  static $pb.PbList<DateTimePromptProto> createRepeated() =>
      $pb.PbList<DateTimePromptProto>();
  @$core.pragma('dart2js:noInline')
  static DateTimePromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DateTimePromptProto>(create);
  static DateTimePromptProto? _defaultInstance;

  /// The required format for the date input.
  @$pb.TagNumber(1)
  DateTimePromptProto_DateTimeFormat get dateFormat => $_getN(0);
  @$pb.TagNumber(1)
  set dateFormat(DateTimePromptProto_DateTimeFormat value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDateFormat() => $_has(0);
  @$pb.TagNumber(1)
  void clearDateFormat() => $_clearField(1);

  /// An optional minimum selectable date/time (inclusive).
  @$pb.TagNumber(2)
  SimpleDateTimeProto get minDate => $_getN(1);
  @$pb.TagNumber(2)
  set minDate(SimpleDateTimeProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMinDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinDate() => $_clearField(2);
  @$pb.TagNumber(2)
  SimpleDateTimeProto ensureMinDate() => $_ensure(1);

  /// An optional maximum selectable date/time (inclusive).
  @$pb.TagNumber(3)
  SimpleDateTimeProto get maxDate => $_getN(2);
  @$pb.TagNumber(3)
  set maxDate(SimpleDateTimeProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxDate() => $_clearField(3);
  @$pb.TagNumber(3)
  SimpleDateTimeProto ensureMaxDate() => $_ensure(2);

  /// The optional text for the "OK" button. If not provided client will use default.
  @$pb.TagNumber(13)
  $core.String get okLabel => $_getSZ(3);
  @$pb.TagNumber(13)
  set okLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(13)
  $core.bool hasOkLabel() => $_has(3);
  @$pb.TagNumber(13)
  void clearOkLabel() => $_clearField(13);

  /// Enable cancel button on the client.
  @$pb.TagNumber(14)
  $core.bool get cancelEnabled => $_getBF(4);
  @$pb.TagNumber(14)
  set cancelEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelEnabled() => $_has(4);
  @$pb.TagNumber(14)
  void clearCancelEnabled() => $_clearField(14);

  /// The optional text for the "Cancel" button. If not provided and enable_cancel is true then client will use default.
  @$pb.TagNumber(15)
  $core.String get cancelLabel => $_getSZ(5);
  @$pb.TagNumber(15)
  set cancelLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(15)
  $core.bool hasCancelLabel() => $_has(5);
  @$pb.TagNumber(15)
  void clearCancelLabel() => $_clearField(15);

  /// The optional default value
  @$pb.TagNumber(16)
  SimpleDateTimeProto get defaultValue => $_getN(6);
  @$pb.TagNumber(16)
  set defaultValue(SimpleDateTimeProto value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasDefaultValue() => $_has(6);
  @$pb.TagNumber(16)
  void clearDefaultValue() => $_clearField(16);
  @$pb.TagNumber(16)
  SimpleDateTimeProto ensureDefaultValue() => $_ensure(6);
}

/// *
///  A prompt for monetary input.
class MoneyPromptProto extends $pb.GeneratedMessage {
  factory MoneyPromptProto({
    $core.String? currencyCode,
    $core.int? decimalPlaces,
    $fixnum.Int64? minAmountInLowestDenomination,
    $fixnum.Int64? maxAmountInLowestDenomination,
    $core.String? okLabel,
    $core.bool? cancelEnabled,
    $core.String? cancelLabel,
    $fixnum.Int64? defaultValue,
  }) {
    final result = create();
    if (currencyCode != null) result.currencyCode = currencyCode;
    if (decimalPlaces != null) result.decimalPlaces = decimalPlaces;
    if (minAmountInLowestDenomination != null)
      result.minAmountInLowestDenomination = minAmountInLowestDenomination;
    if (maxAmountInLowestDenomination != null)
      result.maxAmountInLowestDenomination = maxAmountInLowestDenomination;
    if (okLabel != null) result.okLabel = okLabel;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  MoneyPromptProto._();

  factory MoneyPromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoneyPromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoneyPromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'currencyCode')
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'decimalPlaces', $pb.PbFieldType.O3)
    ..aInt64(3, _omitFieldNames ? '' : 'minAmountInLowestDenomination')
    ..aInt64(4, _omitFieldNames ? '' : 'maxAmountInLowestDenomination')
    ..aOS(13, _omitFieldNames ? '' : 'okLabel')
    ..aOB(14, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(15, _omitFieldNames ? '' : 'cancelLabel')
    ..aInt64(16, _omitFieldNames ? '' : 'defaultValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyPromptProto clone() => MoneyPromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyPromptProto copyWith(void Function(MoneyPromptProto) updates) =>
      super.copyWith((message) => updates(message as MoneyPromptProto))
          as MoneyPromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoneyPromptProto create() => MoneyPromptProto._();
  @$core.override
  MoneyPromptProto createEmptyInstance() => create();
  static $pb.PbList<MoneyPromptProto> createRepeated() =>
      $pb.PbList<MoneyPromptProto>();
  @$core.pragma('dart2js:noInline')
  static MoneyPromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoneyPromptProto>(create);
  static MoneyPromptProto? _defaultInstance;

  /// The ISO 4217 currency code (e.g., "USD").
  @$pb.TagNumber(1)
  $core.String get currencyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set currencyCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrencyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrencyCode() => $_clearField(1);

  /// The number of decimal places for the currency (e.g., 2 for USD, 0 for JPY).
  @$pb.TagNumber(2)
  $core.int get decimalPlaces => $_getIZ(1);
  @$pb.TagNumber(2)
  set decimalPlaces($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDecimalPlaces() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecimalPlaces() => $_clearField(2);

  /// Optional minimum allowed amount, in the currency's lowest denomination.
  @$pb.TagNumber(3)
  $fixnum.Int64 get minAmountInLowestDenomination => $_getI64(2);
  @$pb.TagNumber(3)
  set minAmountInLowestDenomination($fixnum.Int64 value) =>
      $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinAmountInLowestDenomination() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinAmountInLowestDenomination() => $_clearField(3);

  /// Optional maximum allowed amount, in the currency's lowest denomination.
  @$pb.TagNumber(4)
  $fixnum.Int64 get maxAmountInLowestDenomination => $_getI64(3);
  @$pb.TagNumber(4)
  set maxAmountInLowestDenomination($fixnum.Int64 value) =>
      $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxAmountInLowestDenomination() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAmountInLowestDenomination() => $_clearField(4);

  /// The optional text for the "OK" button. If not provided client will use default.
  @$pb.TagNumber(13)
  $core.String get okLabel => $_getSZ(4);
  @$pb.TagNumber(13)
  set okLabel($core.String value) => $_setString(4, value);
  @$pb.TagNumber(13)
  $core.bool hasOkLabel() => $_has(4);
  @$pb.TagNumber(13)
  void clearOkLabel() => $_clearField(13);

  /// Enable cancel button on the client.
  @$pb.TagNumber(14)
  $core.bool get cancelEnabled => $_getBF(5);
  @$pb.TagNumber(14)
  set cancelEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelEnabled() => $_has(5);
  @$pb.TagNumber(14)
  void clearCancelEnabled() => $_clearField(14);

  /// The optional text for the "Cancel" button. If not provided and enable_cancel is true then client will use default.
  @$pb.TagNumber(15)
  $core.String get cancelLabel => $_getSZ(6);
  @$pb.TagNumber(15)
  set cancelLabel($core.String value) => $_setString(6, value);
  @$pb.TagNumber(15)
  $core.bool hasCancelLabel() => $_has(6);
  @$pb.TagNumber(15)
  void clearCancelLabel() => $_clearField(15);

  /// Optional default value
  @$pb.TagNumber(16)
  $fixnum.Int64 get defaultValue => $_getI64(7);
  @$pb.TagNumber(16)
  set defaultValue($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(16)
  $core.bool hasDefaultValue() => $_has(7);
  @$pb.TagNumber(16)
  void clearDefaultValue() => $_clearField(16);
}

/// *
///  A prompt for general numeric input.
class NumberPromptProto extends $pb.GeneratedMessage {
  factory NumberPromptProto({
    $core.int? minDigits,
    $core.int? maxDigits,
    $core.bool? isSecret,
    $core.String? okLabel,
    $core.bool? cancelEnabled,
    $core.String? cancelLabel,
    $core.String? defaultValue,
  }) {
    final result = create();
    if (minDigits != null) result.minDigits = minDigits;
    if (maxDigits != null) result.maxDigits = maxDigits;
    if (isSecret != null) result.isSecret = isSecret;
    if (okLabel != null) result.okLabel = okLabel;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  NumberPromptProto._();

  factory NumberPromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NumberPromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NumberPromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'minDigits', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxDigits', $pb.PbFieldType.O3)
    ..aOB(3, _omitFieldNames ? '' : 'isSecret')
    ..aOS(13, _omitFieldNames ? '' : 'okLabel')
    ..aOB(14, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(15, _omitFieldNames ? '' : 'cancelLabel')
    ..aOS(16, _omitFieldNames ? '' : 'defaultValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NumberPromptProto clone() => NumberPromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NumberPromptProto copyWith(void Function(NumberPromptProto) updates) =>
      super.copyWith((message) => updates(message as NumberPromptProto))
          as NumberPromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NumberPromptProto create() => NumberPromptProto._();
  @$core.override
  NumberPromptProto createEmptyInstance() => create();
  static $pb.PbList<NumberPromptProto> createRepeated() =>
      $pb.PbList<NumberPromptProto>();
  @$core.pragma('dart2js:noInline')
  static NumberPromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NumberPromptProto>(create);
  static NumberPromptProto? _defaultInstance;

  /// If present, the client should enforce this minimum number of digits.
  @$pb.TagNumber(1)
  $core.int get minDigits => $_getIZ(0);
  @$pb.TagNumber(1)
  set minDigits($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinDigits() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinDigits() => $_clearField(1);

  /// If present, the client should enforce this maximum number of digits.
  @$pb.TagNumber(2)
  $core.int get maxDigits => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxDigits($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxDigits() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxDigits() => $_clearField(2);

  /// If `true`, the client must mask the input (e.g., for a PIN).
  @$pb.TagNumber(3)
  $core.bool get isSecret => $_getBF(2);
  @$pb.TagNumber(3)
  set isSecret($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsSecret() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsSecret() => $_clearField(3);

  /// The optional text for the "OK" button. If not provided client will use default.
  @$pb.TagNumber(13)
  $core.String get okLabel => $_getSZ(3);
  @$pb.TagNumber(13)
  set okLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(13)
  $core.bool hasOkLabel() => $_has(3);
  @$pb.TagNumber(13)
  void clearOkLabel() => $_clearField(13);

  /// Enable cancel button on the client.
  @$pb.TagNumber(14)
  $core.bool get cancelEnabled => $_getBF(4);
  @$pb.TagNumber(14)
  set cancelEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelEnabled() => $_has(4);
  @$pb.TagNumber(14)
  void clearCancelEnabled() => $_clearField(14);

  /// The optional text for the "Cancel" button. If not provided and enable_cancel is true then client will use default.
  @$pb.TagNumber(15)
  $core.String get cancelLabel => $_getSZ(5);
  @$pb.TagNumber(15)
  set cancelLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(15)
  $core.bool hasCancelLabel() => $_has(5);
  @$pb.TagNumber(15)
  void clearCancelLabel() => $_clearField(15);

  /// Optional default value
  @$pb.TagNumber(16)
  $core.String get defaultValue => $_getSZ(6);
  @$pb.TagNumber(16)
  set defaultValue($core.String value) => $_setString(6, value);
  @$pb.TagNumber(16)
  $core.bool hasDefaultValue() => $_has(6);
  @$pb.TagNumber(16)
  void clearDefaultValue() => $_clearField(16);
}

/// *
///  Represents a single, selectable choice in the list.
class SelectOnePromptProto_Option extends $pb.GeneratedMessage {
  factory SelectOnePromptProto_Option({
    $core.String? id,
    $core.String? delimitedDisplayTexts,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (delimitedDisplayTexts != null)
      result.delimitedDisplayTexts = delimitedDisplayTexts;
    return result;
  }

  SelectOnePromptProto_Option._();

  factory SelectOnePromptProto_Option.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectOnePromptProto_Option.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectOnePromptProto.Option',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'delimitedDisplayTexts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOnePromptProto_Option clone() =>
      SelectOnePromptProto_Option()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOnePromptProto_Option copyWith(
          void Function(SelectOnePromptProto_Option) updates) =>
      super.copyWith(
              (message) => updates(message as SelectOnePromptProto_Option))
          as SelectOnePromptProto_Option;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectOnePromptProto_Option create() =>
      SelectOnePromptProto_Option._();
  @$core.override
  SelectOnePromptProto_Option createEmptyInstance() => create();
  static $pb.PbList<SelectOnePromptProto_Option> createRepeated() =>
      $pb.PbList<SelectOnePromptProto_Option>();
  @$core.pragma('dart2js:noInline')
  static SelectOnePromptProto_Option getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectOnePromptProto_Option>(create);
  static SelectOnePromptProto_Option? _defaultInstance;

  /// The unique ID for this option, which the client will send back if selected.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// A string containing one or more display values, separated by a server-defined delimiter.
  /// This allows for rendering grid-like views.
  @$pb.TagNumber(2)
  $core.String get delimitedDisplayTexts => $_getSZ(1);
  @$pb.TagNumber(2)
  set delimitedDisplayTexts($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDelimitedDisplayTexts() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelimitedDisplayTexts() => $_clearField(2);
}

/// *
///  A prompt asking the user to select one option from a list.
class SelectOnePromptProto extends $pb.GeneratedMessage {
  factory SelectOnePromptProto({
    $core.Iterable<SelectOnePromptProto_Option>? options,
    $core.int? columnCount,
    $core.String? delimitedColumnHeaderTexts,
    $core.String? okLabel,
    $core.bool? cancelEnabled,
    $core.String? cancelLabel,
  }) {
    final result = create();
    if (options != null) result.options.addAll(options);
    if (columnCount != null) result.columnCount = columnCount;
    if (delimitedColumnHeaderTexts != null)
      result.delimitedColumnHeaderTexts = delimitedColumnHeaderTexts;
    if (okLabel != null) result.okLabel = okLabel;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    return result;
  }

  SelectOnePromptProto._();

  factory SelectOnePromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectOnePromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectOnePromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..pc<SelectOnePromptProto_Option>(
        1, _omitFieldNames ? '' : 'options', $pb.PbFieldType.PM,
        subBuilder: SelectOnePromptProto_Option.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'columnCount', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'delimitedColumnHeaderTexts')
    ..aOS(13, _omitFieldNames ? '' : 'okLabel')
    ..aOB(14, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(15, _omitFieldNames ? '' : 'cancelLabel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOnePromptProto clone() =>
      SelectOnePromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOnePromptProto copyWith(void Function(SelectOnePromptProto) updates) =>
      super.copyWith((message) => updates(message as SelectOnePromptProto))
          as SelectOnePromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectOnePromptProto create() => SelectOnePromptProto._();
  @$core.override
  SelectOnePromptProto createEmptyInstance() => create();
  static $pb.PbList<SelectOnePromptProto> createRepeated() =>
      $pb.PbList<SelectOnePromptProto>();
  @$core.pragma('dart2js:noInline')
  static SelectOnePromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectOnePromptProto>(create);
  static SelectOnePromptProto? _defaultInstance;

  /// The list of choices to present to the user.
  @$pb.TagNumber(1)
  $pb.PbList<SelectOnePromptProto_Option> get options => $_getList(0);

  /// The number of columns the client UI should use to render the grid of options.
  @$pb.TagNumber(2)
  $core.int get columnCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set columnCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasColumnCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearColumnCount() => $_clearField(2);

  /// A string containing column header texts, separated by a server-defined delimiter.
  @$pb.TagNumber(3)
  $core.String get delimitedColumnHeaderTexts => $_getSZ(2);
  @$pb.TagNumber(3)
  set delimitedColumnHeaderTexts($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelimitedColumnHeaderTexts() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelimitedColumnHeaderTexts() => $_clearField(3);

  /// The optional text for the "OK" button. If not provided client will use default.
  @$pb.TagNumber(13)
  $core.String get okLabel => $_getSZ(3);
  @$pb.TagNumber(13)
  set okLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(13)
  $core.bool hasOkLabel() => $_has(3);
  @$pb.TagNumber(13)
  void clearOkLabel() => $_clearField(13);

  /// Enable cancel button on the client.
  @$pb.TagNumber(14)
  $core.bool get cancelEnabled => $_getBF(4);
  @$pb.TagNumber(14)
  set cancelEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelEnabled() => $_has(4);
  @$pb.TagNumber(14)
  void clearCancelEnabled() => $_clearField(14);

  /// The optional text for the "Cancel" button. If not provided and enable_cancel is true then client will use default.
  @$pb.TagNumber(15)
  $core.String get cancelLabel => $_getSZ(5);
  @$pb.TagNumber(15)
  set cancelLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(15)
  $core.bool hasCancelLabel() => $_has(5);
  @$pb.TagNumber(15)
  void clearCancelLabel() => $_clearField(15);
}

/// *
///  A prompt for free-form alphanumeric text input.
class StringPromptProto extends $pb.GeneratedMessage {
  factory StringPromptProto({
    $core.int? minLength,
    $core.int? maxLength,
    $core.bool? isSecret,
    $core.String? okLabel,
    $core.bool? cancelEnabled,
    $core.String? cancelLabel,
    $core.String? defaultValue,
  }) {
    final result = create();
    if (minLength != null) result.minLength = minLength;
    if (maxLength != null) result.maxLength = maxLength;
    if (isSecret != null) result.isSecret = isSecret;
    if (okLabel != null) result.okLabel = okLabel;
    if (cancelEnabled != null) result.cancelEnabled = cancelEnabled;
    if (cancelLabel != null) result.cancelLabel = cancelLabel;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  StringPromptProto._();

  factory StringPromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StringPromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StringPromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'minLength', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxLength', $pb.PbFieldType.O3)
    ..aOB(3, _omitFieldNames ? '' : 'isSecret')
    ..aOS(13, _omitFieldNames ? '' : 'okLabel')
    ..aOB(14, _omitFieldNames ? '' : 'cancelEnabled')
    ..aOS(15, _omitFieldNames ? '' : 'cancelLabel')
    ..aOS(16, _omitFieldNames ? '' : 'defaultValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringPromptProto clone() => StringPromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringPromptProto copyWith(void Function(StringPromptProto) updates) =>
      super.copyWith((message) => updates(message as StringPromptProto))
          as StringPromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StringPromptProto create() => StringPromptProto._();
  @$core.override
  StringPromptProto createEmptyInstance() => create();
  static $pb.PbList<StringPromptProto> createRepeated() =>
      $pb.PbList<StringPromptProto>();
  @$core.pragma('dart2js:noInline')
  static StringPromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StringPromptProto>(create);
  static StringPromptProto? _defaultInstance;

  /// If present, the client should enforce this minimum number of characters.
  @$pb.TagNumber(1)
  $core.int get minLength => $_getIZ(0);
  @$pb.TagNumber(1)
  set minLength($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinLength() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinLength() => $_clearField(1);

  /// If present, the client should enforce this maximum number of characters.
  @$pb.TagNumber(2)
  $core.int get maxLength => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxLength($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxLength() => $_clearField(2);

  /// If `true`, the client must mask the input (e.g., for a password).
  @$pb.TagNumber(3)
  $core.bool get isSecret => $_getBF(2);
  @$pb.TagNumber(3)
  set isSecret($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsSecret() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsSecret() => $_clearField(3);

  /// The optional text for the "OK" button. If not provided client will use default.
  @$pb.TagNumber(13)
  $core.String get okLabel => $_getSZ(3);
  @$pb.TagNumber(13)
  set okLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(13)
  $core.bool hasOkLabel() => $_has(3);
  @$pb.TagNumber(13)
  void clearOkLabel() => $_clearField(13);

  /// Enable cancel button on the client.
  @$pb.TagNumber(14)
  $core.bool get cancelEnabled => $_getBF(4);
  @$pb.TagNumber(14)
  set cancelEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(14)
  $core.bool hasCancelEnabled() => $_has(4);
  @$pb.TagNumber(14)
  void clearCancelEnabled() => $_clearField(14);

  /// The optional text for the "Cancel" button. If not provided and enable_cancel is true then client will use default.
  @$pb.TagNumber(15)
  $core.String get cancelLabel => $_getSZ(5);
  @$pb.TagNumber(15)
  set cancelLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(15)
  $core.bool hasCancelLabel() => $_has(5);
  @$pb.TagNumber(15)
  void clearCancelLabel() => $_clearField(15);

  /// Optional default value
  @$pb.TagNumber(16)
  $core.String get defaultValue => $_getSZ(6);
  @$pb.TagNumber(16)
  set defaultValue($core.String value) => $_setString(6, value);
  @$pb.TagNumber(16)
  $core.bool hasDefaultValue() => $_has(6);
  @$pb.TagNumber(16)
  void clearDefaultValue() => $_clearField(16);
}

/// *
///  A simplified, serializable representation of a date and/or time.
class SimpleDateTimeProto extends $pb.GeneratedMessage {
  factory SimpleDateTimeProto({
    $core.int? year,
    $core.int? month,
    $core.int? day,
    $core.int? hour,
    $core.int? minute,
  }) {
    final result = create();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    if (day != null) result.day = day;
    if (hour != null) result.hour = hour;
    if (minute != null) result.minute = minute;
    return result;
  }

  SimpleDateTimeProto._();

  factory SimpleDateTimeProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SimpleDateTimeProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SimpleDateTimeProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'year', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'month', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'day', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'hour', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'minute', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleDateTimeProto clone() => SimpleDateTimeProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleDateTimeProto copyWith(void Function(SimpleDateTimeProto) updates) =>
      super.copyWith((message) => updates(message as SimpleDateTimeProto))
          as SimpleDateTimeProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SimpleDateTimeProto create() => SimpleDateTimeProto._();
  @$core.override
  SimpleDateTimeProto createEmptyInstance() => create();
  static $pb.PbList<SimpleDateTimeProto> createRepeated() =>
      $pb.PbList<SimpleDateTimeProto>();
  @$core.pragma('dart2js:noInline')
  static SimpleDateTimeProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SimpleDateTimeProto>(create);
  static SimpleDateTimeProto? _defaultInstance;

  /// The full four-digit year (e.g., 2025).
  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  /// The month of the year, from 1 (January) to 12 (December).
  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);

  /// The day of the month, from 1 to 31. Optional for month/year formats.
  @$pb.TagNumber(3)
  $core.int get day => $_getIZ(2);
  @$pb.TagNumber(3)
  set day($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDay() => $_clearField(3);

  /// The hour of the day, from 0 to 23. Optional for date-only formats.
  @$pb.TagNumber(4)
  $core.int get hour => $_getIZ(3);
  @$pb.TagNumber(4)
  set hour($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHour() => $_has(3);
  @$pb.TagNumber(4)
  void clearHour() => $_clearField(4);

  /// The minute of the hour, from 0 to 59. Optional for date-only formats.
  @$pb.TagNumber(5)
  $core.int get minute => $_getIZ(4);
  @$pb.TagNumber(5)
  set minute($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinute() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinute() => $_clearField(5);
}

enum PromptResultProto_Outcome { value, cancelled, notSet }

/// *
///  Contains the outcome of a specific UI prompt, sent from the client to the server.
class PromptResultProto extends $pb.GeneratedMessage {
  factory PromptResultProto({
    $core.String? promptId,
    ResultValueProto? value,
    $core.bool? cancelled,
  }) {
    final result = create();
    if (promptId != null) result.promptId = promptId;
    if (value != null) result.value = value;
    if (cancelled != null) result.cancelled = cancelled;
    return result;
  }

  PromptResultProto._();

  factory PromptResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PromptResultProto_Outcome>
      _PromptResultProto_OutcomeByTag = {
    2: PromptResultProto_Outcome.value,
    3: PromptResultProto_Outcome.cancelled,
    0: PromptResultProto_Outcome.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..aOM<ResultValueProto>(2, _omitFieldNames ? '' : 'value',
        subBuilder: ResultValueProto.create)
    ..aOB(3, _omitFieldNames ? '' : 'cancelled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptResultProto clone() => PromptResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptResultProto copyWith(void Function(PromptResultProto) updates) =>
      super.copyWith((message) => updates(message as PromptResultProto))
          as PromptResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptResultProto create() => PromptResultProto._();
  @$core.override
  PromptResultProto createEmptyInstance() => create();
  static $pb.PbList<PromptResultProto> createRepeated() =>
      $pb.PbList<PromptResultProto>();
  @$core.pragma('dart2js:noInline')
  static PromptResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromptResultProto>(create);
  static PromptResultProto? _defaultInstance;

  PromptResultProto_Outcome whichOutcome() =>
      _PromptResultProto_OutcomeByTag[$_whichOneof(0)]!;
  void clearOutcome() => $_clearField($_whichOneof(0));

  /// This MUST correspond to the `prompt_id` from the `PromptProto` that the user is responding to.
  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);

  /// Set if the user successfully completed the prompt.
  @$pb.TagNumber(2)
  ResultValueProto get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(ResultValueProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  ResultValueProto ensureValue() => $_ensure(1);

  /// Set if the user explicitly cancelled the prompt. The value is not significant.
  @$pb.TagNumber(3)
  $core.bool get cancelled => $_getBF(2);
  @$pb.TagNumber(3)
  set cancelled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCancelled() => $_has(2);
  @$pb.TagNumber(3)
  void clearCancelled() => $_clearField(3);
}

enum ResultValueProto_ResultType {
  confirmationResult,
  dateResult,
  moneyResult,
  numberResult,
  selectionResult,
  stringResult,
  notSet
}

/// *
///  A wrapper message that contains the specific result type, ensuring type safety.
class ResultValueProto extends $pb.GeneratedMessage {
  factory ResultValueProto({
    ConfirmationResultProto? confirmationResult,
    DateResultProto? dateResult,
    MoneyResultProto? moneyResult,
    NumberResultProto? numberResult,
    SelectOneResultProto? selectionResult,
    StringResultProto? stringResult,
  }) {
    final result = create();
    if (confirmationResult != null)
      result.confirmationResult = confirmationResult;
    if (dateResult != null) result.dateResult = dateResult;
    if (moneyResult != null) result.moneyResult = moneyResult;
    if (numberResult != null) result.numberResult = numberResult;
    if (selectionResult != null) result.selectionResult = selectionResult;
    if (stringResult != null) result.stringResult = stringResult;
    return result;
  }

  ResultValueProto._();

  factory ResultValueProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResultValueProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResultValueProto_ResultType>
      _ResultValueProto_ResultTypeByTag = {
    1: ResultValueProto_ResultType.confirmationResult,
    2: ResultValueProto_ResultType.dateResult,
    4: ResultValueProto_ResultType.moneyResult,
    5: ResultValueProto_ResultType.numberResult,
    6: ResultValueProto_ResultType.selectionResult,
    7: ResultValueProto_ResultType.stringResult,
    0: ResultValueProto_ResultType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResultValueProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 4, 5, 6, 7])
    ..aOM<ConfirmationResultProto>(
        1, _omitFieldNames ? '' : 'confirmationResult',
        subBuilder: ConfirmationResultProto.create)
    ..aOM<DateResultProto>(2, _omitFieldNames ? '' : 'dateResult',
        subBuilder: DateResultProto.create)
    ..aOM<MoneyResultProto>(4, _omitFieldNames ? '' : 'moneyResult',
        subBuilder: MoneyResultProto.create)
    ..aOM<NumberResultProto>(5, _omitFieldNames ? '' : 'numberResult',
        subBuilder: NumberResultProto.create)
    ..aOM<SelectOneResultProto>(6, _omitFieldNames ? '' : 'selectionResult',
        subBuilder: SelectOneResultProto.create)
    ..aOM<StringResultProto>(7, _omitFieldNames ? '' : 'stringResult',
        subBuilder: StringResultProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResultValueProto clone() => ResultValueProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResultValueProto copyWith(void Function(ResultValueProto) updates) =>
      super.copyWith((message) => updates(message as ResultValueProto))
          as ResultValueProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResultValueProto create() => ResultValueProto._();
  @$core.override
  ResultValueProto createEmptyInstance() => create();
  static $pb.PbList<ResultValueProto> createRepeated() =>
      $pb.PbList<ResultValueProto>();
  @$core.pragma('dart2js:noInline')
  static ResultValueProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResultValueProto>(create);
  static ResultValueProto? _defaultInstance;

  ResultValueProto_ResultType whichResultType() =>
      _ResultValueProto_ResultTypeByTag[$_whichOneof(0)]!;
  void clearResultType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ConfirmationResultProto get confirmationResult => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationResult(ConfirmationResultProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationResult() => $_clearField(1);
  @$pb.TagNumber(1)
  ConfirmationResultProto ensureConfirmationResult() => $_ensure(0);

  @$pb.TagNumber(2)
  DateResultProto get dateResult => $_getN(1);
  @$pb.TagNumber(2)
  set dateResult(DateResultProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDateResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearDateResult() => $_clearField(2);
  @$pb.TagNumber(2)
  DateResultProto ensureDateResult() => $_ensure(1);

  /// InformationResultProto information_result = 3;
  @$pb.TagNumber(4)
  MoneyResultProto get moneyResult => $_getN(2);
  @$pb.TagNumber(4)
  set moneyResult(MoneyResultProto value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMoneyResult() => $_has(2);
  @$pb.TagNumber(4)
  void clearMoneyResult() => $_clearField(4);
  @$pb.TagNumber(4)
  MoneyResultProto ensureMoneyResult() => $_ensure(2);

  @$pb.TagNumber(5)
  NumberResultProto get numberResult => $_getN(3);
  @$pb.TagNumber(5)
  set numberResult(NumberResultProto value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNumberResult() => $_has(3);
  @$pb.TagNumber(5)
  void clearNumberResult() => $_clearField(5);
  @$pb.TagNumber(5)
  NumberResultProto ensureNumberResult() => $_ensure(3);

  @$pb.TagNumber(6)
  SelectOneResultProto get selectionResult => $_getN(4);
  @$pb.TagNumber(6)
  set selectionResult(SelectOneResultProto value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSelectionResult() => $_has(4);
  @$pb.TagNumber(6)
  void clearSelectionResult() => $_clearField(6);
  @$pb.TagNumber(6)
  SelectOneResultProto ensureSelectionResult() => $_ensure(4);

  @$pb.TagNumber(7)
  StringResultProto get stringResult => $_getN(5);
  @$pb.TagNumber(7)
  set stringResult(StringResultProto value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStringResult() => $_has(5);
  @$pb.TagNumber(7)
  void clearStringResult() => $_clearField(7);
  @$pb.TagNumber(7)
  StringResultProto ensureStringResult() => $_ensure(5);
}

/// *
///  The result for a `ConfirmationPromptProto`.
class ConfirmationResultProto extends $pb.GeneratedMessage {
  factory ConfirmationResultProto({
    $core.bool? accepted,
  }) {
    final result = create();
    if (accepted != null) result.accepted = accepted;
    return result;
  }

  ConfirmationResultProto._();

  factory ConfirmationResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmationResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmationResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmationResultProto clone() =>
      ConfirmationResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmationResultProto copyWith(
          void Function(ConfirmationResultProto) updates) =>
      super.copyWith((message) => updates(message as ConfirmationResultProto))
          as ConfirmationResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmationResultProto create() => ConfirmationResultProto._();
  @$core.override
  ConfirmationResultProto createEmptyInstance() => create();
  static $pb.PbList<ConfirmationResultProto> createRepeated() =>
      $pb.PbList<ConfirmationResultProto>();
  @$core.pragma('dart2js:noInline')
  static ConfirmationResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmationResultProto>(create);
  static ConfirmationResultProto? _defaultInstance;

  /// `true` if the user chose the positive action, `false` for the negative action.
  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);
}

/// *
///  The result for a `DateTimePromptProto`.
class DateResultProto extends $pb.GeneratedMessage {
  factory DateResultProto({
    SimpleDateTimeProto? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  DateResultProto._();

  factory DateResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DateResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOM<SimpleDateTimeProto>(1, _omitFieldNames ? '' : 'value',
        subBuilder: SimpleDateTimeProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateResultProto clone() => DateResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateResultProto copyWith(void Function(DateResultProto) updates) =>
      super.copyWith((message) => updates(message as DateResultProto))
          as DateResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DateResultProto create() => DateResultProto._();
  @$core.override
  DateResultProto createEmptyInstance() => create();
  static $pb.PbList<DateResultProto> createRepeated() =>
      $pb.PbList<DateResultProto>();
  @$core.pragma('dart2js:noInline')
  static DateResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DateResultProto>(create);
  static DateResultProto? _defaultInstance;

  /// The date/time value selected by the user.
  @$pb.TagNumber(1)
  SimpleDateTimeProto get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(SimpleDateTimeProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  SimpleDateTimeProto ensureValue() => $_ensure(0);
}

/// *
///  The result for a `MoneyPromptProto`.
class MoneyResultProto extends $pb.GeneratedMessage {
  factory MoneyResultProto({
    $fixnum.Int64? amountInLowestDenomination,
    $core.String? currencyCode,
  }) {
    final result = create();
    if (amountInLowestDenomination != null)
      result.amountInLowestDenomination = amountInLowestDenomination;
    if (currencyCode != null) result.currencyCode = currencyCode;
    return result;
  }

  MoneyResultProto._();

  factory MoneyResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoneyResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoneyResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'amountInLowestDenomination')
    ..aOS(2, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyResultProto clone() => MoneyResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyResultProto copyWith(void Function(MoneyResultProto) updates) =>
      super.copyWith((message) => updates(message as MoneyResultProto))
          as MoneyResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoneyResultProto create() => MoneyResultProto._();
  @$core.override
  MoneyResultProto createEmptyInstance() => create();
  static $pb.PbList<MoneyResultProto> createRepeated() =>
      $pb.PbList<MoneyResultProto>();
  @$core.pragma('dart2js:noInline')
  static MoneyResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoneyResultProto>(create);
  static MoneyResultProto? _defaultInstance;

  /// The total amount in the currency's smallest unit (e.g., cents).
  @$pb.TagNumber(1)
  $fixnum.Int64 get amountInLowestDenomination => $_getI64(0);
  @$pb.TagNumber(1)
  set amountInLowestDenomination($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmountInLowestDenomination() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmountInLowestDenomination() => $_clearField(1);

  /// The ISO 4217 currency code, matching the original prompt.
  @$pb.TagNumber(2)
  $core.String get currencyCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set currencyCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrencyCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrencyCode() => $_clearField(2);
}

/// *
///  The result for a `NumberPromptProto`.
class NumberResultProto extends $pb.GeneratedMessage {
  factory NumberResultProto({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  NumberResultProto._();

  factory NumberResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NumberResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NumberResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NumberResultProto clone() => NumberResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NumberResultProto copyWith(void Function(NumberResultProto) updates) =>
      super.copyWith((message) => updates(message as NumberResultProto))
          as NumberResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NumberResultProto create() => NumberResultProto._();
  @$core.override
  NumberResultProto createEmptyInstance() => create();
  static $pb.PbList<NumberResultProto> createRepeated() =>
      $pb.PbList<NumberResultProto>();
  @$core.pragma('dart2js:noInline')
  static NumberResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NumberResultProto>(create);
  static NumberResultProto? _defaultInstance;

  /// The numeric value entered by the user.
  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

/// *
///  The result for a `SelectOnePromptProto`.
class SelectOneResultProto extends $pb.GeneratedMessage {
  factory SelectOneResultProto({
    $core.String? selectedId,
  }) {
    final result = create();
    if (selectedId != null) result.selectedId = selectedId;
    return result;
  }

  SelectOneResultProto._();

  factory SelectOneResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectOneResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectOneResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'selectedId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOneResultProto clone() =>
      SelectOneResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOneResultProto copyWith(void Function(SelectOneResultProto) updates) =>
      super.copyWith((message) => updates(message as SelectOneResultProto))
          as SelectOneResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectOneResultProto create() => SelectOneResultProto._();
  @$core.override
  SelectOneResultProto createEmptyInstance() => create();
  static $pb.PbList<SelectOneResultProto> createRepeated() =>
      $pb.PbList<SelectOneResultProto>();
  @$core.pragma('dart2js:noInline')
  static SelectOneResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectOneResultProto>(create);
  static SelectOneResultProto? _defaultInstance;

  /// The unique `id` of the option selected by the user.
  @$pb.TagNumber(1)
  $core.String get selectedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set selectedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSelectedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSelectedId() => $_clearField(1);
}

/// *
///  The result for a `StringPromptProto`.
class StringResultProto extends $pb.GeneratedMessage {
  factory StringResultProto({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  StringResultProto._();

  factory StringResultProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StringResultProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StringResultProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringResultProto clone() => StringResultProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StringResultProto copyWith(void Function(StringResultProto) updates) =>
      super.copyWith((message) => updates(message as StringResultProto))
          as StringResultProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StringResultProto create() => StringResultProto._();
  @$core.override
  StringResultProto createEmptyInstance() => create();
  static $pb.PbList<StringResultProto> createRepeated() =>
      $pb.PbList<StringResultProto>();
  @$core.pragma('dart2js:noInline')
  static StringResultProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StringResultProto>(create);
  static StringResultProto? _defaultInstance;

  /// The string value entered by the user.
  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

/// *
///  Represents the client's locale settings.
class LocaleProto extends $pb.GeneratedMessage {
  factory LocaleProto({
    $core.String? localeCode,
  }) {
    final result = create();
    if (localeCode != null) result.localeCode = localeCode;
    return result;
  }

  LocaleProto._();

  factory LocaleProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LocaleProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LocaleProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'localeCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocaleProto clone() => LocaleProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocaleProto copyWith(void Function(LocaleProto) updates) =>
      super.copyWith((message) => updates(message as LocaleProto))
          as LocaleProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocaleProto create() => LocaleProto._();
  @$core.override
  LocaleProto createEmptyInstance() => create();
  static $pb.PbList<LocaleProto> createRepeated() => $pb.PbList<LocaleProto>();
  @$core.pragma('dart2js:noInline')
  static LocaleProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LocaleProto>(create);
  static LocaleProto? _defaultInstance;

  /// The IETF BCP 47 language tag (e.g., "en-US", "tr-TR").
  @$pb.TagNumber(1)
  $core.String get localeCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set localeCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocaleCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocaleCode() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
