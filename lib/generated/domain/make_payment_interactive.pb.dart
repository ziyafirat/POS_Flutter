// This is a generated file - do not edit.
//
// Generated from domain/make_payment_interactive.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'interaction_message.pb.dart' as $0;
import 'payment.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ClientPaymentActionProto_ActionType { startPayment, promptResult, notSet }

/// *
///  A wrapper for any message sent from the client to the server during an
///  interactive payment flow.
class ClientPaymentActionProto extends $pb.GeneratedMessage {
  factory ClientPaymentActionProto({
    $core.String? interactionAttemptId,
    StartPaymentProto? startPayment,
    $0.PromptResultProto? promptResult,
  }) {
    final result = create();
    if (interactionAttemptId != null)
      result.interactionAttemptId = interactionAttemptId;
    if (startPayment != null) result.startPayment = startPayment;
    if (promptResult != null) result.promptResult = promptResult;
    return result;
  }

  ClientPaymentActionProto._();

  factory ClientPaymentActionProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientPaymentActionProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientPaymentActionProto_ActionType>
      _ClientPaymentActionProto_ActionTypeByTag = {
    2: ClientPaymentActionProto_ActionType.startPayment,
    3: ClientPaymentActionProto_ActionType.promptResult,
    0: ClientPaymentActionProto_ActionType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientPaymentActionProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'interactionAttemptId')
    ..aOM<StartPaymentProto>(2, _omitFieldNames ? '' : 'startPayment',
        subBuilder: StartPaymentProto.create)
    ..aOM<$0.PromptResultProto>(3, _omitFieldNames ? '' : 'promptResult',
        subBuilder: $0.PromptResultProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientPaymentActionProto clone() =>
      ClientPaymentActionProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientPaymentActionProto copyWith(
          void Function(ClientPaymentActionProto) updates) =>
      super.copyWith((message) => updates(message as ClientPaymentActionProto))
          as ClientPaymentActionProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientPaymentActionProto create() => ClientPaymentActionProto._();
  @$core.override
  ClientPaymentActionProto createEmptyInstance() => create();
  static $pb.PbList<ClientPaymentActionProto> createRepeated() =>
      $pb.PbList<ClientPaymentActionProto>();
  @$core.pragma('dart2js:noInline')
  static ClientPaymentActionProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientPaymentActionProto>(create);
  static ClientPaymentActionProto? _defaultInstance;

  ClientPaymentActionProto_ActionType whichActionType() =>
      _ClientPaymentActionProto_ActionTypeByTag[$_whichOneof(0)]!;
  void clearActionType() => $_clearField($_whichOneof(0));

  /// A client-generated unique identifier for this entire payment attempt.
  /// This MUST be included in every message from the client for this flow.
  @$pb.TagNumber(1)
  $core.String get interactionAttemptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set interactionAttemptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInteractionAttemptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInteractionAttemptId() => $_clearField(1);

  /// The VERY FIRST message from the client to initiate a new payment flow.
  @$pb.TagNumber(2)
  StartPaymentProto get startPayment => $_getN(1);
  @$pb.TagNumber(2)
  set startPayment(StartPaymentProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartPayment() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartPayment() => $_clearField(2);
  @$pb.TagNumber(2)
  StartPaymentProto ensureStartPayment() => $_ensure(1);

  /// Any subsequent message from the client, containing the result of a UI prompt.
  @$pb.TagNumber(3)
  $0.PromptResultProto get promptResult => $_getN(2);
  @$pb.TagNumber(3)
  set promptResult($0.PromptResultProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPromptResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearPromptResult() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.PromptResultProto ensurePromptResult() => $_ensure(2);
}

/// *
///  The initial message from the client to begin an interactive payment.
class StartPaymentProto extends $pb.GeneratedMessage {
  factory StartPaymentProto({
    $core.String? posTxId,
    $1.PaymentProto? paymentDetails,
  }) {
    final result = create();
    if (posTxId != null) result.posTxId = posTxId;
    if (paymentDetails != null) result.paymentDetails = paymentDetails;
    return result;
  }

  StartPaymentProto._();

  factory StartPaymentProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPaymentProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPaymentProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'posTxId')
    ..aOM<$1.PaymentProto>(2, _omitFieldNames ? '' : 'paymentDetails',
        subBuilder: $1.PaymentProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPaymentProto clone() => StartPaymentProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPaymentProto copyWith(void Function(StartPaymentProto) updates) =>
      super.copyWith((message) => updates(message as StartPaymentProto))
          as StartPaymentProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPaymentProto create() => StartPaymentProto._();
  @$core.override
  StartPaymentProto createEmptyInstance() => create();
  static $pb.PbList<StartPaymentProto> createRepeated() =>
      $pb.PbList<StartPaymentProto>();
  @$core.pragma('dart2js:noInline')
  static StartPaymentProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPaymentProto>(create);
  static StartPaymentProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get posTxId => $_getSZ(0);
  @$pb.TagNumber(1)
  set posTxId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosTxId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosTxId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaymentProto get paymentDetails => $_getN(1);
  @$pb.TagNumber(2)
  set paymentDetails($1.PaymentProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentDetails() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaymentProto ensurePaymentDetails() => $_ensure(1);
}

enum ServerActionProto_ActionType {
  prompt,
  completionStatus,
  closePrompt,
  notSet
}

/// *
///  A wrapper for any message sent from the server to the client during an
///  interactive payment flow.
class ServerActionProto extends $pb.GeneratedMessage {
  factory ServerActionProto({
    $core.String? interactionAttemptId,
    $0.PromptProto? prompt,
    CompletionStatusProto? completionStatus,
    ClosePromptProto? closePrompt,
  }) {
    final result = create();
    if (interactionAttemptId != null)
      result.interactionAttemptId = interactionAttemptId;
    if (prompt != null) result.prompt = prompt;
    if (completionStatus != null) result.completionStatus = completionStatus;
    if (closePrompt != null) result.closePrompt = closePrompt;
    return result;
  }

  ServerActionProto._();

  factory ServerActionProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerActionProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerActionProto_ActionType>
      _ServerActionProto_ActionTypeByTag = {
    2: ServerActionProto_ActionType.prompt,
    3: ServerActionProto_ActionType.completionStatus,
    4: ServerActionProto_ActionType.closePrompt,
    0: ServerActionProto_ActionType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerActionProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'interactionAttemptId')
    ..aOM<$0.PromptProto>(2, _omitFieldNames ? '' : 'prompt',
        subBuilder: $0.PromptProto.create)
    ..aOM<CompletionStatusProto>(3, _omitFieldNames ? '' : 'completionStatus',
        subBuilder: CompletionStatusProto.create)
    ..aOM<ClosePromptProto>(4, _omitFieldNames ? '' : 'closePrompt',
        subBuilder: ClosePromptProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerActionProto clone() => ServerActionProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerActionProto copyWith(void Function(ServerActionProto) updates) =>
      super.copyWith((message) => updates(message as ServerActionProto))
          as ServerActionProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerActionProto create() => ServerActionProto._();
  @$core.override
  ServerActionProto createEmptyInstance() => create();
  static $pb.PbList<ServerActionProto> createRepeated() =>
      $pb.PbList<ServerActionProto>();
  @$core.pragma('dart2js:noInline')
  static ServerActionProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerActionProto>(create);
  static ServerActionProto? _defaultInstance;

  ServerActionProto_ActionType whichActionType() =>
      _ServerActionProto_ActionTypeByTag[$_whichOneof(0)]!;
  void clearActionType() => $_clearField($_whichOneof(0));

  /// The unique identifier for this payment attempt, echoing the client's original ID.
  @$pb.TagNumber(1)
  $core.String get interactionAttemptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set interactionAttemptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInteractionAttemptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInteractionAttemptId() => $_clearField(1);

  /// A command telling the client to render a specific UI prompt.
  @$pb.TagNumber(2)
  $0.PromptProto get prompt => $_getN(1);
  @$pb.TagNumber(2)
  set prompt($0.PromptProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.PromptProto ensurePrompt() => $_ensure(1);

  /// The FINAL message, indicating the entire payment flow has concluded.
  @$pb.TagNumber(3)
  CompletionStatusProto get completionStatus => $_getN(2);
  @$pb.TagNumber(3)
  set completionStatus(CompletionStatusProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCompletionStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompletionStatus() => $_clearField(3);
  @$pb.TagNumber(3)
  CompletionStatusProto ensureCompletionStatus() => $_ensure(2);

  /// A command to programmatically close a prompt that is currently being displayed.
  @$pb.TagNumber(4)
  ClosePromptProto get closePrompt => $_getN(3);
  @$pb.TagNumber(4)
  set closePrompt(ClosePromptProto value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClosePrompt() => $_has(3);
  @$pb.TagNumber(4)
  void clearClosePrompt() => $_clearField(4);
  @$pb.TagNumber(4)
  ClosePromptProto ensureClosePrompt() => $_ensure(3);
}

/// *
///  A command from the server to the client, instructing it to dismiss
///  the currently displayed prompt with the matching ID.
class ClosePromptProto extends $pb.GeneratedMessage {
  factory ClosePromptProto({
    $core.String? promptId,
  }) {
    final result = create();
    if (promptId != null) result.promptId = promptId;
    return result;
  }

  ClosePromptProto._();

  factory ClosePromptProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClosePromptProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClosePromptProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosePromptProto clone() => ClosePromptProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClosePromptProto copyWith(void Function(ClosePromptProto) updates) =>
      super.copyWith((message) => updates(message as ClosePromptProto))
          as ClosePromptProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClosePromptProto create() => ClosePromptProto._();
  @$core.override
  ClosePromptProto createEmptyInstance() => create();
  static $pb.PbList<ClosePromptProto> createRepeated() =>
      $pb.PbList<ClosePromptProto>();
  @$core.pragma('dart2js:noInline')
  static ClosePromptProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClosePromptProto>(create);
  static ClosePromptProto? _defaultInstance;

  /// The unique ID of the prompt that should be closed. This is used to
  /// prevent race conditions where this command could accidentally close a
  /// newer, different prompt.
  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);
}

/// *
///  The final status of the entire interaction flow. This is a terminal message.
class CompletionStatusProto extends $pb.GeneratedMessage {
  factory CompletionStatusProto({
    $core.bool? success,
    $core.String? finalMessage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (finalMessage != null) result.finalMessage = finalMessage;
    return result;
  }

  CompletionStatusProto._();

  factory CompletionStatusProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompletionStatusProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompletionStatusProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'domain'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'finalMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionStatusProto clone() =>
      CompletionStatusProto()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionStatusProto copyWith(
          void Function(CompletionStatusProto) updates) =>
      super.copyWith((message) => updates(message as CompletionStatusProto))
          as CompletionStatusProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompletionStatusProto create() => CompletionStatusProto._();
  @$core.override
  CompletionStatusProto createEmptyInstance() => create();
  static $pb.PbList<CompletionStatusProto> createRepeated() =>
      $pb.PbList<CompletionStatusProto>();
  @$core.pragma('dart2js:noInline')
  static CompletionStatusProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompletionStatusProto>(create);
  static CompletionStatusProto? _defaultInstance;

  /// `true` if the interaction flow was successful, `false` otherwise.
  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  /// The final, user-facing message to display on the client UI.
  @$pb.TagNumber(2)
  $core.String get finalMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set finalMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFinalMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearFinalMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
