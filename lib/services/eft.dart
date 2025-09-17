
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// UUID generator for transaction IDs
class Uuid {
  String v4() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

// StartTransaction class for EFT transactions
class StartTransaction {
  final String sourceid;
  final String amount;
  final String type;
  final bool success;
  
  StartTransaction({
    required this.sourceid,
    required this.amount,
    required this.type,
    required this.success,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'sourceid': sourceid,
      'amount': amount,
      'type': type,
      'success': success,
    };
  }
}

// ErrorMessage class for EFT error handling
class ErrorMessage {
  final int status;
  final String message;
  
  ErrorMessage({
    required this.status,
    required this.message,
  });
  
  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      status: json['status'] ?? 0,
      message: json['message'] ?? 'Unknown error',
    );
  }
}

// TxnMessage class for EFT communication
class TxnMessage {
  final String? resultCode;
  final String displayText;
  final String? resultCodeDescription;
  
  const TxnMessage({
    this.resultCode,
    required this.displayText,
    this.resultCodeDescription,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'resultCode': resultCode,
      'displayText': displayText,
      'resultCodeDescription': resultCodeDescription,
    };
  }
  
  factory TxnMessage.fromJson(Map<String, dynamic> json) {
    return TxnMessage(
      resultCode: json['resultCode'],
      displayText: json['displayText'] ?? '',
      resultCodeDescription: json['resultCodeDescription'],
    );
  }

  TxnMessage copyWith({
    String? resultCode,
    String? displayText,
    String? resultCodeDescription,
  }) {
    return TxnMessage(
      resultCode: resultCode ?? this.resultCode,
      displayText: displayText ?? this.displayText,
      resultCodeDescription: resultCodeDescription ?? this.resultCodeDescription,
    );
  }
}

class NiVm extends GetxController {
  static const String address = '127.0.0.1';
  static const int port = 9000; // Update to actual EFT server port
  Socket? _socket;

  Stream<Uint8List>? _socketStream;
  final RxBool _channelOpen = false.obs;
  final RxList<TxnMessage?> logs = <TxnMessage?>[].obs;
  final RxString message = "".obs;
  final RxBool isConnecting = false.obs;

  // Getter for channelOpen
  bool get channelOpen => _channelOpen.value;

  bool onTranscation = false;
  Completer<String?> completer = Completer<String?>();
  StringBuffer buffer = StringBuffer();
  StreamSubscription? subscription;

  Future<bool> connectToAndroidPas() async {
    if (_socket == null || !_channelOpen.value) {
      isConnecting.value = true;
      logs.add(
        const TxnMessage(displayText: "Attempting to connect to EFT Machine"),
      );
      logs.refresh();
      try {
        _socket = await Socket.connect(
          address,
          port,
        ).timeout(const Duration(seconds: 5));
        _socketStream = _socket!.asBroadcastStream();
        _channelOpen.value = true;
        logWrite("Connected to EFT Machine");
        logs.add(const TxnMessage(displayText: "Connected to EFT Machine"));
        isConnecting.value = false;
        logs.refresh();
        return true;
      } catch (e) {
        logWrite("error: ${e.toString()}");
        logs.add(TxnMessage(displayText: "Connection error: ${e.toString()}"));
        resetConnection();
        isConnecting.value = false;
        logs.refresh();
        return false;
      }
    }
    return true;
  }

  Future<TxnMessage?> getStatus() async {
    message.value = "getStatus()";
    logs.add(TxnMessage(displayText: message.value));
    logs.refresh();

    TxnMessage? response = await sendToAndroidPas(message.value);
    logs.add(response ?? const TxnMessage(displayText: "No response"));
    logs.refresh();
    return response;
  }

  Future<void> sendMessage() async {
    if (message.value.isEmpty) return;

    logs.add(TxnMessage(displayText: message.value));
    logs.refresh();
    await sendToAndroidPas(message.value)
        .then((response) {
          logs.add(response);
          logs.refresh();
        })
        .catchError((error) {
          logs.add(
            TxnMessage(
              resultCode: '10',
              displayText: 'Send message error',
              resultCodeDescription: error.toString(),
            ),
          );
          logs.refresh();
        });
    message.value = "";
    update();
  }

  Future<TxnMessage?> sendToAndroidPas(String message) async {
    if (!await connectToAndroidPas()) {
      return const TxnMessage(
        resultCode: '10',
        displayText: "Eft Connection error",
      );
    }
    logWrite("Eft Req: $message");
    try {
      _socket!.write('$message\n');
    } catch (e) {
      logWrite("Socket write error: ${e.toString()}");
      resetConnection();
      return const TxnMessage(
        resultCode: '10',
        displayText: "Socket write error",
        resultCodeDescription: "Socket write error",
      );
    }
    if (_socket == null) return null;
    return _handleAndroidPasResponse(await _readLineFromSocket() ?? "");
  }

