// Freezed-style immutable data class for EFT transactions
class StartTransaction {
  final String? sourceid;
  final String? amount;
  final bool? success;
  final String? type;

  const StartTransaction({
    this.sourceid,
    this.amount,
    this.success,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      if (sourceid != null) 'sourceid': sourceid,
      if (amount != null) 'amount': amount,
      if (success != null) 'success': success,
      if (type != null) 'type': type,
    };
  }

  factory StartTransaction.fromJson(Map<String, dynamic> json) {
    return StartTransaction(
      sourceid: json['sourceid'] as String?,
      amount: json['amount'] as String?,
      success: json['success'] as bool?,
      type: json['type'] as String?,
    );
  }

  @override
  String toString() {
    return 'StartTransaction(sourceid: $sourceid, amount: $amount, success: $success, type: $type)';
  }

  StartTransaction copyWith({
    String? sourceid,
    String? amount,
    bool? success,
    String? type,
  }) {
    return StartTransaction(
      sourceid: sourceid ?? this.sourceid,
      amount: amount ?? this.amount,
      success: success ?? this.success,
      type: type ?? this.type,
    );
  }
}

// EFT Response class
class EftResponse {
  final String? resultCode;
  final String? displayText;
  final String? errorMessage;
  final bool? success;

  const EftResponse({
    this.resultCode,
    this.displayText,
    this.errorMessage,
    this.success,
  });

  Map<String, dynamic> toJson() {
    return {
      if (resultCode != null) 'resultCode': resultCode,
      if (displayText != null) 'displayText': displayText,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (success != null) 'success': success,
    };
  }

  factory EftResponse.fromJson(Map<String, dynamic> json) {
    return EftResponse(
      resultCode: json['resultCode'] as String?,
      displayText: json['displayText'] as String?,
      errorMessage: json['errorMessage'] as String?,
      success: json['success'] as bool?,
    );
  }

  @override
  String toString() {
    return 'EftResponse(resultCode: $resultCode, displayText: $displayText, errorMessage: $errorMessage, success: $success)';
  }
}
