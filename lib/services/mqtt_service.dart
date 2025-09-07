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
      _logger.i('Connecting to MQTT broker...');
      
      // Skip MQTT connection on web platform due to SecurityContext limitations
      if (kIsWeb) {
        _logger.w('MQTT connection skipped on web platform');
        _isConnected = false;
        return false;
      }
      
      _client = MqttServerClient('localhost', 'self_checkout_client'); // Replace with actual broker
      _client!.port = 1883;
      _client!.keepAlivePeriod = 20;
      _client!.autoReconnect = true;
      _client!.onDisconnected = _onDisconnected;
      _client!.onConnected = _onConnected;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier('self_checkout_client')
          .withWillTopic('self_checkout/status')
          .withWillMessage('offline')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      _client!.connectionMessage = connMessage;

      await _client!.connect();
      
      if (_client!.connectionStatus == MqttConnectionState.connected) {
        _isConnected = true;
        _subscribeToTopics();
        _logger.i('MQTT connection established');
        return true;
      } else {
        _logger.e('MQTT connection failed');
        return false;
      }
    } catch (e) {
      _logger.e('Failed to connect to MQTT broker: $e');
      _isConnected = false;
      return false;
    }
  }

  void _onConnected() {
    _logger.i('MQTT client connected');
    _isConnected = true;
  }

  void _onDisconnected() {
    _logger.i('MQTT client disconnected');
    _isConnected = false;
  }

  void _subscribeToTopics() {
    if (_client != null && _isConnected) {
      _client!.subscribe('self_checkout/alerts', MqttQos.atLeastOnce);
      _client!.updates!.listen(_onMessage);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    try {
      _logger.i('Received MQTT message: $message');
      
      // Parse alert message (simplified - in real app, use proper JSON parsing)
      final alert = AlertMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Security Alert',
        message: message,
        type: AlertType.security,
        videoUrl: 'https://example.com/alert_video.mp4', // Mock video URL
        timestamp: DateTime.now(),
        isActive: true,
      );

      _alertController.add(alert);
    } catch (e) {
      _logger.e('Error processing MQTT message: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      if (_client != null) {
        _client!.disconnect();
        _isConnected = false;
        _logger.i('MQTT connection closed');
      }
    } catch (e) {
      _logger.e('Error closing MQTT connection: $e');
    }
  }

  bool get isConnected => _isConnected;

  void dispose() {
    _alertController.close();
    disconnect();
  }

  // Test method for assistant screen
  Future<bool> testConnection() async {
    return await connect();
  }

  // Simulate alert for testing
  void simulateAlert() {
    final testAlert = AlertMessage(
      id: 'TEST_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Alert',
      message: 'This is a test alert message',
      type: AlertType.system,
      videoUrl: 'https://example.com/test_video.mp4',
      timestamp: DateTime.now(),
      isActive: true,
    );
    
    _alertController.add(testAlert);
  }
}
