import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Events Functions Enum
enum EventsFunctions {
  checkoutStart,
  checkoutEnd,
  checkoutVoid,
  checkoutSuspend,
  fraudAlert,
  fraudAlertFeedback,
  itemScan,
  itemInfo,
  itemReturn,
  itemVoid,
  assistance,
  assistanceOut,
  payment,
  priceCheck,
  voucherScan,
  onScreenItem,
  digitalProduct,
  cancelPayment,
  loyalty,
  scoPing,
  scoPong,
  ageInbound,
  uiEventAssistant,
  uiEventRegistration,
}

// MQTT Scan Types
enum MqttScanType {
  product,
  loyalty,
  voucher,
}

// MQTT UI Status
enum MqttUIStatus {
  assistant,
  registration,
  payment,
}

// MQTT Feedback Types
enum MqttFeedbackType {
  willRescan,
  willNotRescan,
  falsePositive,
  truePositive,
}

// Extension for enum JSON values
extension MqttScanTypeExtension on MqttScanType {
  String get jsonValue {
    switch (this) {
      case MqttScanType.product:
        return 'product';
      case MqttScanType.loyalty:
        return 'loyalty';
      case MqttScanType.voucher:
        return 'voucher';
    }
  }
}

extension MqttUIStatusExtension on MqttUIStatus {
  String get jsonValue {
    switch (this) {
      case MqttUIStatus.assistant:
        return 'assistant';
      case MqttUIStatus.registration:
        return 'registration';
      case MqttUIStatus.payment:
        return 'payment';
    }
  }
}

extension MqttFeedbackTypeExtension on MqttFeedbackType {
  String get jsonValue {
    switch (this) {
      case MqttFeedbackType.willRescan:
        return 'will_rescan';
      case MqttFeedbackType.willNotRescan:
        return 'will_not_rescan';
      case MqttFeedbackType.falsePositive:
        return 'false_positive';
      case MqttFeedbackType.truePositive:
        return 'true_positive';
    }
  }
}

// Events Functions Extension
extension EventsFunctionsExtension on EventsFunctions {
  Map<String, dynamic> get defaultPayload {
    final basePayload = {
      'id': _generateUuid(),
      'store_id': '123',
      'client_id': '500',
      'transaction_id': _generateUuid(),
      'checkout_id': '1',
      'timestamp': DateTime.now().toIso8601String(),
      'event_type': name,
    };

    return switch (this) {
      EventsFunctions.checkoutStart => {
        ...basePayload,
        'event_type': 'checkout_start',
      },
      EventsFunctions.checkoutEnd => {
        ...basePayload,
        'event_type': 'checkout_end',
      },
      EventsFunctions.checkoutVoid => {
        ...basePayload,
        'event_type': 'checkout_void',
      },
      EventsFunctions.checkoutSuspend => {
        ...basePayload,
        'event_type': 'checkout_suspend',
      },
      EventsFunctions.fraudAlert => {
        ...basePayload,
        'event_type': 'fraud_alert',
      },
      EventsFunctions.fraudAlertFeedback => {
        ...basePayload,
        'event_type': 'fraud_alert_feedback',
        'alert_id': _generateUuid(),
        'feedback_type': MqttFeedbackType.willRescan.jsonValue,
      },
      EventsFunctions.itemScan => {
        ...basePayload,
        'event_type': 'item_scan',
        'scan_type': MqttScanType.product.jsonValue,
      },
      EventsFunctions.itemInfo => {
        ...basePayload,
        'event_type': 'item_info',
        'scan_type': MqttScanType.product.jsonValue,
      },
      EventsFunctions.itemReturn => {
        ...basePayload,
        'event_type': 'item_return',
      },
      EventsFunctions.itemVoid => {
        ...basePayload,
        'event_type': 'item_void',
      },
      EventsFunctions.assistance => {
        ...basePayload,
        'event_type': 'assistance',
        'ui_status': MqttUIStatus.assistant.jsonValue,
      },
      EventsFunctions.assistanceOut => {
        ...basePayload,
        'event_type': 'assistance_out',
      },
      EventsFunctions.payment => {
        ...basePayload,
        'event_type': 'ui_event',
        'ui_status': MqttUIStatus.payment.jsonValue,
      },
      EventsFunctions.priceCheck => {
        ...basePayload,
        'event_type': 'price_check',
      },
      EventsFunctions.voucherScan => {
        ...basePayload,
        'event_type': 'voucher_scan',
      },
      EventsFunctions.onScreenItem => {
        ...basePayload,
        'event_type': 'on_screen_item',
      },
      EventsFunctions.digitalProduct => {
        ...basePayload,
        'event_type': 'digital_product',
      },
      EventsFunctions.cancelPayment => {
        ...basePayload,
        'event_type': 'ui_event',
        'ui_status': MqttUIStatus.registration.jsonValue,
      },
      EventsFunctions.loyalty => {
        ...basePayload,
        'event_type': 'loyalty',
      },
      EventsFunctions.scoPing => {
        ...basePayload,
        'event_type': 'sco_ping',
      },
      EventsFunctions.scoPong => {
        ...basePayload,
        'event_type': 'sco_pong',
      },
      EventsFunctions.ageInbound => {
        ...basePayload,
        'event_type': 'age_inbound',
        'age_verified': false,
      },
      EventsFunctions.uiEventAssistant => {
        ...basePayload,
        'event_type': 'ui_event',
        'ui_status': MqttUIStatus.assistant.jsonValue,
      },
      EventsFunctions.uiEventRegistration => {
        ...basePayload,
        'event_type': 'ui_event',
        'ui_status': MqttUIStatus.registration.jsonValue,
      },
    };
  }

