import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// Standalone MQTT Test Class
/// This class provides complete MQTT communication testing functionality
/// with hardcoded values and no external dependencies
class MqttTest {
  // Hardcoded MQTT Configuration
  static const String _brokerHost = '192.168.2.173';
  static const int _brokerPort = 1883;
  static const String _clientId = '500';
  static const String _username = 'admin';
  static const String _password = 'admin';
  
  // Hardcoded Topics
  static const String _publishTopic = 'ssco/idol/500/general/outbound';
  static const String _subscribeTopic = 'ssco/idol/500/general/inbound';
  static const String _statusTopic = 'ssco/idol/500/general/outbound';
  static const String _commandTopic = 'ssco/idol/500/general/outbound';
  
  // MQTT Client
  late MqttServerClient _client;
  bool _isConnected = false;
  List<String> _receivedMessages = [];
  StreamController<String> _messageController = StreamController<String>.broadcast();
  
  // Getters
  bool get isConnected => _isConnected;
  List<String> get receivedMessages => List.unmodifiable(_receivedMessages);
  Stream<String> get messageStream => _messageController.stream;
  
  /// Initialize MQTT Client with hardcoded configuration
  Future<bool> initialize() async {
    try {
      _client = MqttServerClient(_brokerHost, _clientId);
      _client.port = _brokerPort;
      _client.keepAlivePeriod = 20;
      _client.autoReconnect = false;
      _client.secure = false;
      

      _client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(_clientId)
          .authenticateAs(_username, _password);
      // Set connection message
    //   _client.connectionMessage = MqttConnectMessage()
    //       .withClientIdentifier(_clientId)
    //       .withWillTopic(_statusTopic)
    //       .withWillMessage('Client disconnected')
    //       .withWillQos(MqttQos.atLeastOnce)
    //       .startClean()
    //       .withWillRetain();
      
      // Set logging
      _client.logging(on: true);
      
      // Set onConnected callback
      _client.onConnected = _onConnected;
      _client.onDisconnected = _onDisconnected;
      _client.onSubscribed = _onSubscribed;
      _client.onUnsubscribed = _onUnsubscribed;
      
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
      final connectionStatus = await _client.connect(_username, _password);
      
      if (connectionStatus == MqttConnectionState.connected) {
        _isConnected = true;
        debugPrint('MQTT Test - Connected successfully');
        
        // Subscribe to test topics
        await _subscribeToTopics();
        
        // Publish connection status
        await publishStatus('Client connected');
        
        return true;
      } else {
        debugPrint('MQTT Test - Connection failed: $connectionStatus');
        return false;
      }
    } catch (e) {
      debugPrint('MQTT Test - Connection error: $e');
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
  
  /// Subscribe to hardcoded test topics
  Future<void> _subscribeToTopics() async {
    try {
      // Subscribe to main test topic
      _client.subscribe(_subscribeTopic, MqttQos.atLeastOnce);
      
      // Subscribe to status topic
      _client.subscribe(_statusTopic, MqttQos.atLeastOnce);
      
      // Subscribe to command topic
      _client.subscribe(_commandTopic, MqttQos.atLeastOnce);
      
      // Set up message listener
      _client.updates?.listen(_onMessageReceived);
      
      debugPrint('MQTT Test - Subscribed to topics');
    } catch (e) {
      debugPrint('MQTT Test - Subscription error: $e');
    }
  }
  
  /// Publish test message
  Future<bool> publishTestMessage(String message) async {
    return await _publishMessage(_publishTopic, message);
  }
  
  /// Publish status message
  Future<bool> publishStatus(String status) async {
    final statusData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'status': status,
      'connected': _isConnected,
    };
    return await _publishMessage(_statusTopic, jsonEncode(statusData));
  }
  
  /// Publish command message
  Future<bool> publishCommand(String command, Map<String, dynamic>? data) async {
    final commandData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'command': command,
      'data': data ?? {},
    };
    return await _publishMessage(_commandTopic, jsonEncode(commandData));
  }
  
  /// Publish POS transaction data (hardcoded example)
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
    