  Future<bool> startTransaction(double amount) async {
    onTranscation = true;
    // Business rule: transmit only whole currency units * 100 (drop cents).
    // Example: 20.50 -> 2000, 20.00 -> 2000
    final intUnits = amount.floor();
    StartTransaction startTransaction = StartTransaction(
      sourceid: Uuid().v4(),
      amount: (intUnits * 100).toString(), // Amount in smallest unit (no cents)
      type: 'eposSale',
      success: false,
    );

    // Serialize the transaction message and update the logs
    message.value =
        "startTransaction ${json.encode(startTransaction.toJson())}";
    logs.add(TxnMessage(displayText: message.value));
    logs.refresh();

    // Send the transaction request to the Android device
    TxnMessage? response = await sendToAndroidPas(message.value);
    logs.add(
      response ?? const TxnMessage(displayText: "No response from device."),
    );
    logs.refresh();

    // Check if the transaction initiation failed
    // if (response == null || response.resultCode != '00') {
    // logs.add(const TxnMessage(displayText: "Transaction initiation failed."));
    // logs.refresh();
    // return false;
    // }

    // Start polling for transaction status
    while (onTranscation) {
      await Future.delayed(const Duration(seconds: 1));

      // Get the transaction status
      TxnMessage? statusResponse = await getStatus();

      if (statusResponse == null ||
          !statusResponse.toJson().containsKey('resultCode')) {
        logs.add(statusResponse);
        logs.refresh();
        continue; // Retry the loop if status fetching failed
      }

      // Handle the transaction result based on the status response
      if (statusResponse.resultCode == '00') {
        logs.add(statusResponse);
        logs.refresh();

        // Request the final result from the Android device
        logs.add(const TxnMessage(displayText: "Fetching result..."));
        TxnMessage? finalResult = await sendToAndroidPas("getResult()");

        logs.add(
          finalResult ??
              const TxnMessage(displayText: "No final result received."),
        );
        logs.refresh();

        onTranscation = false;
        return true; // Transaction successful
      } else {
        logs.add(statusResponse);
        logs.refresh();
        onTranscation = false;
        return false; // Transaction failed
      }
    }

    return false; // Fallback in case the loop breaks unexpectedly
  }

  TxnMessage _handleAndroidPasResponse(String response) {
    logWrite("Eft Res: $response");
    try {
      if (response.startsWith("connected")) {
        return const TxnMessage(displayText: "CONNECTED");
      } else if (response.startsWith("transaction")) {
        var txnMessage = TxnMessage.fromJson(
          json.decode(response.substring(12)) as Map<String, dynamic>,
        );
        if ([
          'Card Not Valid',
          'No card detected. Cancelling transaction.',
          'PED Not Connected',
          'PIN Entry cancelled by user, remove card and click OK.',
        ].contains(txnMessage.displayText)) {
          sendToAndroidPas("cancelTransaction()");
          return txnMessage.copyWith(
            resultCode: '95',
            resultCodeDescription: txnMessage.displayText,
          );
        }
        return txnMessage;
      } else if (response.startsWith("error")) {
        return TxnMessage(
          resultCode: '10',
          displayText: 'Error: ${response.substring(6)}',
          resultCodeDescription: response.substring(6),
        );
      }
    } catch (e) {
      logWrite("Response handling error: ${e.toString()}");
      return const TxnMessage(
        resultCode: '10',
        displayText: "Invalid response format",
        resultCodeDescription: "Invalid response format",
      );
    }
    return const TxnMessage(
      resultCode: '10',
      displayText: "Command timed out",
      resultCodeDescription: "Command timed out",
    );
  }

  Future<String?> _readLineFromSocket() async {
    completer = Completer<String?>();
    buffer.clear();

    subscription = _socketStream?.listen(
      (List<int> data) {
        buffer.write(utf8.decode(data));
        if (buffer.toString().endsWith('\n')) {
          if (!completer.isCompleted) {
            completer.complete(buffer.toString().trim());
          }
          subscription?.cancel();
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          logWrite("Socket read error: ${error.toString()}");
          completer.completeError(error);
        }
        subscription?.cancel();
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        subscription?.cancel();
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (!completer.isCompleted) {
          logWrite("Read operation timed out");
          completer.completeError(TimeoutException("Read timed out"));
        }
        subscription?.cancel();
        return null;
      },
    );
  }

  static String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  static void logWrite(String message) {
    if (kDebugMode) {
      print('[EFT] $message');
    }
  }

  // Missing ErrorMessage property
  static String get ErrorMessage => "EFT Error occurred";

  void resetConnection() {
    _channelOpen.value = false;
    _socket?.destroy();
    _socket = null;
  }
}

class ScoData {
  static String transactionProcess = '';
  static String transactionStatus = '';
  static String? authCode;
  static String? maskCardNumber;
  static String? expiryDate;
  static String? transactionVat;
  static String? transactionTotalCard;
  static String? lastItemDescription;
  static String? errorMessage;
}