  String get topic {
    return switch (this) {
      // Outbound topics: events originated by this app
      EventsFunctions.fraudAlertFeedback => 'ssco/idol/*/fraud/outbound',
      EventsFunctions.checkoutStart => 'ssco/idol/*/general/outbound',
      EventsFunctions.checkoutEnd => 'ssco/idol/*/general/outbound',
      EventsFunctions.checkoutVoid => 'ssco/idol/*/general/outbound',
      EventsFunctions.checkoutSuspend => 'ssco/idol/*/general/outbound',
      EventsFunctions.itemScan => 'ssco/idol/*/general/outbound',
      EventsFunctions.itemInfo => 'ssco/idol/*/general/outbound',
      EventsFunctions.itemReturn => 'ssco/idol/*/general/outbound',
      EventsFunctions.itemVoid => 'ssco/idol/*/general/outbound',
      EventsFunctions.assistance => 'ssco/idol/*/general/outbound',
      EventsFunctions.assistanceOut => 'ssco/idol/*/general/outbound',
      EventsFunctions.payment => 'ssco/idol/*/general/outbound',
      EventsFunctions.priceCheck => 'ssco/idol/*/general/outbound',
      EventsFunctions.voucherScan => 'ssco/idol/*/general/outbound',
      EventsFunctions.onScreenItem => 'ssco/idol/*/general/outbound',
      EventsFunctions.digitalProduct => 'ssco/idol/*/general/outbound',
      EventsFunctions.cancelPayment => 'ssco/idol/*/general/outbound',
      EventsFunctions.loyalty => 'ssco/idol/*/general/outbound',
      EventsFunctions.scoPing => 'ssco/idol/*/general/outbound',
      EventsFunctions.uiEventAssistant => 'ssco/idol/*/general/outbound',
      EventsFunctions.uiEventRegistration => 'ssco/idol/*/general/outbound',

      // Inbound topics: events consumed by this app from external systems
      EventsFunctions.ageInbound => 'ssco/idol/*/age/inbound',
      EventsFunctions.fraudAlert => 'ssco/idol/*/fraud/inbound',
      EventsFunctions.scoPong => 'ssco/idol/*/general/inbound',
    };
  }

  String topicWithClient(String clientId) => topic.replaceAll('*', clientId);
}

// Helper function to generate UUIDs
String _generateUuid() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = (timestamp * 1000) % 1000000;
  return '${timestamp.toString()}-${random.toString().padLeft(6, '0')}';
}

/// Simple MQTT Test Class for testing MQTT communication
class MqttTest {
  // MQTT Configuration

  
  //  static const String _brokerHost = 'dev-solace-node.walkout.eu';
  // static const int _brokerPort = 30285;


  static const String _brokerHost = '192.168.2.173';
  static const int _brokerPort = 1883;
  static const String _clientId = '500';
  static const String _username = 'admin';
  static const String _password = 'admin';
  
  // Topic patterns for dynamic generation
  static const String _publishPattern = 'ssco/idol/*/publish';
  static const String _subscribePattern = 'ssco/idol/*/subscribe';
  static const String _statusPattern = 'ssco/idol/*/status';
  static const String _fraudPattern = 'ssco/idol/*/fraud/inbound';
  static const String _agePattern = 'ssco/idol/*/age/inbound';
  static const String _generalPattern = 'ssco/idol/*/general/outbound';
  static const String _transactionPattern = 'ssco/idol/*/transaction';
  static const String _tsaStatePattern = 'ssco/idol/*/tsa/state';
  static const String _scanPattern = 'ssco/idol/*/scan';
  static const String _paymentPattern = 'ssco/idol/*/payment';
  static const String _alertPattern = 'ssco/idol/*/alert';
  
  // MQTT Client
  late MqttServerClient _client;
  bool _isConnected = false;
  List<String> _receivedMessages = [];
  List<Map<String, dynamic>> _rawMessages = []; // Store raw message data
  StreamController<String> _messageController = StreamController<String>.broadcast();
  
  // Getters
  bool get isConnected => _isConnected;
  List<String> get receivedMessages => List.unmodifiable(_receivedMessages);
  Stream<String> get messageStream => _messageController.stream;
  
  /// Generate topic with client ID and prefix
  String topicWithClientAndPrefix(String clientId, String topic) {
    // Use hardcoded prefix for testing
    const String prefix = 'ssco/idol/';
    final generic = topic; // e.g. ssco/idol/*/general/outbound

    // Extract suffix after the wildcard '*'
    final parts = generic.split('/');
    // Expected at least: ssco idol * segment ... -> parts[2] == '*'
    String suffix;
    if (parts.length >= 4) {
      final starIndex = parts.indexOf('*');
      if (starIndex != -1 && starIndex < parts.length - 1) {
        suffix = parts.sublist(starIndex + 1).join('/');
      } else {
        // No wildcard found, fallback to replacing any * directly
        return generic.replaceAll('*', clientId);
      }
    } else {
      // Not enough segments; fallback legacy replacement
      return generic.replaceAll('*', clientId);
    }

    // Final pattern: <prefix><clientId>/<suffix>
    return '$prefix$clientId/$suffix';
  }
  
