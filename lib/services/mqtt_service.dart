import 'dart:async';
import 'package:flutter/foundation.dart';
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
  final StreamController<AlertMessage> _alertController = StreamController<AlertMessage>.broadcast();

  Stream<AlertMessage> get alertStream => _alertController.stream;

  Future<bool> connect() async {
    try {
      // MQTT Configuration
      const String brokerAddress = 'dev-solace-node.walkout.eu';
      const int brokerPort = 30285;
      const String clientIdentifier = 'self_checkout_client';
      const String mqttUsername = 'admin'; // Replace with actual username
      const String mqttPassword = 'admin'; // Replace with actual password
      const bool mqttSecure = false; // Set to true if using SSL/TLS
      
      _logger.i('🔌 [MQTT] Starting connection to broker...');
      _logger.i('🔌 [MQTT] Broker: $brokerAddress:$brokerPort');
      _logger.i('🔌 [MQTT] Client ID: $clientIdentifier');
      _logger.i('🔌 [MQTT] Username: $mqttUsername');
      _logger.i('🔌 [MQTT] Secure: $mqttSecure');
      
      // Skip MQTT connection on web platform due to SecurityContext limitations
      if (kIsWeb) {
        _logger.w('⚠️ [MQTT] Connection skipped on web platform (SecurityContext limitations)');
        _isConnected = false;
        return false;
      }
      
      _logger.i('🔌 [MQTT] Creating MQTT client instance...');
      _client = MqttServerClient(brokerAddress, clientIdentifier);
      _client!.port = brokerPort;
      _client!.secure = mqttSecure;
      _client!.logging(on: false);
      _client!.autoReconnect = false;
      // _client!.onBadCertificate = (_) => true; // Uncomment if needed for SSL
      
      _logger.i('🔌 [MQTT] Client configuration:');
      _logger.i('🔌 [MQTT] - Port: ${_client!.port}');
      _logger.i('🔌 [MQTT] - Secure: ${_client!.secure}');
      _logger.i('🔌 [MQTT] - Logging: ${_client!.logging}');
      _logger.i('🔌 [MQTT] - Auto Reconnect: ${_client!.autoReconnect}');

      _logger.i('🔌 [MQTT] Configuring connection message with authentication...');
      _client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientIdentifier)
          .authenticateAs(mqttUsername, mqttPassword);

      _logger.i('🔌 [MQTT] Connection message configured:');
      _logger.i('🔌 [MQTT] - Client ID: $clientIdentifier');
      _logger.i('🔌 [MQTT] - Username: $mqttUsername');
      _logger.i('🔌 [MQTT] - Password: [HIDDEN]');

      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;

      _logger.i('🔌 [MQTT] Attempting to connect with authentication...');
      await _client!.connect(mqttUsername, mqttPassword);
      
      _logger.i('🔌 [MQTT] Connection attempt completed. Status: ${_client!.connectionStatus}');
      
      if (_client!.connectionStatus == MqttConnectionState.connected) {
        _isConnected = true;
        _logger.i('✅ [MQTT] Connection established successfully!');
        _logger.i('✅ [MQTT] Client state: ${_client!.connectionStatus}');
        _subscribeToTopics();
        return true;
      } else {
        _logger.e('❌ [MQTT] Connection failed. Status: ${_client!.connectionStatus}');
        _logger.e('❌ [MQTT] Connection state: ${_client!.connectionStatus}');
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
  }

  void _onDisconnected() {
    _logger.w('⚠️ [MQTT] Client disconnected callback triggered');
    _logger.w('⚠️ [MQTT] Connection state: ${_client?.connectionStatus}');
    _isConnected = false;
  }

  void _subscribeToTopics() {
    if (_client != null && _isConnected) {
      _logger.i('📡 [MQTT] Subscribing to topics...');
      _logger.i('📡 [MQTT] Topic: self_checkout/alerts');
      _logger.i('📡 [MQTT] QoS: ${MqttQos.atLeastOnce}');
      
      _client!.subscribe('self_checkout/alerts', MqttQos.atLeastOnce);
      _logger.i('📡 [MQTT] Subscription request sent');
      
      _client!.updates!.listen(_onMessage);
      _logger.i('📡 [MQTT] Message listener attached');
      _logger.i('📡 [MQTT] Ready to receive messages on topic: self_checkout/alerts');
    } else {
      _logger.e('❌ [MQTT] Cannot subscribe - client is null or not connected');
      _logger.e('❌ [MQTT] Client null: ${_client == null}');
      _logger.e('❌ [MQTT] Is connected: $_isConnected');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? c) {
    try {
      _logger.i('📨 [MQTT] Message received!');
      _logger.i('📨 [MQTT] Message count: ${c?.length ?? 0}');
      
      if (c == null || c.isEmpty) {
        _logger.w('⚠️ [MQTT] Empty message list received');
        return;
      }

      final recMess = c[0];
      _logger.i('📨 [MQTT] Message details:');
      _logger.i('📨 [MQTT] - Topic: ${recMess.topic}');
      
      final payload = recMess.payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(payload.payload.message);
      
      _logger.i('📨 [MQTT] Raw message payload: $message');
      _logger.i('📨 [MQTT] Message length: ${message.length} characters');
      
      // Parse alert message (simplified - in real app, use proper JSON parsing)
      _logger.i('🚨 [MQTT] Processing alert message...');
      final alert = AlertMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Security Alert',
        message: message,
        type: AlertType.security,
        videoUrl: 'https://example.com/alert_video.mp4', // Mock video URL
        timestamp: DateTime.now(),
        isActive: true,
      );

      _logger.i('🚨 [MQTT] Alert created successfully:');
      _logger.i('🚨 [MQTT] - Alert ID: ${alert.id}');
      _logger.i('🚨 [MQTT] - Title: ${alert.title}');
      _logger.i('🚨 [MQTT] - Message: ${alert.message}');
      _logger.i('🚨 [MQTT] - Type: ${alert.type}');
      _logger.i('🚨 [MQTT] - Video URL: ${alert.videoUrl}');
      _logger.i('🚨 [MQTT] - Timestamp: ${alert.timestamp}');
      _logger.i('🚨 [MQTT] - Is Active: ${alert.isActive}');

      _logger.i('🚨 [MQTT] Broadcasting alert to stream...');
      _alertController.add(alert);
      _logger.i('✅ [MQTT] Alert successfully broadcasted to stream');
      
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
        _logger.i('🔌 [MQTT] Current connection state: ${_client!.connectionStatus}');
        _logger.i('🔌 [MQTT] Calling disconnect()...');
        
        _client!.disconnect();
        _isConnected = false;
        
        _logger.i('✅ [MQTT] Disconnect call completed');
        _logger.i('✅ [MQTT] Connection state after disconnect: ${_client!.connectionStatus}');
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
      _logger.i('📤 [MQTT] Publishing message...');
      _logger.i('📤 [MQTT] - Topic: $topic');
      _logger.i('📤 [MQTT] - Message: $message');
      
      if (_client == null || !_isConnected) {
        _logger.e('❌ [MQTT] Cannot publish - client is null or not connected');
        return false;
      }

      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      
      _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      _logger.i('✅ [MQTT] Message published successfully');
      return true;
    } catch (e, stackTrace) {
      _logger.e('❌ [MQTT] Error publishing message: $e');
      _logger.e('❌ [MQTT] Stack trace: $stackTrace');
      return false;
    }
  }

  void dispose() {
    _logger.i('🔌 [MQTT] Disposing MQTT service...');
    _logger.i('🔌 [MQTT] Closing alert controller stream...');
    _alertController.close();
    _logger.i('🔌 [MQTT] Alert controller stream closed');
    _logger.i('🔌 [MQTT] Calling disconnect...');
    disconnect();
    _logger.i('✅ [MQTT] MQTT service disposed successfully');
  }

  // Test method for assistant screen
  Future<bool> testConnection() async {
    _logger.i('🧪 [MQTT] Testing connection...');
    final result = await connect();
    _logger.i('🧪 [MQTT] Test connection result: $result');
    return result;
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
}
