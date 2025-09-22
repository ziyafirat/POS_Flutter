import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:logger/logger.dart';
import '../models/alert_message.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  final Logger _logger = Logger();
  MqttServerClient? _client;
  bool _isConnected = false;
  final StreamController<AlertMessage> _alertController =
      StreamController<AlertMessage>.broadcast();

  // Auto-reconnection properties
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // MQTT Configuration - Topic Prefix
  static const String _topicPrefix = 'ssco/idol/';
  static const String _defaultTerminalId = '500'; // Default Terminal ID
  static const String _alertsTopic = '${_topicPrefix}alerts';

  // Dynamic terminal ID - will be updated from app controller
  String _terminalId = _defaultTerminalId;

  // Dynamic fraud inbound topic based on current terminal ID
  String get _fraudInboundTopic => '${_topicPrefix}$_terminalId/fraud/inbound';

  // Transaction tracking for checkout events
  String? _currentTransactionId;
  String? _currentDocumentId;

  /// Generate a UUID v4 string
  String _generateUuid() {
    final random = Random();
    final List<int> bytes = List<int>.generate(16, (i) => random.nextInt(256));

    // Set version (4) and variant bits
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant 10

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  /// Verify base64 data integrity
  String _verifyBase64Integrity(String base64Data) {
    try {
      // Check if length is multiple of 4 (base64 requirement)
      final lengthCheck = base64Data.length % 4 == 0;

      // Check if contains only valid base64 characters
      final validCharsRegex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      final validChars = validCharsRegex.hasMatch(base64Data);

      // Try to decode a small portion to verify it's valid base64
      final canDecode = base64Data.length >= 4;
      bool decodeTest = false;
      if (canDecode) {
        try {
          // Test decode first 100 chars or full string if shorter
          final testLength = base64Data.length > 100 ? 100 : base64Data.length;
          final testPortion = base64Data.substring(0, testLength);
          // Ensure test portion has valid padding
          final paddedTest =
              testPortion + '=' * ((4 - testPortion.length % 4) % 4);
          base64.decode(paddedTest);
          decodeTest = true;
        } catch (e) {
          decodeTest = false;
        }
      }

      return 'Length OK: $lengthCheck, Valid chars: $validChars, Decode test: $decodeTest';
    } catch (e) {
      return 'Integrity check failed: $e';
    }
  }

  // Configuration properties
  String brokerHost = '192.168.2.173';
  int brokerPort = 1883;
  String username = 'admin';
  String password = 'admin';
  String topic = _alertsTopic;

  Stream<AlertMessage> get alertStream => _alertController.stream;

  Future<bool> connect() async {
    try {
      // MQTT Configuration
      final String brokerAddress = brokerHost;
      final int port = brokerPort;
      const String clientIdentifier = '500';
      final String mqttUsername = username;
      final String mqttPassword = password;
      const bool mqttSecure = false;

      _logger.i('🔌 [MQTT] Starting connection to broker...');
      _logger.i('🔌 [MQTT] Broker: $brokerAddress:$port');
      _logger.i('🔌 [MQTT] Client ID: $clientIdentifier');
      _logger.i('🔌 [MQTT] Username: $mqttUsername');
      _logger.i('🔌 [MQTT] Secure: $mqttSecure');

      // Skip MQTT connection on web platform due to SecurityContext limitations
      if (kIsWeb) {
        _logger.w(
          '⚠️ [MQTT] Connection skipped on web platform (SecurityContext limitations)',
        );
        _isConnected = false;
        return false;
      }

      // Create a fresh client instance (like the working testConnectionWithSSL method)
      _logger.i('🔌 [MQTT] Creating new MQTT client instance...');
      _client = MqttServerClient(brokerAddress, clientIdentifier);
      _client!.port = port;
      _client!.secure = mqttSecure;
      _client!.logging(on: false); // Match working method - disable logging
      _client!.autoReconnect = false;
      _client!.keepAlivePeriod = 20;
      _client!.connectTimeoutPeriod = 10000;

      // Set connection message (like the working method)
      _client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientIdentifier)
          .authenticateAs(mqttUsername, mqttPassword);

      // Set up callbacks
      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;

      _logger.i('🔌 [MQTT] Attempting to connect...');

      // Connect (like the working method)
      await _client!.connect(mqttUsername, mqttPassword);

      // Wait for connection to establish (like the working method)
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check connection status (like the working method)
      final connected =
          _client!.connectionStatus?.state == MqttConnectionState.connected;

      if (connected) {
        _isConnected = true;
        _logger.i('✅ [MQTT] Connection established successfully!');
        _logger.i('✅ [MQTT] Client state: ${_client!.connectionStatus}');
        _logger.i('✅ [MQTT] Client ID: ${_client!.clientIdentifier}');
        _logger.i('✅ [MQTT] Broker: ${_client!.server}:${_client!.port}');
        _subscribeToTopics();
        return true;
      } else {
        _logger.e(
          '❌ [MQTT] Connection failed. Status: ${_client!.connectionStatus}',
        );
        _isConnected = false;
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Failed to connect to MQTT broker: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
      _isConnected = false;
      return false;
    }
  }

  void _onConnected() {
    _logger.i('✅ [MQTT] Client connected callback triggered');
    _logger.i('✅ [MQTT] Connection state: ${_client?.connectionStatus}');
    _logger.i('✅ [MQTT] Client identifier: ${_client?.clientIdentifier}');
    _isConnected = true;
    _reconnectAttempts = 0; // Reset reconnect attempts on successful connection
  }

  void _onDisconnected() {
    _logger.w('⚠️ [MQTT] Client disconnected callback triggered');
    _logger.w('⚠️ [MQTT] Connection state: ${_client?.connectionStatus}');
    _isConnected = false;

    // Trigger auto-reconnection
    _scheduleReconnection();
  }

  void _subscribeToTopics() {
    if (_client != null && _isConnected) {
      _logger.i('📡 [MQTT] Subscribing to topics...');
      _logger.i('📡 [MQTT] Topic Prefix: $_topicPrefix');
      _logger.i('📡 [MQTT] Topic: $_alertsTopic');
      _logger.i('📡 [MQTT] Fraud Topic: $_fraudInboundTopic');
      _logger.i('📡 [MQTT] QoS: ${MqttQos.atLeastOnce}');

      // Subscribe to both general alerts and fraud inbound topics
      _client!.subscribe(_alertsTopic, MqttQos.atLeastOnce);
      _client!.subscribe(_fraudInboundTopic, MqttQos.atLeastOnce);
      _logger.i('📡 [MQTT] Subscription requests sent');

      _client!.updates!.listen(_onMessage);
      _logger.i('📡 [MQTT] Message listener attached');
      _logger.i(
        '📡 [MQTT] Ready to receive messages on topics: $_alertsTopic and $_fraudInboundTopic',
      );
    } else {
      _logger.e('❌ [MQTT] Cannot subscribe - client is null or not connected');
      _logger.e('❌ [MQTT] Client null: ${_client == null}');
      _logger.e('❌ [MQTT] Is connected: $_isConnected');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? c) {
    try {
      _logger.i('📨 [MQTT] INBOUND: Message received!');
      print('📨 [MQTT] INBOUND: Message received!');
      _logger.i('📨 [MQTT] INBOUND: Message count: ${c?.length ?? 0}');
      print('📨 [MQTT] INBOUND: Message count: ${c?.length ?? 0}');

      if (c == null || c.isEmpty) {
        _logger.w('⚠️ [MQTT] Empty message list received');
        return;
      }

      final recMess = c[0];
      _logger.i('📨 [MQTT] INBOUND: Message details:');
      print('📨 [MQTT] INBOUND: Message details:');
      _logger.i('📨 [MQTT] INBOUND: - Topic: ${recMess.topic}');
      print('📨 [MQTT] INBOUND: - Topic: ${recMess.topic}');

      // Check if this is an expected topic (alerts or fraud inbound)
      if (recMess.topic != _alertsTopic &&
          recMess.topic != _fraudInboundTopic) {
        _logger.w(
          '⚠️ [MQTT] INBOUND: UNEXPECTED TOPIC - We subscribe to: $_alertsTopic and $_fraudInboundTopic',
        );
        _logger.w('⚠️ [MQTT] INBOUND: But received from: ${recMess.topic}');
        _logger.w(
          '⚠️ [MQTT] INBOUND: This suggests broker misconfiguration or message republishing',
        );
        print(
          '⚠️ [MQTT] INBOUND: UNEXPECTED TOPIC - We subscribe to: $_alertsTopic and $_fraudInboundTopic',
        );
        print('⚠️ [MQTT] INBOUND: But received from: ${recMess.topic}');
        print(
          '⚠️ [MQTT] INBOUND: This suggests broker misconfiguration or message republishing',
        );
      }

      final payload = recMess.payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(
        payload.payload.message,
      );

      _logger.i('📨 [MQTT] INBOUND: Raw message payload: $message');
      print('📨 [MQTT] INBOUND: Raw message payload: $message');
      _logger.i(
        '📨 [MQTT] INBOUND: Message length: ${message.length} characters',
      );
      print('📨 [MQTT] INBOUND: Message length: ${message.length} characters');

      // Parse alert message as JSON and check event_type
      _logger.i('🚨 [MQTT] INBOUND: Processing alert message...');
      print('🚨 [MQTT] INBOUND: Processing alert message...');

      try {
        // Try to parse message as JSON
        final jsonData = jsonDecode(message);
        _logger.i('🚨 [MQTT] INBOUND: Successfully parsed JSON message');
        print('🚨 [MQTT] INBOUND: Successfully parsed JSON message');
        _logger.i('🚨 [MQTT] INBOUND: JSON data: $jsonData');
        print('🚨 [MQTT] INBOUND: JSON data: $jsonData');

        // Check if this is a fraud alert (either by event_type or by topic)
        final eventType = jsonData['event_type']?.toString();
        final isFraudTopic = recMess.topic.contains('/fraud/inbound');
        final isFraudAlert = eventType == 'fraud_alert' || isFraudTopic;

        _logger.i('🚨 [MQTT] INBOUND: Event type: $eventType');
        _logger.i('🚨 [MQTT] INBOUND: Is fraud topic: $isFraudTopic');
        _logger.i('🚨 [MQTT] INBOUND: Is fraud alert: $isFraudAlert');
        print('🚨 [MQTT] INBOUND: Event type: $eventType');
        print('🚨 [MQTT] INBOUND: Is fraud topic: $isFraudTopic');
        print('🚨 [MQTT] INBOUND: Is fraud alert: $isFraudAlert');

        if (!isFraudAlert) {
          _logger.i(
            '🚫 [MQTT] Ignoring alert - not a fraud alert (event_type: $eventType, topic: ${recMess.topic})',
          );
          return; // Exit early - don't show this alert
        }

        _logger.i('✅ [MQTT] Processing fraud alert...');

        // Extract alert details from JSON
        final alertTitle = jsonData['title']?.toString() ?? 'Fraud Alert';
        final alertMessage = jsonData['message']?.toString() ?? message;
        final videoUrl = jsonData['video_url']?.toString();

        // Extract image data if present
        String? imageData;
        String? imageMimeType;
        if (jsonData['image'] != null) {
          final imageInfo = jsonData['image'];
          imageData = imageInfo['data']?.toString();
          imageMimeType = imageInfo['mime']?.toString();
          _logger.i(
            '🖼️ [MQTT] Image data found: $imageMimeType (${imageData?.length ?? 0} chars)',
          );
          print(
            '🖼️ [MQTT] Image data found: $imageMimeType (${imageData?.length ?? 0} chars)',
          );

          // Verify image data integrity without logging full data (to avoid truncation)
          if (imageData != null) {
            final firstChars = imageData.substring(
              0,
              imageData.length > 50 ? 50 : imageData.length,
            );
            final lastChars = imageData.length > 50
                ? imageData.substring(imageData.length - 50)
                : '';

            _logger.i('🖼️ [MQTT] Image data verification:');
            _logger.i('🖼️ [MQTT] - Length: ${imageData.length} chars');
            _logger.i('🖼️ [MQTT] - First 50: "$firstChars"');
            if (lastChars.isNotEmpty) {
              _logger.i('🖼️ [MQTT] - Last 50: "$lastChars"');
            }
            _logger.i(
              '🖼️ [MQTT] - Integrity: ${_verifyBase64Integrity(imageData)}',
            );

            print('🖼️ [MQTT] Image data verification:');
            print('🖼️ [MQTT] - Length: ${imageData.length} chars');
            print('🖼️ [MQTT] - First 50: "$firstChars"');
            if (lastChars.isNotEmpty) {
              print('🖼️ [MQTT] - Last 50: "$lastChars"');
            }
            print(
              '🖼️ [MQTT] - Integrity: ${_verifyBase64Integrity(imageData)}',
            );
          }
        }

        final alert = AlertMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: alertTitle,
          message: alertMessage,
          type: AlertType.fraud,
          videoUrl: videoUrl,
          imageData: imageData,
          imageMimeType: imageMimeType,
          timestamp: DateTime.now(),
          isActive: true,
        );

        _logger.i('🚨 [MQTT] Fraud alert created successfully:');
        _logger.i('🚨 [MQTT] - Alert ID: ${alert.id}');
        _logger.i('🚨 [MQTT] - Title: ${alert.title}');
        _logger.i('🚨 [MQTT] - Message: ${alert.message}');
        _logger.i('🚨 [MQTT] - Type: ${alert.type}');
        _logger.i('🚨 [MQTT] - Video URL: ${alert.videoUrl}');
        _logger.i('🚨 [MQTT] - Image MIME: ${alert.imageMimeType}');
        _logger.i(
          '🚨 [MQTT] - Image Data Length: ${alert.imageData?.length ?? 0}',
        );
        _logger.i('🚨 [MQTT] - Timestamp: ${alert.timestamp}');
        _logger.i('🚨 [MQTT] - Is Active: ${alert.isActive}');

        // Verify complete image data is stored (without logging the full data to avoid truncation)
        if (alert.imageData != null) {
          final imageLength = alert.imageData!.length;
          final firstChars = alert.imageData!.substring(0, 50);
          final lastChars = alert.imageData!.substring(imageLength - 50);

          _logger.i('🚨 [MQTT] - Alert Image Data Verification:');
          _logger.i('🚨 [MQTT] - Total Length: $imageLength chars');
          _logger.i('🚨 [MQTT] - First 50 chars: "$firstChars"');
          _logger.i('🚨 [MQTT] - Last 50 chars: "$lastChars"');
          _logger.i(
            '🚨 [MQTT] - Data integrity check: ${_verifyBase64Integrity(alert.imageData!)}',
          );

          print('🚨 [MQTT] - Alert Image Data Verification:');
          print('🚨 [MQTT] - Total Length: $imageLength chars');
          print('🚨 [MQTT] - First 50 chars: "$firstChars"');
          print('🚨 [MQTT] - Last 50 chars: "$lastChars"');
          print(
            '🚨 [MQTT] - Data integrity check: ${_verifyBase64Integrity(alert.imageData!)}',
          );
        }

        _logger.i('🚨 [MQTT] Broadcasting fraud alert to stream...');
        _alertController.add(alert);
        _logger.i('✅ [MQTT] Fraud alert successfully broadcasted to stream');
      } catch (jsonError) {
        _logger.w('⚠️ [MQTT] Failed to parse message as JSON: $jsonError');
        _logger.w('⚠️ [MQTT] Raw message: $message');
        _logger.i('🚫 [MQTT] Ignoring non-JSON alert message');
        return; // Exit early - don't show non-JSON alerts
      }
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Error processing MQTT message: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
      _logger.e('❌ [MQTT] Message data: ${c?.toString() ?? 'null'}');
    }
  }

  Future<void> disconnect() async {
    try {
      _logger.i('🔌 [MQTT] Initiating disconnection...');
      if (_client != null) {
        _logger.i(
          '🔌 [MQTT] Current connection state: ${_client!.connectionStatus}',
        );
        _logger.i('🔌 [MQTT] Calling disconnect()...');

        _client!.disconnect();
        _isConnected = false;

        _logger.i('✅ [MQTT] Disconnect call completed');
        _logger.i(
          '✅ [MQTT] Connection state after disconnect: ${_client!.connectionStatus}',
        );
        _logger.i('✅ [MQTT] MQTT connection closed successfully');
      } else {
        _logger.w('⚠️ [MQTT] Cannot disconnect - client is null');
      }
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Error closing MQTT connection: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
    }
  }

  bool get isConnected => _isConnected;

  // Additional logging methods
  void logConnectionStatus() {
    _logger.i('📊 [MQTT] Current Connection Status:');
    _logger.i('📊 [MQTT] - Is Connected: $_isConnected');
    _logger.i('📊 [MQTT] - Client Null: ${_client == null}');
    if (_client != null) {
      _logger.i('📊 [MQTT] - Connection State: ${_client!.connectionStatus}');
      _logger.i('📊 [MQTT] - Client ID: ${_client!.clientIdentifier}');
      _logger.i('📊 [MQTT] - Broker: ${_client!.server}');
      _logger.i('📊 [MQTT] - Port: ${_client!.port}');
      _logger.i('📊 [MQTT] - Secure: ${_client!.secure}');
      _logger.i('📊 [MQTT] - Logging: ${_client!.logging}');
      _logger.i('📊 [MQTT] - Auto Reconnect: ${_client!.autoReconnect}');
    }
  }

  // Publish a message (for testing)
  Future<bool> publishMessage(String topic, String message) async {
    try {
      _logger.i('📤 [MQTT] OUTBOUND: Publishing message...');
      print('📤 [MQTT] OUTBOUND: Publishing message...');
      _logger.i('📤 [MQTT] OUTBOUND: - Topic: $topic');
      print('📤 [MQTT] OUTBOUND: - Topic: $topic');
      _logger.i('📤 [MQTT] OUTBOUND: - Message: $message');
      print('📤 [MQTT] OUTBOUND: - Message: $message');

      if (_client == null || !_isConnected) {
        _logger.e('❌ [MQTT] Cannot publish - client is null or not connected');
        return false;
      }

      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      _logger.i('✅ [MQTT] OUTBOUND: Message published successfully');
      print('✅ [MQTT] OUTBOUND: Message published successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Error publishing message: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
      return false;
    }
  }

  /// Send checkout start event to MQTT
  Future<bool> sendCheckoutStartEvent() async {
    final String checkoutTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // ALWAYS generate new transaction and document IDs for new checkout session
    _currentTransactionId = _generateUuid();
    _currentDocumentId = _generateUuid();

    _logger.i(
      '🆔 [MQTT] NEW TRANSACTION: Generated fresh IDs for checkout start',
    );
    print('🆔 [MQTT] NEW TRANSACTION: Generated fresh IDs for checkout start');

    final String message = jsonEncode({
      'id': _currentDocumentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': _currentTransactionId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'checkout_id': _terminalId,
      'event_type': 'checkout_start',
      'checkout_status': 'CHECKOUT_START',
    });

    _logger.i(
      '🛒 [MQTT] OUTBOUND: Sending checkout start event to topic: $checkoutTopic',
    );
    print(
      '🛒 [MQTT] OUTBOUND: Sending checkout start event to topic: $checkoutTopic',
    );
    _logger.i('🛒 [MQTT] Transaction ID: $_currentTransactionId');
    _logger.i('🛒 [MQTT] Document ID: $_currentDocumentId');
    print('🛒 [MQTT] Transaction ID: $_currentTransactionId');
    print('🛒 [MQTT] Document ID: $_currentDocumentId');

    return await publishMessage(checkoutTopic, message);
  }

  /// Send checkout end event to MQTT
  Future<bool> sendCheckoutEndEvent({
    double? billingAmount,
    int? boughtItemCount,
    int? voidedItemCount,
  }) async {
    final String checkoutTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // Get transaction data from parameters or AppController
    double finalBillingAmount = billingAmount ?? 0.0;
    int finalBoughtItemCount = boughtItemCount ?? 0;
    int finalVoidedItemCount = voidedItemCount ?? 0;

    // If not provided in parameters, try to get from AppController
    if (billingAmount == null || boughtItemCount == null) {
      try {
        // Use dynamic type to avoid circular dependency
        final appController = Get.find();
        finalBillingAmount =
            billingAmount ?? (appController.totalAmount as double? ?? 0.0);
        finalBoughtItemCount =
            boughtItemCount ?? (appController.parsedItems?.length as int? ?? 0);
        // Note: voided item count would need to be tracked separately if needed
      } catch (e) {
        _logger.w('Could not get transaction data from AppController: $e');
      }
    }

    // Use existing transaction ID from checkout start, but generate NEW document ID for each request
    final transactionId = _currentTransactionId ?? _generateUuid();
    final documentId = _generateUuid(); // Always generate new document ID

    // If transaction ID was missing, store it for consistency (shouldn't happen for checkout end)
    _currentTransactionId ??= transactionId;

    _logger.i(
      '🆔 [MQTT] CHECKOUT END: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );
    print(
      '🆔 [MQTT] CHECKOUT END: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );

    final String message = jsonEncode({
      'id': documentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': transactionId,
      'checkout_id': _terminalId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'event_type': 'checkout_end',
      'checkout_status': 'CHECKOUT COMPLETE',
      'billing_amount': finalBillingAmount,
      'voided_item_count': finalVoidedItemCount,
      'bought_item_count': finalBoughtItemCount,
    });

    _logger.i(
      '🏁 [MQTT] OUTBOUND: Sending checkout end event to topic: $checkoutTopic',
    );
    print(
      '🏁 [MQTT] OUTBOUND: Sending checkout end event to topic: $checkoutTopic',
    );
    _logger.i('🏁 [MQTT] Billing Amount: $finalBillingAmount AED');
    _logger.i(
      '🏁 [MQTT] Items: $finalBoughtItemCount bought, $finalVoidedItemCount voided',
    );
    print('🏁 [MQTT] Billing Amount: $finalBillingAmount AED');
    print(
      '🏁 [MQTT] Items: $finalBoughtItemCount bought, $finalVoidedItemCount voided',
    );

    return await publishMessage(checkoutTopic, message);
  }

  /// Send item scan event to MQTT when new item received from itemline API
  Future<bool> sendItemScanEvent({
    String? uiStatus,
    String? scanId,
    String? itemId,
    int quantityOfItems = 1,
    bool isReturned = false,
    bool isVoided = false,
    bool isMobileScan = false,
    String scanMode = 'REGULAR',
  }) async {
    final String itemScanTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // Use existing transaction ID from checkout start, but generate NEW document ID for each request
    final transactionId = _currentTransactionId ?? _generateUuid();
    final documentId = _generateUuid(); // Always generate new document ID

    // If transaction ID was missing, store it for consistency
    _currentTransactionId ??= transactionId;

    _logger.i(
      '🆔 [MQTT] ITEM SCAN: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );
    print(
      '🆔 [MQTT] ITEM SCAN: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );

    final String message = jsonEncode({
      'id': documentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': transactionId,
      'checkout_id': _terminalId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'event_type': 'item_scan',
      'scan_type': 'PRODUCT',
      'scan_id':
          scanId ?? _generateUuid(), // Use provided scan ID or generate one
      'item_id':
          itemId ?? _generateUuid(), // Use provided item ID or generate one
      'is_returned': isReturned,
      'is_voided': isVoided,
      'quantity_of_items': quantityOfItems,
      'is_mobile_scan': isMobileScan,
      'scan_mode': scanMode,
    });

    _logger.i(
      '📦 [MQTT] OUTBOUND: Sending item scan event to topic: $itemScanTopic',
    );
    print(
      '📦 [MQTT] OUTBOUND: Sending item scan event to topic: $itemScanTopic',
    );
    _logger.i('📦 [MQTT] UI Status: ${uiStatus ?? 'ITEM_SCANNED'}');
    print('📦 [MQTT] UI Status: ${uiStatus ?? 'ITEM_SCANNED'}');
    _logger.i(
      '📦 [MQTT] Item Details: scan_id=${scanId ?? 'generated'}, item_id=${itemId ?? 'generated'}, quantity=$quantityOfItems',
    );
    print(
      '📦 [MQTT] Item Details: scan_id=${scanId ?? 'generated'}, item_id=${itemId ?? 'generated'}, quantity=$quantityOfItems',
    );

    return await publishMessage(itemScanTopic, message);
  }

  /// Send item info event to MQTT
  Future<bool> sendItemInfoEvent({
    String? uiStatus,
    String? scanId,
    String? itemId,
    double? productPrice,
    String? productName,
    int quantityOfItems = 1,
    bool isReturned = false,
    bool isVoided = false,
    bool isMobileScan = false,
    String scanMode = 'REGULAR',
  }) async {
    final String itemInfoTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // Use existing transaction ID from checkout start, but generate NEW document ID for each request
    final transactionId = _currentTransactionId ?? _generateUuid();
    final documentId = _generateUuid(); // Always generate new document ID

    // If transaction ID was missing, store it for consistency
    _currentTransactionId ??= transactionId;

    _logger.i(
      '🆔 [MQTT] ITEM INFO: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );
    print(
      '🆔 [MQTT] ITEM INFO: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );

    final String message = jsonEncode({
      'id': documentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': transactionId,
      'checkout_id': _terminalId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'event_type': 'item_info',
      'scan_type': 'PRODUCT',
      'scan_id':
          scanId ?? _generateUuid(), // Use provided scan ID or generate one
      'item_id':
          itemId ?? _generateUuid(), // Use provided item ID or generate one
      'product_price': productPrice ?? 0.0,
      'product_name': productName ?? 'Unknown Product',
      'is_voided': isVoided,
      'is_returned': isReturned,
      'quantity_of_items': quantityOfItems,
      'is_mobile_scan': isMobileScan,
      'scan_mode': scanMode,
    });

    _logger.i(
      '📋 [MQTT] OUTBOUND: Sending item info event to topic: $itemInfoTopic',
    );
    print(
      '📋 [MQTT] OUTBOUND: Sending item info event to topic: $itemInfoTopic',
    );
    _logger.i('📋 [MQTT] UI Status: ${uiStatus ?? 'ITEM_INFO'}');
    print('📋 [MQTT] UI Status: ${uiStatus ?? 'ITEM_INFO'}');
    _logger.i(
      '📋 [MQTT] Product Details: name=${productName ?? 'Unknown'}, price=${productPrice ?? 0.0}, qty=$quantityOfItems',
    );
    print(
      '📋 [MQTT] Product Details: name=${productName ?? 'Unknown'}, price=${productPrice ?? 0.0}, qty=$quantityOfItems',
    );

    return await publishMessage(itemInfoTopic, message);
  }

  /// Send payment UI event to MQTT when substate 1010 received
  Future<bool> sendPaymentEvent() async {
    final String paymentTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // Use existing transaction ID from checkout start, but generate NEW document ID for each request
    final transactionId = _currentTransactionId ?? _generateUuid();
    final documentId = _generateUuid(); // Always generate new document ID

    // If transaction ID was missing, store it for consistency
    _currentTransactionId ??= transactionId;

    _logger.i(
      '🆔 [MQTT] PAYMENT: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );
    print(
      '🆔 [MQTT] PAYMENT: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );

    final String message = jsonEncode({
      'event_type': 'ui_event',
      'id': documentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': transactionId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'checkout_id': _terminalId,
      'ui_status': 'PAYMENT',
    });

    _logger.i(
      '💳 [MQTT] OUTBOUND: Sending payment UI event to topic: $paymentTopic',
    );
    print(
      '💳 [MQTT] OUTBOUND: Sending payment UI event to topic: $paymentTopic',
    );
    _logger.i('💳 [MQTT] UI Status: PAYMENT');
    print('💳 [MQTT] UI Status: PAYMENT');

    return await publishMessage(paymentTopic, message);
  }

  /// Send fraud feedback to MQTT
  Future<bool> sendFraudFeedback(String alertId, String feedbackType) async {
    final String feedbackTopic = '${_topicPrefix}$_terminalId/general/outbound';

    // Use existing transaction ID from checkout start, but generate NEW document ID for each request
    final transactionId = _currentTransactionId ?? _generateUuid();
    final documentId = _generateUuid(); // Always generate new document ID

    // If transaction ID was missing, store it for consistency
    _currentTransactionId ??= transactionId;

    _logger.i(
      '🆔 [MQTT] FRAUD FEEDBACK: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );
    print(
      '🆔 [MQTT] FRAUD FEEDBACK: Using transaction ID: ${transactionId.substring(0, 8)}... | NEW document ID: ${documentId.substring(0, 8)}...',
    );

    final String message = jsonEncode({
      'event_type': 'fraud_alert_feedback',
      'id': documentId,
      'store_id': '123',
      'client_id': _terminalId,
      'transaction_id': transactionId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'checkout_id': _terminalId,
      'feedback_type': feedbackType,
      'alert_id': alertId,
    });

    _logger.i(
      '📤 [MQTT] OUTBOUND: Sending fraud feedback to topic: $feedbackTopic - Alert ID: $alertId, Type: $feedbackType',
    );
    print(
      '📤 [MQTT] OUTBOUND: Sending fraud feedback to topic: $feedbackTopic - Alert ID: $alertId, Type: $feedbackType',
    );
    return await publishMessage(feedbackTopic, message);
  }

  /// Schedule auto-reconnection after disconnect
  void _scheduleReconnection() {
    // Cancel any existing reconnection timer
    _reconnectTimer?.cancel();

    // Don't reconnect if we've exceeded max attempts
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.e(
        '❌ [MQTT] Max reconnection attempts ($_maxReconnectAttempts) reached',
      );
      _logger.e('❌ [MQTT] Auto-reconnection disabled');
      return;
    }

    _reconnectAttempts++;
    _logger.w(
      '🔄 [MQTT] Scheduling reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts in ${_reconnectDelay.inSeconds}s',
    );

    _reconnectTimer = Timer(_reconnectDelay, () async {
      _logger.i('🔄 [MQTT] Attempting auto-reconnection...');
      final success = await connect();

      if (success) {
        _logger.i('✅ [MQTT] Auto-reconnection successful');
        _reconnectAttempts = 0; // Reset counter on successful connection
      } else {
        _logger.w('❌ [MQTT] Auto-reconnection failed');
        // _scheduleReconnection will be called again by _onDisconnected if needed
      }
    });
  }

  /// Start connection monitoring to detect and handle connection issues
  void startConnectionMonitoring() {
    _logger.i('🔍 [MQTT] Starting connection monitoring...');

    // Check connection status every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isConnected && _reconnectAttempts < _maxReconnectAttempts) {
        _logger.w(
          '🔍 [MQTT] Connection monitoring: Not connected, attempting reconnection',
        );
        _scheduleReconnection();
      } else if (_isConnected) {
        // Reset reconnect attempts when connection is healthy
        if (_reconnectAttempts > 0) {
          _logger.i(
            '🔍 [MQTT] Connection monitoring: Healthy, reset reconnect counter',
          );
          _reconnectAttempts = 0;
        }
      }
    });
  }

  /// Reset reconnection attempts (useful for manual reconnection)
  void resetReconnectionAttempts() {
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    _logger.i('🔄 [MQTT] Reconnection attempts counter reset');
  }

  /// Manual reconnection method
  Future<bool> reconnect() async {
    _logger.i('🔄 [MQTT] Manual reconnection requested...');

    // Cancel any auto-reconnection timer
    _reconnectTimer?.cancel();

    // Disconnect first if connected
    if (_isConnected) {
      disconnect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Reset reconnection attempts for manual reconnection
    _reconnectAttempts = 0;

    // Attempt connection
    final success = await connect();

    if (success) {
      _logger.i('✅ [MQTT] Manual reconnection successful');
    } else {
      _logger.w('❌ [MQTT] Manual reconnection failed');
    }

    return success;
  }

  void dispose() {
    _logger.i('🔌 [MQTT] Disposing MQTT service...');

    // Cancel reconnection timer
    _reconnectTimer?.cancel();

    _logger.i('🔌 [MQTT] Closing alert controller stream...');
    _alertController.close();
    _logger.i('🔌 [MQTT] Alert controller stream closed');
    _logger.i('🔌 [MQTT] Calling disconnect...');
    disconnect();
    _logger.i('✅ [MQTT] MQTT service disposed successfully');
  }

  // Test method for assistant screen
  Future<bool> testConnection() async {
    try {
      _logger.i('🧪 [MQTT] Starting comprehensive connection test...');
      _logger.i('🧪 [MQTT] Current connection status: $_isConnected');

      // First test broker reachability
      _logger.i('🧪 [MQTT] Step 1: Testing broker reachability...');
      final brokerReachable = await testBrokerReachability();

      if (!brokerReachable) {
        _logger.e('❌ [MQTT] Broker reachability test failed');
        _logger.e('❌ [MQTT] Cannot proceed with connection test');
        _logger.e('❌ [MQTT] Troubleshooting steps:');
        _logger.e(
          '❌ [MQTT] 1. Check if MQTT broker is running at 192.168.2.173:1883',
        );
        _logger.e('❌ [MQTT] 2. Verify network connectivity to broker');
        _logger.e('❌ [MQTT] 3. Check firewall settings');
        _logger.e('❌ [MQTT] 4. Verify broker configuration');
        return false;
      }

      _logger.i('✅ [MQTT] Broker reachability test passed');

      // Now test actual connection
      _logger.i('🧪 [MQTT] Step 2: Testing actual connection...');
      final result = await connect();
      _logger.i('🧪 [MQTT] Connection test result: $result');

      if (result) {
        _logger.i('✅ [MQTT] Full connection test successful');
      } else {
        _logger.w(
          '⚠️ [MQTT] Connection test failed despite broker being reachable',
        );
        _logger.w('⚠️ [MQTT] Possible authentication or configuration issues');
      }

      return result;
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Test connection error: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
      return false;
    }
  }

  // Get current topic configuration
  Map<String, String> getTopicConfiguration() {
    return {
      'topicPrefix': _topicPrefix,
      'alertsTopic': _alertsTopic,
      'fraudInboundTopic': _fraudInboundTopic,
    };
  }

  // Get the alerts topic for external use
  String get alertsTopic => _alertsTopic;

  // Get the fraud inbound topic for external use
  String get fraudInboundTopic => _fraudInboundTopic;

  // Get the topic prefix for external use
  String get topicPrefix => _topicPrefix;

  // Get the current terminal ID for external use
  String get terminalId => _terminalId;

  // Check connection status without attempting to connect
  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected,
      'clientExists': _client != null,
      'connectionState': _client?.connectionStatus?.toString() ?? 'Unknown',
      'brokerAddress': '192.168.2.173',
      'brokerPort': 1883,
      'topicPrefix': _topicPrefix,
      'alertsTopic': _alertsTopic,
      'reconnectAttempts': _reconnectAttempts,
      'maxReconnectAttempts': _maxReconnectAttempts,
      'autoReconnectActive': _reconnectTimer?.isActive ?? false,
    };
  }

  // Test broker reachability (simplified ping test)
  Future<bool> testBrokerReachability() async {
    try {
      _logger.i('🌐 [MQTT] Testing broker reachability...');

      // Create a temporary client just for testing
      final testClient = MqttServerClient(
        '192.168.2.173',
        'test_client_${DateTime.now().millisecondsSinceEpoch}',
      );
      testClient.port = 1883;
      testClient.secure = false;
      testClient.logging(on: false);
      testClient.connectTimeoutPeriod = 5000; // 5 second timeout for test

      _logger.i('🌐 [MQTT] Attempting connection test...');
      await testClient.connect('admin', 'admin');

      // Wait briefly for connection
      await Future.delayed(const Duration(milliseconds: 200));

      final isReachable =
          testClient.connectionStatus?.state == MqttConnectionState.connected;

      if (isReachable) {
        _logger.i('✅ [MQTT] Broker is reachable');
        testClient.disconnect();
      } else {
        _logger.w('⚠️ [MQTT] Broker is not reachable');
      }

      return isReachable;
    } catch (e) {
      _logger.e('❌ [MQTT] Broker reachability test failed: $e');
      return false;
    }
  }

  // Simulate alert for testing
  void simulateAlert() {
    _logger.i('🧪 [MQTT] Simulating test alert...');
    final testAlert = AlertMessage(
      id: 'TEST_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Alert',
      message: 'This is a test alert message',
      type: AlertType.system,
      videoUrl: 'https://example.com/test_video.mp4',
      timestamp: DateTime.now(),
      isActive: true,
    );

    _logger.i('🧪 [MQTT] Test alert created:');
    _logger.i('🧪 [MQTT] - Alert ID: ${testAlert.id}');
    _logger.i('🧪 [MQTT] - Title: ${testAlert.title}');
    _logger.i('🧪 [MQTT] - Message: ${testAlert.message}');
    _logger.i('🧪 [MQTT] - Type: ${testAlert.type}');
    _logger.i('🧪 [MQTT] Broadcasting test alert to stream...');

    _alertController.add(testAlert);
    _logger.i('✅ [MQTT] Test alert successfully broadcasted');
  }

  // Update MQTT settings
  Future<void> updateSettings({
    required String brokerHost,
    required int brokerPort,
    required String username,
    required String password,
    required String topic,
  }) async {
    _logger.i('🔧 [MQTT] Updating MQTT settings...');
    _logger.i('🔧 [MQTT] - Broker Host: $brokerHost');
    _logger.i('🔧 [MQTT] - Broker Port: $brokerPort');
    _logger.i('🔧 [MQTT] - Username: $username');
    _logger.i('🔧 [MQTT] - Topic: $topic');

    this.brokerHost = brokerHost;
    this.brokerPort = brokerPort;
    this.username = username;
    this.password = password;
    this.topic = topic;

    _logger.i('✅ [MQTT] Settings updated successfully');
  }

  // Update terminal ID
  void updateTerminalId(String terminalId) {
    _logger.i('🔧 [MQTT] Updating terminal ID: $_terminalId → $terminalId');
    _terminalId = terminalId;
    _logger.i('✅ [MQTT] Terminal ID updated successfully');
  }

  // Update topic prefix
  void updateTopicPrefix(String topicPrefix) {
    _logger.i('🔧 [MQTT] Updating topic prefix: $_topicPrefix → $topicPrefix');
    // Note: _topicPrefix is static const, so we can't change it at runtime
    // This would require a more significant refactor to make it dynamic
    _logger.w(
      '⚠️ [MQTT] Topic prefix is currently static and cannot be changed at runtime',
    );
  }

  /// Reset transaction IDs for new transaction
  void resetTransactionIds() {
    _currentTransactionId = null;
    // Note: _currentDocumentId is no longer stored since we generate new document ID for each request
    _logger.i(
      '🔄 [MQTT] Transaction ID reset for new transaction (document IDs are now generated per request)',
    );
    print(
      '🔄 [MQTT] Transaction ID reset for new transaction (document IDs are now generated per request)',
    );
  }

  /// Get current transaction info for debugging
  Map<String, String?> getTransactionInfo() {
    return {
      'transactionId': _currentTransactionId,
      'documentId': 'Generated per request (not stored)',
    };
  }

  /// Get current subscription info for debugging
  Map<String, dynamic> getSubscriptionInfo() {
    return {
      'subscribedTopics': [_alertsTopic, _fraudInboundTopic],
      'terminalId': _terminalId,
      'clientId': _client?.clientIdentifier ?? 'Not connected',
      'isConnected': _isConnected,
      'expectedInboundTopics': [_alertsTopic, _fraudInboundTopic],
      'ourOutboundTopic': '${_topicPrefix}$_terminalId/general/outbound',
    };
  }

  /// Log detailed subscription information for debugging
  void logSubscriptionDebugInfo() {
    final info = getSubscriptionInfo();
    _logger.i('🔍 [MQTT] SUBSCRIPTION DEBUG INFO:');
    print('🔍 [MQTT] SUBSCRIPTION DEBUG INFO:');
    _logger.i('🔍 [MQTT] - Our Terminal ID: $_terminalId');
    print('🔍 [MQTT] - Our Terminal ID: $_terminalId');
    _logger.i('🔍 [MQTT] - Our Client ID: ${info['clientId']}');
    print('🔍 [MQTT] - Our Client ID: ${info['clientId']}');
    _logger.i('🔍 [MQTT] - Subscribed to: ${info['subscribedTopics']}');
    print('🔍 [MQTT] - Subscribed to: ${info['subscribedTopics']}');
    _logger.i('🔍 [MQTT] - We publish to: ${info['ourOutboundTopic']}');
    print('🔍 [MQTT] - We publish to: ${info['ourOutboundTopic']}');
    _logger.i('🔍 [MQTT] - Expected inbound: ${info['expectedInboundTopics']}');
    print('🔍 [MQTT] - Expected inbound: ${info['expectedInboundTopics']}');
    _logger.i('🔍 [MQTT] - Connection status: ${info['isConnected']}');
    print('🔍 [MQTT] - Connection status: ${info['isConnected']}');
  }
}