  /// Get all available topics for this client
  List<String> getAllTopics() {
    return [
      topicWithClientAndPrefix(_clientId, _publishPattern),
      topicWithClientAndPrefix(_clientId, _subscribePattern),
      topicWithClientAndPrefix(_clientId, _statusPattern),
      topicWithClientAndPrefix(_clientId, _fraudPattern),
      topicWithClientAndPrefix(_clientId, _agePattern),
      topicWithClientAndPrefix(_clientId, _generalPattern),
      topicWithClientAndPrefix(_clientId, _transactionPattern),
      topicWithClientAndPrefix(_clientId, _tsaStatePattern),
      topicWithClientAndPrefix(_clientId, _scanPattern),
      topicWithClientAndPrefix(_clientId, _paymentPattern),
      topicWithClientAndPrefix(_clientId, _alertPattern),
    ];
  }
  
  /// Start continuous event monitoring
  Future<bool> startContinuousMonitoring() async {
    try {
      debugPrint('MQTT Test - Starting continuous event monitoring...');
      
      if (!_isConnected) {
        debugPrint('MQTT Test - Not connected, attempting to connect...');
        if (!await connect()) {
          debugPrint('MQTT Test - Failed to connect for monitoring');
          return false;
        }
      }
      
      // Ensure we're subscribed to all topics
      _subscribeToTopics();
      
      // Publish monitoring status
      await publishStatus('Continuous monitoring started');
      
      debugPrint('MQTT Test - Continuous monitoring active - listening for all events and alerts');
      return true;
    } catch (e) {
      debugPrint('MQTT Test - Error starting continuous monitoring: $e');
      return false;
    }
  }
  
  /// Get event statistics
  Map<String, int> getEventStatistics() {
    final stats = <String, int>{};
    
    for (final message in _receivedMessages) {
      if (message.contains('[SECURITY]')) {
        stats['SECURITY'] = (stats['SECURITY'] ?? 0) + 1;
      } else if (message.contains('[COMPLIANCE]')) {
        stats['COMPLIANCE'] = (stats['COMPLIANCE'] ?? 0) + 1;
      } else if (message.contains('[NOTIFICATION]')) {
        stats['NOTIFICATION'] = (stats['NOTIFICATION'] ?? 0) + 1;
      } else if (message.contains('[FINANCIAL]')) {
        stats['FINANCIAL'] = (stats['FINANCIAL'] ?? 0) + 1;
      } else if (message.contains('[OPERATION]')) {
        stats['OPERATION'] = (stats['OPERATION'] ?? 0) + 1;
      } else if (message.contains('[SYSTEM]')) {
        stats['SYSTEM'] = (stats['SYSTEM'] ?? 0) + 1;
      } else if (message.contains('[COMMUNICATION]')) {
        stats['COMMUNICATION'] = (stats['COMMUNICATION'] ?? 0) + 1;
      } else {
        stats['GENERAL'] = (stats['GENERAL'] ?? 0) + 1;
      }
    }
    
    return stats;
  }
  
  
  /// Initialize MQTT Client
  Future<bool> initialize() async {
    try {
      _client = MqttServerClient(_brokerHost, _clientId);
      _client.port = _brokerPort;
      _client.keepAlivePeriod = 20;
      _client.autoReconnect = false;
      _client.secure = true; // Match main controller - use SSL/TLS
      _client.logging(on: false); // Match main controller - disable logging initially

      // Set connection message - match main controller approach
      _client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(_clientId)
          .authenticateAs(_username, _password);
      
      // Set up callbacks like main controller
      _client.onConnected = _onConnected;
      _client.onDisconnected = _onDisconnected;
      
      return true;
    } catch (e) {
      debugPrint('MQTT Test - Initialization failed: $e');
      return false;
    }
  }
  
  /// Connect to MQTT Broker
  Future<bool> connect() async {
    try {
      if (_isConnected) {
        debugPrint('MQTT Test - Already connected');
        return true;
      }
      
      debugPrint('MQTT Test - Connecting to $_brokerHost:$_brokerPort');
      debugPrint('MQTT Test - Using SSL: ${_client.secure}');
      debugPrint('MQTT Test - Client ID: $_clientId');
      debugPrint('MQTT Test - Username: $_username');
      
      // Validate configuration before connecting
      if (!_validateConfiguration()) {
        debugPrint('MQTT Test - Configuration validation failed');
        return false;
      }
      
      // Enable logging for debugging
      _client.logging(on: true);
      
      await _client.connect(_username, _password);
      
      // Wait a moment for connection to establish
      await Future.delayed(Duration(milliseconds: 500));
      
      if (_client.connectionStatus?.state == MqttConnectionState.connected) {
        _isConnected = true;
        debugPrint('MQTT Test - Connected successfully');
        debugPrint('MQTT Test - Connection status: ${_client.connectionStatus?.state}');
        
        // Subscribe to topics
        _subscribeToTopics();
        
        // Publish connection status
        await publishStatus('Client connected');
        
        return true;
      } else {
        debugPrint('MQTT Test - Connection failed: ${_client.connectionStatus?.state}');
        debugPrint('MQTT Test - Connection status details: ${_client.connectionStatus}');
        return false;
      }
    } catch (e) {
      debugPrint('MQTT Test - Connection error: $e');
      debugPrint('MQTT Test - Error type: ${e.runtimeType}');
      if (e.toString().contains('SocketException')) {
        debugPrint('MQTT Test - Network error - check if broker is reachable');
      }
      return false;
    }
  }
  
