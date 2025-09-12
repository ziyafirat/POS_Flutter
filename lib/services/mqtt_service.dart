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
  
  // MQTT Configuration - Topic Prefix
  static const String _topicPrefix = 'ssco/idol/';
  static const String _alertsTopic = '${_topicPrefix}alerts';

  Stream<AlertMessage> get alertStream => _alertController.stream;

  Future<bool> connect() async {
    try {
      // Check if already connected
      if (_isConnected && _client?.connectionStatus == MqttConnectionState.connected) {
        _logger.i('✅ [MQTT] Already connected to broker');
        return true;
      }
      
      // Disconnect existing connection if any
      if (_client != null) {
        _logger.i('🔌 [MQTT] Disconnecting existing connection...');
        await disconnect();
      }
      
      // MQTT Configuration
      const String brokerAddress = '192.168.2.173';
      const int brokerPort = 1883;
      const String clientIdentifier = '500';
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
      _client!.logging(on: true); // Enable logging for debugging
      _client!.autoReconnect = false;
      _client!.keepAlivePeriod = 20; // Set keep alive period
      _client!.connectTimeoutPeriod = 10000; // 10 second timeout
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
      _logger.i('🔌 [MQTT] Connection timeout: ${_client!.connectTimeoutPeriod}ms');
      
      try {
        await _client!.connect(mqttUsername, mqttPassword);
        _logger.i('🔌 [MQTT] Connection attempt completed. Status: ${_client!.connectionStatus}');
      } catch (connectError) {
        _logger.e('❌ [MQTT] Connection attempt failed with error: $connectError');
        _logger.e('❌ [MQTT] Connection status: ${_client!.connectionStatus}');
        return false;
      }
      
      // Wait a moment for connection to establish
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_client!.connectionStatus == MqttConnectionState.connected) {
        _isConnected = true;
        _logger.i('✅ [MQTT] Connection established successfully!');
        _logger.i('✅ [MQTT] Client state: ${_client!.connectionStatus}');
        _logger.i('✅ [MQTT] Client ID: ${_client!.clientIdentifier}');
        _logger.i('✅ [MQTT] Broker: ${_client!.server}:${_client!.port}');
        _subscribeToTopics();
        return true;
      } else {
        _logger.e('❌ [MQTT] Connection failed. Status: ${_client!.connectionStatus}');
        _logger.e('❌ [MQTT] Connection state: ${_client!.connectionStatus}');
        _logger.e('❌ [MQTT] Possible causes:');
        _logger.e('❌ [MQTT] - Broker not running at $brokerAddress:$brokerPort');
        _logger.e('❌ [MQTT] - Network connectivity issues');
        _logger.e('❌ [MQTT] - Authentication failed (username/password)');
        _logger.e('❌ [MQTT] - Client ID conflict');
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
      _logger.i('📡 [MQTT] Topic Prefix: $_topicPrefix');
      _logger.i('📡 [MQTT] Topic: $_alertsTopic');
      _logger.i('📡 [MQTT] QoS: ${MqttQos.atLeastOnce}');
      
      _client!.subscribe(_alertsTopic, MqttQos.atLeastOnce);
      _logger.i('📡 [MQTT] Subscription request sent');
      
      _client!.updates!.listen(_onMessage);
      _logger.i('📡 [MQTT] Message listener attached');
      _logger.i('📡 [MQTT] Ready to receive messages on topic: $_alertsTopic');
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
        _logger.e('❌ [MQTT] 1. Check if MQTT broker is running at 192.168.2.173:1883');
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
        _logger.i('✅ [MQTT] Connected to: ssco/idol/alerts');
      } else {
        _logger.w('⚠️ [MQTT] Connection test failed despite broker being reachable');
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
    };
  }
  
  // Get the alerts topic for external use
  String get alertsTopic => _alertsTopic;
  
  // Get the topic prefix for external use
  String get topicPrefix => _topicPrefix;
  
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
    };
  }
  
  // Test broker reachability (simplified ping test)
  Future<bool> testBrokerReachability() async {
    try {
      _logger.i('🌐 [MQTT] Testing broker reachability...');
      
      // Create a temporary client just for testing
      final testClient = MqttServerClient('192.168.2.173', 'test_client_${DateTime.now().millisecondsSinceEpoch}');
      testClient.port = 1883;
      testClient.secure = false;
      testClient.logging(on: false);
      testClient.connectTimeoutPeriod = 5000; // 5 second timeout for test
      
      _logger.i('🌐 [MQTT] Attempting connection test...');
      await testClient.connect('admin', 'admin');
      
      // Wait briefly for connection
      await Future.delayed(const Duration(milliseconds: 200));
      
      final isReachable = testClient.connectionStatus == MqttConnectionState.connected;
      
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
}