    return await _publishMessage('idolpos/transaction', jsonEncode(transactionData));
  }
  
  /// Publish TSA state change (hardcoded example)
  Future<bool> publishTsaState(String state, String substate) async {
    final stateData = {
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _clientId,
      'state': state,
      'substate': substate,
      'screen_type': 'sco_common',
      'description': 'TSA State Change',
    };
    
    return await _publishMessage('idolpos/tsa/state', jsonEncode(stateData));
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
    return await publishCommand('test', {
      'message': 'Hello from MQTT Test Client',
      'test_id': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Send scan command
  Future<bool> sendScanCommand(String barcode) async {
    return await publishCommand('scan', {
      'barcode': barcode,
      'scanner_id': 'scanner_001',
      'location': 'checkout_1',
    });
  }
  
  /// Send payment command
  Future<bool> sendPaymentCommand(double amount, String method) async {
    return await publishCommand('payment', {
      'amount': amount,
      'method': method,
      'transaction_id': 'PAY_${DateTime.now().millisecondsSinceEpoch}',
    });
  }
  
  /// Send alert command
  Future<bool> sendAlertCommand(String alertType, String message) async {
    return await publishCommand('alert', {
      'type': alertType,
      'message': message,
      'severity': 'high',
      'requires_action': true,
    });
  }
  
  /// Run complete test sequence
  Future<void> runTestSequence() async {
    debugPrint('MQTT Test - Starting test sequence...');
    
    // Initialize and connect
    if (await initialize() && await connect()) {
      // Wait a moment for connection to stabilize
      await Future.delayed(Duration(seconds: 2));
      
      // Send test messages
      await publishTestMessage('Test message 1');
      await Future.delayed(Duration(seconds: 1));
      
      await publishTestMessage('Test message 2');
      await Future.delayed(Duration(seconds: 1));
      
      // Send commands
      await sendTestCommand();
      await Future.delayed(Duration(seconds: 1));
      
      await sendScanCommand('1234567890123');
      await Future.delayed(Duration(seconds: 1));
      
      await sendPaymentCommand(25.50, 'card');
      await Future.delayed(Duration(seconds: 1));
      
      await sendAlertCommand('error', 'Test error message');
      await Future.delayed(Duration(seconds: 1));
      
      // Send transaction data
      await publishTransaction();
      await Future.delayed(Duration(seconds: 1));
      
      // Send TSA state
      await publishTsaState('1008', 'goHomeScreen');
      await Future.delayed(Duration(seconds: 1));
      
      await publishTsaState('1002', 'goPaymentScreen');
      await Future.delayed(Duration(seconds: 1));
      
      // Send final status
      await publishStatus('Test sequence completed');
      
      debugPrint('MQTT Test - Test sequence completed');
    } else {
      debugPrint('MQTT Test - Failed to connect, test sequence aborted');
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
  }
  
  /// Callback: Connected
  void _onConnected() {
    _isConnected = true;
    debugPrint('MQTT Test - Connected callback triggered');
  }
  
  /// Callback: Disconnected
  void _onDisconnected() {
    _isConnected = false;
    debugPrint('MQTT Test - Disconnected callback triggered');
  }
  
  /// Callback: Subscribed
  void _onSubscribed(String topic) {
    debugPrint('MQTT Test - Subscribed to: $topic');
  }
  
  /// Callback: Unsubscribed
  void _onUnsubscribed(String? topic) {
    debugPrint('MQTT Test - Unsubscribed from: $topic');
  }
  
  /// Callback: Message received
  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null) return;
    
    for (final message in messages) {
      final payload = MqttPublishPayload.bytesToStringAsString((message.payload as MqttPublishMessage).payload.message);
      final topic = message.topic;
      
      final receivedMessage = '[$topic] $payload';
      _receivedMessages.add(receivedMessage);
      _messageController.add(receivedMessage);
      
      debugPrint('MQTT Test - Received: $receivedMessage');
    }
  }
  
  /// Dispose resources
  void dispose() {
    _messageController.close();
    if (_isConnected) {
      disconnect();
    }
  }
}
