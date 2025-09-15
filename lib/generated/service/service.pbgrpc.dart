// This is a generated file - do not edit.
//
// Generated from service/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common/requests.pb.dart' as $7;
import '../domain/create_transaction.pb.dart' as $3;
import '../domain/get_line_items.pb.dart' as $8;
import '../domain/item.pb.dart' as $5;
import '../domain/lane.pb.dart' as $0;
import '../domain/line_item.pb.dart' as $6;
import '../domain/make_payment.pb.dart' as $11;
import '../domain/make_payment_interactive.pb.dart' as $12;
import '../domain/print_report.pb.dart' as $14;
import '../domain/quick_lookup.pb.dart' as $2;
import '../domain/set_customer.pb.dart' as $4;
import '../domain/tender.pb.dart' as $10;
import '../domain/totals.pb.dart' as $9;
import '../domain/void_item.pb.dart' as $13;
import '../google/protobuf/empty.pb.dart' as $1;

export 'service.pb.dart';

/// *
///  The primary service definition for the Point-of-Sale Business Component (POSBC).
///  This service exposes all core functionalities for a self-checkout (SCO) lane.
@$pb.GrpcServiceName('service.PosService')
class PosServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PosServiceClient(super.channel, {super.options, super.interceptors});

  /// Initializes a session for a specific lane. Must be the first call.
  $grpc.ResponseFuture<$1.Empty> initialize(
    $0.LaneRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$initialize, request, options: options);
  }

  /// Gracefully shuts down the session for the lane.
  $grpc.ResponseFuture<$1.Empty> shutdown(
    $1.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shutdown, request, options: options);
  }

  /// Retrieves the list of all Quick Lookup (PLU) items, categorized for UI display.
  $grpc.ResponseFuture<$2.GetQuickLookupItemsResponseProto> getQuickLookupItems(
    $1.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getQuickLookupItems, request, options: options);
  }

  /// Creates a new, empty transaction and returns its unique ID.
  $grpc.ResponseFuture<$3.CreateTransactionResponseProto> createTransaction(
    $3.CreateTransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createTransaction, request, options: options);
  }

  /// Associates a customer with the current transaction.
  $grpc.ResponseFuture<$1.Empty> setCustomer(
    $4.SetCustomerRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setCustomer, request, options: options);
  }

  /// Retrieves the full details of a single item from the catalog by its barcode.
  $grpc.ResponseFuture<$5.ItemResponseProto> getItem(
    $5.GetItemRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getItem, request, options: options);
  }

  /// Adds an item to the transaction by quantity.
  $grpc.ResponseFuture<$6.LineItemResponseProto> addItemByQuantity(
    $6.AddItemByQuantityRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addItemByQuantity, request, options: options);
  }

  /// Adds an item to the transaction by weight.
  $grpc.ResponseFuture<$6.LineItemResponseProto> addItemByWeight(
    $6.AddItemByWeightRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addItemByWeight, request, options: options);
  }

  /// Retrieves all current line items in the transaction basket.
  $grpc.ResponseFuture<$8.GetLineItemsResponseProto> getLineItems(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLineItems, request, options: options);
  }

  /// Retrieves the current financial totals for the transaction.
  $grpc.ResponseFuture<$9.TotalsResponseProto> getTotals(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTotals, request, options: options);
  }

  /// A signal to the server to apply any pre-payment calculations or promotions before make payment.
  $grpc.ResponseFuture<$1.Empty> applyPrePaymentOperations(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyPrePaymentOperations, request,
        options: options);
  }

  /// A signal to the server to roll back any pre-payment operations and continue to purchase.
  $grpc.ResponseFuture<$1.Empty> rollbackPrePaymentOperations(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rollbackPrePaymentOperations, request,
        options: options);
  }

  /// Retrieves the list of payment methods (tenders) available for the current transaction.
  $grpc.ResponseFuture<$10.GetTendersResponseProto> getTenders(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTenders, request, options: options);
  }

  /// Performs a simple, single-step payment.
  $grpc.ResponseFuture<$1.Empty> makePayment(
    $11.MakePaymentRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$makePayment, request, options: options);
  }

  /// Initiates a multi-step, interactive payment flow using a bidirectional stream.
  /// The client starts by sending a ClientPaymentActionProto with `start_payment` set.
  /// The server responds with a stream of ServerPaymentActionProto messages containing `prompt`s.
  /// The client responds to each prompt with a ClientPaymentActionProto containing a `prompt_result`.
  /// The flow concludes when the server sends a final `completion_status`.
  $grpc.ResponseStream<$12.ServerActionProto> makePaymentInteractive(
    $async.Stream<$12.ClientPaymentActionProto> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$makePaymentInteractive, request,
        options: options);
  }

  /// Finalizes the transaction after successful payment.
  $grpc.ResponseFuture<$1.Empty> completeTransaction(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$completeTransaction, request, options: options);
  }

  /// Voids a specific line item from the transaction.
  $grpc.ResponseFuture<$1.Empty> voidItem(
    $13.VoidItemRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$voidItem, request, options: options);
  }

  /// Voids the entire transaction.
  $grpc.ResponseFuture<$1.Empty> voidTransaction(
    $7.TransactionRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$voidTransaction, request, options: options);
  }

  /// Requests the printing of a system report (e.g., end-of-day Z report).
  $grpc.ResponseFuture<$1.Empty> printReport(
    $14.PrintReportRequestProto request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$printReport, request, options: options);
  }

  // method descriptors

  static final _$initialize = $grpc.ClientMethod<$0.LaneRequestProto, $1.Empty>(
      '/service.PosService/Initialize',
      ($0.LaneRequestProto value) => value.writeToBuffer(),
      $1.Empty.fromBuffer);
  static final _$shutdown = $grpc.ClientMethod<$1.Empty, $1.Empty>(
      '/service.PosService/Shutdown',
      ($1.Empty value) => value.writeToBuffer(),
      $1.Empty.fromBuffer);
  static final _$getQuickLookupItems =
      $grpc.ClientMethod<$1.Empty, $2.GetQuickLookupItemsResponseProto>(
          '/service.PosService/GetQuickLookupItems',
          ($1.Empty value) => value.writeToBuffer(),
          $2.GetQuickLookupItemsResponseProto.fromBuffer);
  static final _$createTransaction = $grpc.ClientMethod<
          $3.CreateTransactionRequestProto, $3.CreateTransactionResponseProto>(
      '/service.PosService/CreateTransaction',
      ($3.CreateTransactionRequestProto value) => value.writeToBuffer(),
      $3.CreateTransactionResponseProto.fromBuffer);
  static final _$setCustomer =
      $grpc.ClientMethod<$4.SetCustomerRequestProto, $1.Empty>(
          '/service.PosService/SetCustomer',
          ($4.SetCustomerRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$getItem =
      $grpc.ClientMethod<$5.GetItemRequestProto, $5.ItemResponseProto>(
          '/service.PosService/GetItem',
          ($5.GetItemRequestProto value) => value.writeToBuffer(),
          $5.ItemResponseProto.fromBuffer);
  static final _$addItemByQuantity = $grpc.ClientMethod<
          $6.AddItemByQuantityRequestProto, $6.LineItemResponseProto>(
      '/service.PosService/AddItemByQuantity',
      ($6.AddItemByQuantityRequestProto value) => value.writeToBuffer(),
      $6.LineItemResponseProto.fromBuffer);
  static final _$addItemByWeight = $grpc.ClientMethod<
          $6.AddItemByWeightRequestProto, $6.LineItemResponseProto>(
      '/service.PosService/AddItemByWeight',
      ($6.AddItemByWeightRequestProto value) => value.writeToBuffer(),
      $6.LineItemResponseProto.fromBuffer);
  static final _$getLineItems = $grpc.ClientMethod<$7.TransactionRequestProto,
          $8.GetLineItemsResponseProto>(
      '/service.PosService/GetLineItems',
      ($7.TransactionRequestProto value) => value.writeToBuffer(),
      $8.GetLineItemsResponseProto.fromBuffer);
  static final _$getTotals =
      $grpc.ClientMethod<$7.TransactionRequestProto, $9.TotalsResponseProto>(
          '/service.PosService/GetTotals',
          ($7.TransactionRequestProto value) => value.writeToBuffer(),
          $9.TotalsResponseProto.fromBuffer);
  static final _$applyPrePaymentOperations =
      $grpc.ClientMethod<$7.TransactionRequestProto, $1.Empty>(
          '/service.PosService/ApplyPrePaymentOperations',
          ($7.TransactionRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$rollbackPrePaymentOperations =
      $grpc.ClientMethod<$7.TransactionRequestProto, $1.Empty>(
          '/service.PosService/RollbackPrePaymentOperations',
          ($7.TransactionRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$getTenders = $grpc.ClientMethod<$7.TransactionRequestProto,
          $10.GetTendersResponseProto>(
      '/service.PosService/GetTenders',
      ($7.TransactionRequestProto value) => value.writeToBuffer(),
      $10.GetTendersResponseProto.fromBuffer);
  static final _$makePayment =
      $grpc.ClientMethod<$11.MakePaymentRequestProto, $1.Empty>(
          '/service.PosService/MakePayment',
          ($11.MakePaymentRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$makePaymentInteractive =
      $grpc.ClientMethod<$12.ClientPaymentActionProto, $12.ServerActionProto>(
          '/service.PosService/MakePaymentInteractive',
          ($12.ClientPaymentActionProto value) => value.writeToBuffer(),
          $12.ServerActionProto.fromBuffer);
  static final _$completeTransaction =
      $grpc.ClientMethod<$7.TransactionRequestProto, $1.Empty>(
          '/service.PosService/CompleteTransaction',
          ($7.TransactionRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$voidItem =
      $grpc.ClientMethod<$13.VoidItemRequestProto, $1.Empty>(
          '/service.PosService/VoidItem',
          ($13.VoidItemRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$voidTransaction =
      $grpc.ClientMethod<$7.TransactionRequestProto, $1.Empty>(
          '/service.PosService/VoidTransaction',
          ($7.TransactionRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$printReport =
      $grpc.ClientMethod<$14.PrintReportRequestProto, $1.Empty>(
          '/service.PosService/PrintReport',
          ($14.PrintReportRequestProto value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
}

@$pb.GrpcServiceName('service.PosService')
abstract class PosServiceBase extends $grpc.Service {
  $core.String get $name => 'service.PosService';

  PosServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LaneRequestProto, $1.Empty>(
        'Initialize',
        initialize_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LaneRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $1.Empty>(
        'Shutdown',
        shutdown_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.Empty, $2.GetQuickLookupItemsResponseProto>(
            'GetQuickLookupItems',
            getQuickLookupItems_Pre,
            false,
            false,
            ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
            ($2.GetQuickLookupItemsResponseProto value) =>
                value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.CreateTransactionRequestProto,
            $3.CreateTransactionResponseProto>(
        'CreateTransaction',
        createTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $3.CreateTransactionRequestProto.fromBuffer(value),
        ($3.CreateTransactionResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.SetCustomerRequestProto, $1.Empty>(
        'SetCustomer',
        setCustomer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $4.SetCustomerRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$5.GetItemRequestProto, $5.ItemResponseProto>(
            'GetItem',
            getItem_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $5.GetItemRequestProto.fromBuffer(value),
            ($5.ItemResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.AddItemByQuantityRequestProto,
            $6.LineItemResponseProto>(
        'AddItemByQuantity',
        addItemByQuantity_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.AddItemByQuantityRequestProto.fromBuffer(value),
        ($6.LineItemResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.AddItemByWeightRequestProto,
            $6.LineItemResponseProto>(
        'AddItemByWeight',
        addItemByWeight_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.AddItemByWeightRequestProto.fromBuffer(value),
        ($6.LineItemResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto,
            $8.GetLineItemsResponseProto>(
        'GetLineItems',
        getLineItems_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($8.GetLineItemsResponseProto value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$7.TransactionRequestProto, $9.TotalsResponseProto>(
            'GetTotals',
            getTotals_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $7.TransactionRequestProto.fromBuffer(value),
            ($9.TotalsResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto, $1.Empty>(
        'ApplyPrePaymentOperations',
        applyPrePaymentOperations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto, $1.Empty>(
        'RollbackPrePaymentOperations',
        rollbackPrePaymentOperations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto,
            $10.GetTendersResponseProto>(
        'GetTenders',
        getTenders_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($10.GetTendersResponseProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$11.MakePaymentRequestProto, $1.Empty>(
        'MakePayment',
        makePayment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $11.MakePaymentRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$12.ClientPaymentActionProto,
            $12.ServerActionProto>(
        'MakePaymentInteractive',
        makePaymentInteractive,
        true,
        true,
        ($core.List<$core.int> value) =>
            $12.ClientPaymentActionProto.fromBuffer(value),
        ($12.ServerActionProto value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto, $1.Empty>(
        'CompleteTransaction',
        completeTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$13.VoidItemRequestProto, $1.Empty>(
        'VoidItem',
        voidItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $13.VoidItemRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.TransactionRequestProto, $1.Empty>(
        'VoidTransaction',
        voidTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $7.TransactionRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$14.PrintReportRequestProto, $1.Empty>(
        'PrintReport',
        printReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $14.PrintReportRequestProto.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> initialize_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LaneRequestProto> $request) async {
    return initialize($call, await $request);
  }

  $async.Future<$1.Empty> initialize(
      $grpc.ServiceCall call, $0.LaneRequestProto request);

  $async.Future<$1.Empty> shutdown_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.Empty> $request) async {
    return shutdown($call, await $request);
  }

  $async.Future<$1.Empty> shutdown($grpc.ServiceCall call, $1.Empty request);

  $async.Future<$2.GetQuickLookupItemsResponseProto> getQuickLookupItems_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.Empty> $request) async {
    return getQuickLookupItems($call, await $request);
  }

  $async.Future<$2.GetQuickLookupItemsResponseProto> getQuickLookupItems(
      $grpc.ServiceCall call, $1.Empty request);

  $async.Future<$3.CreateTransactionResponseProto> createTransaction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$3.CreateTransactionRequestProto> $request) async {
    return createTransaction($call, await $request);
  }

  $async.Future<$3.CreateTransactionResponseProto> createTransaction(
      $grpc.ServiceCall call, $3.CreateTransactionRequestProto request);

  $async.Future<$1.Empty> setCustomer_Pre($grpc.ServiceCall $call,
      $async.Future<$4.SetCustomerRequestProto> $request) async {
    return setCustomer($call, await $request);
  }

  $async.Future<$1.Empty> setCustomer(
      $grpc.ServiceCall call, $4.SetCustomerRequestProto request);

  $async.Future<$5.ItemResponseProto> getItem_Pre($grpc.ServiceCall $call,
      $async.Future<$5.GetItemRequestProto> $request) async {
    return getItem($call, await $request);
  }

  $async.Future<$5.ItemResponseProto> getItem(
      $grpc.ServiceCall call, $5.GetItemRequestProto request);

  $async.Future<$6.LineItemResponseProto> addItemByQuantity_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$6.AddItemByQuantityRequestProto> $request) async {
    return addItemByQuantity($call, await $request);
  }

  $async.Future<$6.LineItemResponseProto> addItemByQuantity(
      $grpc.ServiceCall call, $6.AddItemByQuantityRequestProto request);

  $async.Future<$6.LineItemResponseProto> addItemByWeight_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$6.AddItemByWeightRequestProto> $request) async {
    return addItemByWeight($call, await $request);
  }

  $async.Future<$6.LineItemResponseProto> addItemByWeight(
      $grpc.ServiceCall call, $6.AddItemByWeightRequestProto request);

  $async.Future<$8.GetLineItemsResponseProto> getLineItems_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return getLineItems($call, await $request);
  }

  $async.Future<$8.GetLineItemsResponseProto> getLineItems(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$9.TotalsResponseProto> getTotals_Pre($grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return getTotals($call, await $request);
  }

  $async.Future<$9.TotalsResponseProto> getTotals(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$1.Empty> applyPrePaymentOperations_Pre($grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return applyPrePaymentOperations($call, await $request);
  }

  $async.Future<$1.Empty> applyPrePaymentOperations(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$1.Empty> rollbackPrePaymentOperations_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return rollbackPrePaymentOperations($call, await $request);
  }

  $async.Future<$1.Empty> rollbackPrePaymentOperations(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$10.GetTendersResponseProto> getTenders_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return getTenders($call, await $request);
  }

  $async.Future<$10.GetTendersResponseProto> getTenders(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$1.Empty> makePayment_Pre($grpc.ServiceCall $call,
      $async.Future<$11.MakePaymentRequestProto> $request) async {
    return makePayment($call, await $request);
  }

  $async.Future<$1.Empty> makePayment(
      $grpc.ServiceCall call, $11.MakePaymentRequestProto request);

  $async.Stream<$12.ServerActionProto> makePaymentInteractive(
      $grpc.ServiceCall call,
      $async.Stream<$12.ClientPaymentActionProto> request);

  $async.Future<$1.Empty> completeTransaction_Pre($grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return completeTransaction($call, await $request);
  }

  $async.Future<$1.Empty> completeTransaction(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$1.Empty> voidItem_Pre($grpc.ServiceCall $call,
      $async.Future<$13.VoidItemRequestProto> $request) async {
    return voidItem($call, await $request);
  }

  $async.Future<$1.Empty> voidItem(
      $grpc.ServiceCall call, $13.VoidItemRequestProto request);

  $async.Future<$1.Empty> voidTransaction_Pre($grpc.ServiceCall $call,
      $async.Future<$7.TransactionRequestProto> $request) async {
    return voidTransaction($call, await $request);
  }

  $async.Future<$1.Empty> voidTransaction(
      $grpc.ServiceCall call, $7.TransactionRequestProto request);

  $async.Future<$1.Empty> printReport_Pre($grpc.ServiceCall $call,
      $async.Future<$14.PrintReportRequestProto> $request) async {
    return printReport($call, await $request);
  }

  $async.Future<$1.Empty> printReport(
      $grpc.ServiceCall call, $14.PrintReportRequestProto request);
}
