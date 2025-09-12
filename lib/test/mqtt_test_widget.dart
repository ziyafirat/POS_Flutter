import 'package:flutter/material.dart';
import 'mqtt_test.dart';

/// Simple Widget to test MQTT functionality
class MqttTestWidget extends StatefulWidget {
  const MqttTestWidget({super.key});

  @override
  State<MqttTestWidget> createState() => _MqttTestWidgetState();
}

class _MqttTestWidgetState extends State<MqttTestWidget> {
  final MqttTest _mqttTest = MqttTest();
  List<String> _messages = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _setupMqttListener();
  }

  void _setupMqttListener() {
    _mqttTest.messageStream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _mqttTest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status
            Card(
              color: _isConnected ? Colors.green[100] : Colors.red[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Connection Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_mqttTest.getConnectionStatus()),
                    Text('Messages received: ${_mqttTest.getReceivedMessagesCount()}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Control Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _connect,
                  child: const Text('Connect'),
                ),
                ElevatedButton(
                  onPressed: _disconnect,
                  child: const Text('Disconnect'),
                ),
                ElevatedButton(
                  onPressed: _sendTestMessage,
                  child: const Text('Send Test'),
                ),
                ElevatedButton(
                  onPressed: _sendScanCommand,
                  child: const Text('Send Scan'),
                ),
                ElevatedButton(
                  onPressed: _sendPaymentCommand,
                  child: const Text('Send Payment'),
                ),
                ElevatedButton(
                  onPressed: _sendAlertCommand,
                  child: const Text('Send Alert'),
                ),
                ElevatedButton(
                  onPressed: _runTestSequence,
                  child: const Text('Run Full Test'),
                ),
                ElevatedButton(
                  onPressed: _clearMessages,
                  child: const Text('Clear Messages'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Messages Display
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Received Messages',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text('Count: ${_messages.length}'),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              _messages[index],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connect() async {
    final success = await _mqttTest.connect();
    setState(() {
      _isConnected = success;
    });
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connected to MQTT broker')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to MQTT broker')),
      );
    }
  }

  Future<void> _disconnect() async {
    await _mqttTest.disconnect();
    setState(() {
      _isConnected = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected from MQTT broker')),
    );
  }

  Future<void> _sendTestMessage() async {
    final success = await _mqttTest.publishTestMessage('Hello from Flutter!');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test message sent')),
      );
    }
  }

  Future<void> _sendScanCommand() async {
    final success = await _mqttTest.sendScanCommand('1234567890123');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scan command sent')),
      );
    }
  }

  Future<void> _sendPaymentCommand() async {
    final success = await _mqttTest.sendPaymentCommand(25.50, 'card');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment command sent')),
      );
    }
  }

  Future<void> _sendAlertCommand() async {
    final success = await _mqttTest.sendAlertCommand('error', 'Test alert message');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert command sent')),
      );
    }
  }

  Future<void> _runTestSequence() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Running full test sequence...')),
    );
    await _mqttTest.runTestSequence();
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
    _mqttTest.clearReceivedMessages();
  }
}