  /// Disconnect from MQTT Broker
  Future<void> disconnect() async {
    try {
      if (_isConnected) {
        await publishStatus('Client disconnecting');
        _client.disconnect();
        _isConnected = false;
        debugPrint('MQTT Test - Disconnected');
      }
    } catch (e) {
      debugPrint('MQTT Test - Disconnect error: $e');
    }
  }
  
  /// Subscribe to topics - Enhanced for continuous event listening
  void _subscribeToTopics() {
    try {
      final topics = getAllTopics();
      
      // Subscribe to all available topics with persistent listening
      for (final topic in topics) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
        debugPrint('MQTT Test - Subscribed to: $topic');
      }
      
      // Subscribe to wildcard topics for broader event capture
      _subscribeToWildcardTopics();
      
      // Set up message listener for continuous monitoring
      _client.updates?.listen(_onMessageReceived);
      
      debugPrint('MQTT Test - Subscribed to ${topics.length} topics for continuous event monitoring');
    } catch (e) {
      debugPrint('MQTT Test - Subscription error: $e');
    }
  }
  
  /// Subscribe to wildcard topics for broader event capture
  void _subscribeToWildcardTopics() {
    try {
      // Subscribe to broader patterns to catch all events
      final wildcardTopics = [
        'ssco/idol/+/general/inbound',     // All inbound general events
        'ssco/idol/+/general/outbound',    // All outbound general events
        'ssco/idol/+/fraud/inbound',       // All fraud alerts
        'ssco/idol/+/fraud/outbound',      // All fraud feedback
        'ssco/idol/+/age/inbound',         // All age verification events
        'ssco/idol/+/alert/+',             // All alert types
        'ssco/idol/+/transaction/+',       // All transaction events
        'ssco/idol/+/scan/+',              // All scan events
        'ssco/idol/+/payment/+',           // All payment events
        'ssco/idol/+/status/+',            // All status updates
        'ssco/idol/+/tsa/state/+',          // All TSA state changes
      ];
      
      for (final topic in wildcardTopics) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
        debugPrint('MQTT Test - Subscribed to wildcard: $topic');
      }
      
      debugPrint('MQTT Test - Subscribed to ${wildcardTopics.length} wildcard topics');
    } catch (e) {
      debugPrint('MQTT Test - Wildcard subscription error: $e');
    }
  }
  
  /// Publish test message
  Future<bool> publishTestMessage(String message) async {
    final topic = topicWithClientAndPrefix(_clientId, _publishPattern);
    return await _publishMessage(topic, message);
  }
  
  /// Publish status message
  Future<bool> publishStatus(String status) async {
    final statusData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'status': status,
      'connected': _isConnected,
    };
    final topic = topicWithClientAndPrefix(_clientId, _statusPattern);
    return await _publishMessage(topic, jsonEncode(statusData));
  }
  
  /// Publish transaction data
  Future<bool> publishTransaction() async {
    final transactionData = {
      'timestamp': DateTime.now().toIso8601String(),
      'transaction_id': 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      'type': 'sale',
      'amount': 25.50,
      'currency': 'AED',
      'items': [
        {'name': 'Coffee', 'price': 12.00, 'quantity': 1},
        {'name': 'Sandwich', 'price': 13.50, 'quantity': 1},
      ],
      'payment_method': 'card',
      'status': 'completed',
    };
    
    final topic = topicWithClientAndPrefix(_clientId, _transactionPattern);
    return await _publishMessage(topic, jsonEncode(transactionData));
  }
  
  /// Publish TSA state change
  Future<bool> publishTsaState(String state, String substate) async {
    final stateData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'state': state,
      'substate': substate,
      'screen_type': 'sco_common',
      'description': 'TSA State Change',
    };
    
    final topic = topicWithClientAndPrefix(_clientId, _tsaStatePattern);
    return await _publishMessage(topic, jsonEncode(stateData));
  }
  
  /// Generic publish method
  Future<bool> _publishMessage(String topic, String message) async {
    try {
      if (!_isConnected) {
        debugPrint('MQTT Test - Not connected, cannot publish');
        return false;
      }
      
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      
      _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('MQTT Test - Published to $topic: $message');
      return true;
    } catch (e) {
      debugPrint('MQTT Test - Publish error: $e');
      return false;
    }
  }
  
  /// Send test command
  Future<bool> sendTestCommand() async {
    final commandData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'command': 'test',
      'data': {
        'message': 'Hello from MQTT Test Client',
        'test_id': DateTime.now().millisecondsSinceEpoch,
      },
    };
    final topic = topicWithClientAndPrefix(_clientId, _generalPattern);
    return await _publishMessage(topic, jsonEncode(commandData));
  }
  
  /// Send scan command
  Future<bool> sendScanCommand(String barcode) async {
    final scanData = {
      'timestamp': DateTime.now().toIso8601String(),
      'barcode': barcode,
      'scanner_id': 'scanner_001',
      'location': 'checkout_1',
    };
    final topic = topicWithClientAndPrefix(_clientId, _scanPattern);
    return await _publishMessage(topic, jsonEncode(scanData));
  }
  
  /// Send payment command
  Future<bool> sendPaymentCommand(double amount, String method) async {
    final paymentData = {
      'timestamp': DateTime.now().toIso8601String(),
      'amount': amount,
      'method': method,
      'transaction_id': 'PAY_${DateTime.now().millisecondsSinceEpoch}',
    };
    final topic = topicWithClientAndPrefix(_clientId, _paymentPattern);
    return await _publishMessage(topic, jsonEncode(paymentData));
  }
  
  /// Send alert command
  Future<bool> sendAlertCommand(String alertType, String message) async {
    final alertData = {
      'timestamp': DateTime.now().toIso8601String(),
      'type': alertType,
      'message': message,
      'severity': 'high',
      'requires_action': true,
    };
    final topic = topicWithClientAndPrefix(_clientId, _alertPattern);
    return await _publishMessage(topic, jsonEncode(alertData));
  }
  
  // ===== NEW COMPREHENSIVE EVENT TEST METHODS =====
  
  /// Send checkout start event
  Future<bool> sendCheckoutStart() async {
    final payload = EventsFunctions.checkoutStart.defaultPayload;
    final topic = EventsFunctions.checkoutStart.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send checkout end event
  Future<bool> sendCheckoutEnd() async {
    final payload = EventsFunctions.checkoutEnd.defaultPayload;
    final topic = EventsFunctions.checkoutEnd.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send checkout void event
  Future<bool> sendCheckoutVoid() async {
    final payload = EventsFunctions.checkoutVoid.defaultPayload;
    final topic = EventsFunctions.checkoutVoid.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send checkout suspend event
  Future<bool> sendCheckoutSuspend() async {
    final payload = EventsFunctions.checkoutSuspend.defaultPayload;
    final topic = EventsFunctions.checkoutSuspend.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send fraud alert event
  Future<bool> sendFraudAlert() async {
    final payload = EventsFunctions.fraudAlert.defaultPayload;
    final topic = EventsFunctions.fraudAlert.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send fraud alert feedback event
  Future<bool> sendFraudAlertFeedback({String? alertId, MqttFeedbackType? feedbackType}) async {
    final payload = EventsFunctions.fraudAlertFeedback.defaultPayload;
    if (alertId != null) payload['alert_id'] = alertId;
    if (feedbackType != null) payload['feedback_type'] = feedbackType.jsonValue;
    final topic = EventsFunctions.fraudAlertFeedback.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send item scan event
  Future<bool> sendItemScan({MqttScanType? scanType, String? barcode}) async {
    final payload = EventsFunctions.itemScan.defaultPayload;
    if (scanType != null) payload['scan_type'] = scanType.jsonValue;
    if (barcode != null) payload['barcode'] = barcode;
    final topic = EventsFunctions.itemScan.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send item info event
  Future<bool> sendItemInfo({MqttScanType? scanType, Map<String, dynamic>? itemData}) async {
    final payload = EventsFunctions.itemInfo.defaultPayload;
    if (scanType != null) payload['scan_type'] = scanType.jsonValue;
    if (itemData != null) payload.addAll(itemData);
    final topic = EventsFunctions.itemInfo.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send item return event
  Future<bool> sendItemReturn() async {
    final payload = EventsFunctions.itemReturn.defaultPayload;
    final topic = EventsFunctions.itemReturn.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send item void event
  Future<bool> sendItemVoid() async {
    final payload = EventsFunctions.itemVoid.defaultPayload;
    final topic = EventsFunctions.itemVoid.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send assistance event
  Future<bool> sendAssistance({MqttUIStatus? uiStatus}) async {
    final payload = EventsFunctions.assistance.defaultPayload;
    if (uiStatus != null) payload['ui_status'] = uiStatus.jsonValue;
    final topic = EventsFunctions.assistance.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send assistance out event
  Future<bool> sendAssistanceOut() async {
    final payload = EventsFunctions.assistanceOut.defaultPayload;
    final topic = EventsFunctions.assistanceOut.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send payment event
  Future<bool> sendPayment({MqttUIStatus? uiStatus, double? amount, String? method}) async {
    final payload = EventsFunctions.payment.defaultPayload;
    if (uiStatus != null) payload['ui_status'] = uiStatus.jsonValue;
    if (amount != null) payload['amount'] = amount;
    if (method != null) payload['payment_method'] = method;
    final topic = EventsFunctions.payment.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send price check event
  Future<bool> sendPriceCheck() async {
    final payload = EventsFunctions.priceCheck.defaultPayload;
    final topic = EventsFunctions.priceCheck.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send voucher scan event
  Future<bool> sendVoucherScan() async {
    final payload = EventsFunctions.voucherScan.defaultPayload;
    final topic = EventsFunctions.voucherScan.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send on screen item event
  Future<bool> sendOnScreenItem() async {
    final payload = EventsFunctions.onScreenItem.defaultPayload;
    final topic = EventsFunctions.onScreenItem.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send digital product event
  Future<bool> sendDigitalProduct() async {
    final payload = EventsFunctions.digitalProduct.defaultPayload;
    final topic = EventsFunctions.digitalProduct.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send cancel payment event
  Future<bool> sendCancelPayment({MqttUIStatus? uiStatus}) async {
    final payload = EventsFunctions.cancelPayment.defaultPayload;
    if (uiStatus != null) payload['ui_status'] = uiStatus.jsonValue;
    final topic = EventsFunctions.cancelPayment.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send loyalty event
  Future<bool> sendLoyalty() async {
    final payload = EventsFunctions.loyalty.defaultPayload;
    final topic = EventsFunctions.loyalty.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send SCO ping event
  Future<bool> sendScoPing() async {
    final payload = EventsFunctions.scoPing.defaultPayload;
    final topic = EventsFunctions.scoPing.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send SCO pong event
  Future<bool> sendScoPong() async {
    final payload = EventsFunctions.scoPong.defaultPayload;
    final topic = EventsFunctions.scoPong.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send age inbound event
  Future<bool> sendAgeInbound({bool? ageVerified}) async {
    final payload = EventsFunctions.ageInbound.defaultPayload;
    if (ageVerified != null) payload['age_verified'] = ageVerified;
    final topic = EventsFunctions.ageInbound.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send UI event assistant
  Future<bool> sendUIEventAssistant({MqttUIStatus? uiStatus}) async {
    final payload = EventsFunctions.uiEventAssistant.defaultPayload;
    if (uiStatus != null) payload['ui_status'] = uiStatus.jsonValue;
    final topic = EventsFunctions.uiEventAssistant.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send UI event registration
  Future<bool> sendUIEventRegistration({MqttUIStatus? uiStatus}) async {
    final payload = EventsFunctions.uiEventRegistration.defaultPayload;
    if (uiStatus != null) payload['ui_status'] = uiStatus.jsonValue;
    final topic = EventsFunctions.uiEventRegistration.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Send any event by type
  Future<bool> sendEvent(EventsFunctions eventType, {Map<String, dynamic>? customPayload}) async {
    final payload = eventType.defaultPayload;
    if (customPayload != null) payload.addAll(customPayload);
    final topic = eventType.topicWithClient(_clientId);
    return await _publishMessage(topic, jsonEncode(payload));
  }
  
  /// Display all available topics
  void displayAllTopics() {
    final topics = getAllTopics();
    debugPrint('MQTT Test - Available Topics for Client $_clientId:');
    for (int i = 0; i < topics.length; i++) {
      debugPrint('  ${i + 1}. ${topics[i]}');
    }
  }
  
  /// Test connection with different SSL configurations
  Future<bool> testConnectionWithSSL(bool useSSL) async {
    debugPrint('MQTT Test - Testing connection with SSL: $useSSL');
    
    try {
      // Create a new client for this test
      final testClient = MqttServerClient(_brokerHost, '${_clientId}_test');
      testClient.port = _brokerPort;
      testClient.keepAlivePeriod = 20;
      testClient.autoReconnect = false;
      testClient.secure = useSSL;
      testClient.logging(on: true);
      
      testClient.connectionMessage = MqttConnectMessage()
          .withClientIdentifier('${_clientId}_test')
          .authenticateAs(_username, _password);
      
      await testClient.connect(_username, _password);
      await Future.delayed(Duration(milliseconds: 1000));
      
      final connected = testClient.connectionStatus?.state == MqttConnectionState.connected;
      debugPrint('MQTT Test - SSL $useSSL connection result: $connected');
      
      if (connected) {
        testClient.disconnect();
      }
      
      return connected;
    } catch (e) {
      debugPrint('MQTT Test - SSL $useSSL test error: $e');
      return false;
    }
  }
  
  /// Run complete test sequence with all event types
  Future<void> runTestSequence() async {
    debugPrint('MQTT Test - Starting comprehensive test sequence...');
    
    // Display all topics
    displayAllTopics();
    
    // Test both SSL and non-SSL connections
    debugPrint('MQTT Test - Testing SSL connection...');
    final sslResult = await testConnectionWithSSL(true);
    debugPrint('MQTT Test - SSL connection result: $sslResult');
    
    debugPrint('MQTT Test - Testing non-SSL connection...');
    final nonSslResult = await testConnectionWithSSL(false);
    debugPrint('MQTT Test - Non-SSL connection result: $nonSslResult');
    
    // Initialize and connect with the working configuration
    if (await initialize()) {
      // Try connecting with SSL first, then without if that fails
      bool connected = await connect();
      
      if (!connected && _client.secure) {
        debugPrint('MQTT Test - SSL connection failed, trying without SSL...');
        _client.secure = false;
        connected = await connect();
      }
      
      if (connected) {
        // Wait a moment for connection to stabilize
        await Future.delayed(Duration(seconds: 2));
        
        debugPrint('MQTT Test - Starting comprehensive event testing...');
        
        // ===== CHECKOUT EVENTS =====
        debugPrint('MQTT Test - Testing checkout events...');
        await sendCheckoutStart();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== ITEM EVENTS =====
        debugPrint('MQTT Test - Testing item events...');
        await sendItemScan(scanType: MqttScanType.product, barcode: '1234567890123');
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendItemInfo(
          scanType: MqttScanType.product,
          itemData: {
            'name': 'Test Product',
            'price': 12.99,
            'category': 'groceries',
          },
        );
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendItemReturn();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendItemVoid();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== PAYMENT EVENTS =====
        debugPrint('MQTT Test - Testing payment events...');
        await sendPayment(uiStatus: MqttUIStatus.payment, amount: 25.50, method: 'card');
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendCancelPayment(uiStatus: MqttUIStatus.registration);
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== ASSISTANCE EVENTS =====
        debugPrint('MQTT Test - Testing assistance events...');
        await sendAssistance(uiStatus: MqttUIStatus.assistant);
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendAssistanceOut();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== FRAUD EVENTS =====
        debugPrint('MQTT Test - Testing fraud events...');
        await sendFraudAlert();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendFraudAlertFeedback(
          alertId: _generateUuid(),
          feedbackType: MqttFeedbackType.willRescan,
        );
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== UI EVENTS =====
        debugPrint('MQTT Test - Testing UI events...');
        await sendUIEventAssistant(uiStatus: MqttUIStatus.assistant);
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendUIEventRegistration(uiStatus: MqttUIStatus.registration);
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== ADDITIONAL EVENTS =====
        debugPrint('MQTT Test - Testing additional events...');
        await sendPriceCheck();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendVoucherScan();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendOnScreenItem();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendDigitalProduct();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendLoyalty();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== COMMUNICATION EVENTS =====
        debugPrint('MQTT Test - Testing communication events...');
        await sendScoPing();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendScoPong();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== AGE VERIFICATION =====
        debugPrint('MQTT Test - Testing age verification...');
        await sendAgeInbound(ageVerified: true);
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== CHECKOUT COMPLETION =====
        debugPrint('MQTT Test - Testing checkout completion...');
        await sendCheckoutEnd();
        await Future.delayed(Duration(milliseconds: 500));
        
        // ===== LEGACY TEST METHODS (for backward compatibility) =====
        debugPrint('MQTT Test - Testing legacy methods...');
        await sendTestCommand();
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendScanCommand('1234567890123');
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendPaymentCommand(25.50, 'card');
        await Future.delayed(Duration(milliseconds: 500));
        
        await sendAlertCommand('error', 'Test error message');
        await Future.delayed(Duration(milliseconds: 500));
        
        // Send transaction data
        await publishTransaction();
        await Future.delayed(Duration(milliseconds: 500));
        
        // Send TSA state
        await publishTsaState('1008', 'goHomeScreen');
        await Future.delayed(Duration(milliseconds: 500));
        
        await publishTsaState('1002', 'goPaymentScreen');
        await Future.delayed(Duration(milliseconds: 500));
        
        // Send final status
        await publishStatus('Comprehensive test sequence completed');
        
        debugPrint('MQTT Test - Comprehensive test sequence completed successfully!');
        debugPrint('MQTT Test - Total events sent: ${EventsFunctions.values.length + 7}'); // +7 for legacy methods
      } else {
        debugPrint('MQTT Test - Failed to connect with both SSL and non-SSL, test sequence aborted');
      }
    } else {
      debugPrint('MQTT Test - Failed to initialize, test sequence aborted');
    }
  }
  
  /// Run quick test sequence (subset of events)
  Future<void> runQuickTestSequence() async {
    debugPrint('MQTT Test - Starting quick test sequence...');
    
    if (await initialize() && await connect()) {
      await Future.delayed(Duration(seconds: 1));
      
      // Send essential events only
      await sendCheckoutStart();
      await Future.delayed(Duration(milliseconds: 300));
      
      await sendItemScan(scanType: MqttScanType.product, barcode: '1234567890123');
      await Future.delayed(Duration(milliseconds: 300));
      
      await sendPayment(amount: 25.50, method: 'card');
      await Future.delayed(Duration(milliseconds: 300));
      
      await sendCheckoutEnd();
      await Future.delayed(Duration(milliseconds: 300));
      
      debugPrint('MQTT Test - Quick test sequence completed');
    } else {
      debugPrint('MQTT Test - Quick test sequence failed - could not connect');
    }
  }
  
  /// Get connection status as string
  String getConnectionStatus() {
    if (_isConnected) {
      return 'Connected to $_brokerHost:$_brokerPort';
    } else {
      return 'Disconnected';
    }
  }
  
  /// Get received messages count
  int getReceivedMessagesCount() {
    return _receivedMessages.length;
  }
  
  /// Clear received messages
  void clearReceivedMessages() {
    _receivedMessages.clear();
    _rawMessages.clear();
  }
  
  /// Callback: Message received - Enhanced for continuous event monitoring
  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null) return;
    
    for (final message in messages) {
      try {
        final topic = message.topic;
        final payload = message.payload;
        
        String rawPayload = '';
        if (payload is MqttPublishMessage) {
          rawPayload = MqttPublishPayload.bytesToStringAsString(payload.payload.message);
        } else {
          rawPayload = payload.toString();
        }
        
        // Parse and categorize the message
        final categorizedMessage = _categorizeMessage(topic, rawPayload);
        
        // Store raw message data for image extraction
        _rawMessages.add({
          'topic': topic,
          'payload': rawPayload,
          'categorized': categorizedMessage,
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        _receivedMessages.add(categorizedMessage);
        _messageController.add(categorizedMessage);
        
        debugPrint('MQTT Test - Received Event: $categorizedMessage');
      } catch (e) {
        debugPrint('MQTT Test - Error processing message: $e');
      }
    }
  }
  
  /// Categorize and format incoming messages for better event monitoring
  String _categorizeMessage(String topic, String payload) {
    final timestamp = DateTime.now().toIso8601String();
    
    // Determine event type based on topic
    String eventType = 'UNKNOWN';
    String eventCategory = 'GENERAL';
    String icon = '📨';
    
    if (topic.contains('/fraud/inbound')) {
      eventType = 'FRAUD_ALERT';
      eventCategory = 'SECURITY';
      icon = '🚨';
    } else if (topic.contains('/fraud/outbound')) {
      eventType = 'FRAUD_FEEDBACK';
      eventCategory = 'SECURITY';
      icon = '🛡️';
    } else if (topic.contains('/age/inbound')) {
      eventType = 'AGE_VERIFICATION';
      eventCategory = 'COMPLIANCE';
      icon = '🔞';
    } else if (topic.contains('/alert/')) {
      eventType = 'ALERT';
      eventCategory = 'NOTIFICATION';
      icon = '⚠️';
    } else if (topic.contains('/transaction/')) {
      eventType = 'TRANSACTION';
      eventCategory = 'FINANCIAL';
      icon = '💳';
    } else if (topic.contains('/scan/')) {
      eventType = 'SCAN_EVENT';
      eventCategory = 'OPERATION';
      icon = '📱';
    } else if (topic.contains('/payment/')) {
      eventType = 'PAYMENT';
      eventCategory = 'FINANCIAL';
      icon = '💰';
    } else if (topic.contains('/status/')) {
      eventType = 'STATUS_UPDATE';
      eventCategory = 'SYSTEM';
      icon = '📊';
    } else if (topic.contains('/tsa/state/')) {
      eventType = 'TSA_STATE';
      eventCategory = 'SYSTEM';
      icon = '🔄';
    } else if (topic.contains('/general/inbound')) {
      eventType = 'INBOUND_EVENT';
      eventCategory = 'COMMUNICATION';
      icon = '📥';
    } else if (topic.contains('/general/outbound')) {
      eventType = 'OUTBOUND_EVENT';
      eventCategory = 'COMMUNICATION';
      icon = '📤';
    }
    
    // Try to parse JSON payload for better formatting
    try {
      final jsonData = jsonDecode(payload);
      final eventData = jsonData['event_type'] ?? 'unknown_event';
      final clientId = jsonData['client_id'] ?? 'unknown_client';
      
      // Check for image data in fraud alerts
      String imageInfo = '';
      if (jsonData['image'] != null) {
        final imageData = jsonData['image'];
        final mimeType = imageData['mime'] ?? 'unknown';
        final dataLength = imageData['data']?.toString().length ?? 0;
        imageInfo = '\n   🖼️ Image: $mimeType (${dataLength} chars)';
      }
      
      return '$icon [$eventCategory] $eventType from $clientId: $eventData\n'
             '   Topic: $topic\n'
             '   Time: $timestamp$imageInfo\n'
             '   Data: ${jsonEncode(jsonData)}';
    } catch (e) {
      // If not JSON, return raw message with categorization
      return '$icon [$eventCategory] $eventType\n'
             '   Topic: $topic\n'
             '   Time: $timestamp\n'
             '   Raw: $payload';
    }
  }
  
  /// Extract image data from raw messages
  List<Map<String, dynamic>> getAllImageData() {
    final imageData = <Map<String, dynamic>>[];
    
    for (final rawMessage in _rawMessages) {
      try {
        final payload = rawMessage['payload'] as String;
        final topic = rawMessage['topic'] as String;
        
        // Only check fraud inbound topics for images
        if (topic.contains('/fraud/inbound')) {
          debugPrint('MQTT Test - Checking fraud topic for image: $topic');
          debugPrint('MQTT Test - Payload: $payload');
          
          final jsonData = jsonDecode(payload);
          if (jsonData['image'] != null) {
            debugPrint('MQTT Test - Found image data: ${jsonData['image']['mime']}');
            imageData.add({
              'mime': jsonData['image']['mime'],
              'data': jsonData['image']['data'],
              'topic': topic,
              'timestamp': rawMessage['timestamp'],
            });
          }
        }
      } catch (e) {
        debugPrint('MQTT Test - Error extracting image data: $e');
        debugPrint('MQTT Test - Raw message: ${rawMessage['payload']}');
      }
    }
    
    return imageData;
  }
  
  /// Clear raw messages
  void clearRawMessages() {
    _rawMessages.clear();
  }
  
  /// Dispose resources
  void dispose() {
    _messageController.close();
    if (_isConnected) {
      disconnect();
    }
  }
  
  /// Validate MQTT configuration
  bool _validateConfiguration() {
    if (_brokerHost.isEmpty) {
      debugPrint('MQTT Test - Broker host is required');
      return false;
    }
    
    if (_brokerPort <= 0 || _brokerPort > 65535) {
      debugPrint('MQTT Test - Invalid port number: $_brokerPort');
      return false;
    }
    
    if (_clientId.isEmpty) {
      debugPrint('MQTT Test - Client ID is required');
      return false;
    }
    
    if (_username.isEmpty) {
      debugPrint('MQTT Test - Username is required');
      return false;
    }
    
    return true;
  }
  
  /// Connection callback - called when connected
  void _onConnected() {
    debugPrint('MQTT Test - Connected callback received');
    _isConnected = true;
  }
  
  /// Disconnection callback - called when disconnected
  void _onDisconnected() {
    debugPrint('MQTT Test - Disconnected callback received');
    _isConnected = false;
  }
  
  /// Quick connection test - simple method to test MQTT connection
  static Future<void> quickTest() async {
    final test = MqttTest();
    debugPrint('=== MQTT Quick Test Starting ===');
    
    try {
      if (await test.initialize()) {
        debugPrint('✓ MQTT Test initialized successfully');
        
        if (await test.connect()) {
          debugPrint('✓ MQTT Test connected successfully');
          debugPrint('✓ Connection status: ${test.getConnectionStatus()}');
          
          // Send a simple test message
          await test.publishTestMessage('Quick test message');
          debugPrint('✓ Test message sent');
          
          // Wait a moment and disconnect
          await Future.delayed(Duration(seconds: 2));
          await test.disconnect();
          debugPrint('✓ MQTT Test disconnected');
        } else {
          debugPrint('✗ MQTT Test connection failed');
        }
      } else {
        debugPrint('✗ MQTT Test initialization failed');
      }
    } catch (e) {
      debugPrint('✗ MQTT Test error: $e');
    } finally {
      test.dispose();
      debugPrint('=== MQTT Quick Test Completed ===');
    }
  }
}