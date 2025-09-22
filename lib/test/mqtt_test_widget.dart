import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'mqtt_test.dart';
import 'scanner_test.dart';
import 'popup_test.dart';
import '../controllers/app_controller.dart';
import '../services/web_api_service.dart';

/// Simple Widget to test MQTT functionality
class MqttTestWidget extends StatefulWidget {
  const MqttTestWidget({super.key});

  @override
  State<MqttTestWidget> createState() => _MqttTestWidgetState();
}

class _MqttTestWidgetState extends State<MqttTestWidget> {
  final MqttTest _mqttTest = MqttTest();
  List<String> _messages = [];
  List<Map<String, dynamic>> _imageData = [];
  bool _isConnected = false;
  bool _isMonitoring = false;
  Map<String, int> _eventStats = {};
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _setupMqttListener();
  }

  void _setupMqttListener() {
    _mqttTest.messageStream.listen((message) {
      setState(() {
        _messages.add(message);
        _eventStats = _mqttTest.getEventStatistics();

        // Get all image data from raw messages
        _imageData = _mqttTest.getAllImageData();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Connection Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            Icon(
                              _isConnected ? Icons.wifi : Icons.wifi_off,
                              color: _isConnected ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _isMonitoring
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: _isMonitoring ? Colors.blue : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_mqttTest.getConnectionStatus()),
                    Text(
                      'Messages received: ${_mqttTest.getReceivedMessagesCount()}',
                    ),
                    if (_isMonitoring)
                      Text(
                        '🔍 Continuous monitoring active',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Event Statistics
            if (_eventStats.isNotEmpty)
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Statistics',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _eventStats.entries.map((entry) {
                          return Chip(
                            label: Text('${entry.key}: ${entry.value}'),
                            backgroundColor: _getCategoryColor(entry.key),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Image Display Section
            if (_imageData.isNotEmpty)
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fraud Alert Images (${_imageData.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageData.length,
                          itemBuilder: (context, index) {
                            final imageInfo = _imageData[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Column(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _showImageDialog(imageInfo),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: _buildImageWidget(imageInfo),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${imageInfo['mime']}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Tap to view',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
                ElevatedButton.icon(
                  onPressed: _connect,
                  icon: const Icon(Icons.wifi),
                  label: const Text('Connect'),
                ),
                ElevatedButton.icon(
                  onPressed: _disconnect,
                  icon: const Icon(Icons.wifi_off),
                  label: const Text('Disconnect'),
                ),
                ElevatedButton.icon(
                  onPressed: _startMonitoring,
                  icon: Icon(_isMonitoring ? Icons.stop : Icons.play_arrow),
                  label: Text(_isMonitoring ? 'Stop Monitor' : 'Start Monitor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isMonitoring ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _sendTestMessage,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Test'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendScanCommand,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Send Scan'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendPaymentCommand,
                  icon: const Icon(Icons.payment),
                  label: const Text('Send Payment'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendAlertCommand,
                  icon: const Icon(Icons.warning),
                  label: const Text('Send Alert'),
                ),
                ElevatedButton.icon(
                  onPressed: _runTestSequence,
                  icon: const Icon(Icons.play_circle),
                  label: const Text('Run Full Test'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearMessages,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Messages'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearImages,
                  icon: const Icon(Icons.image_not_supported),
                  label: const Text('Clear Images'),
                ),
                ElevatedButton.icon(
                  onPressed: _runScannerTests,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Test Scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _testPopupFlow,
                  icon: const Icon(Icons.layers),
                  label: const Text('Test Popups'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _testTerminalClosed,
                  icon: const Icon(Icons.lock),
                  label: const Text('Test Terminal Closed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _testSpecialBarcode,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Test Special Barcode'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testStartupWith1010,
                  icon: const Icon(Icons.rocket_launch),
                  label: const Text('Test Startup 1010'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testSubstate1008,
                  icon: const Icon(Icons.close_fullscreen),
                  label: const Text('Test 1008 Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testPrintingFlow,
                  icon: const Icon(Icons.print),
                  label: const Text('Test Print Flow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testMqttEvents,
                  icon: const Icon(Icons.wifi),
                  label: const Text('Test MQTT Events'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testScanningSession,
                  icon: const Icon(Icons.lock),
                  label: const Text('Test Scan Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            // Second row of test buttons
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _testProcessingFlow,
                  icon: const Icon(Icons.sync),
                  label: const Text('Test Processing Flow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testPersistentPages,
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Test Persistent Pages'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testCurrencyFormat,
                  icon: const Icon(Icons.attach_money),
                  label: const Text('Test Currency Format'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testMqttReliability,
                  icon: const Icon(Icons.wifi_protected_setup),
                  label: const Text('Test MQTT Reliability'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testAssistanceLamp,
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('Test Assistance & Lamp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testListViewPerformance,
                  icon: const Icon(Icons.speed),
                  label: const Text('Test ListView Speed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testPopupConsistency,
                  icon: const Icon(Icons.aspect_ratio),
                  label: const Text('Test Popup Sizes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Row 5: POS and Navigation Tests
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _testPosCashierStability,
                  icon: const Icon(Icons.lock),
                  label: const Text('Test POS Stability'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testGrayBackgrounds,
                  icon: const Icon(Icons.palette),
                  label: const Text('Test Gray Backgrounds'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testPosButtonLayout,
                  icon: const Icon(Icons.grid_view),
                  label: const Text('Test POS Layout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Row 6: Start Page and Transaction Tests
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _testStartPageStay,
                  icon: const Icon(Icons.home),
                  label: const Text('Test Start Page Stay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testFraudAlertFeatures,
                  icon: const Icon(Icons.security),
                  label: const Text('Test Fraud Features'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Event Test Buttons
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Testing',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _testCheckoutStart,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Checkout Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testCheckoutEnd,
                          icon: const Icon(Icons.stop),
                          label: const Text('Checkout End'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testFraudAlert,
                          icon: const Icon(Icons.warning),
                          label: const Text('Fraud Alert'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testFraudAlertFeedback,
                          icon: const Icon(Icons.feedback),
                          label: const Text('Fraud Feedback'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testItemScan,
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Item Scan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testItemInfo,
                          icon: const Icon(Icons.info),
                          label: const Text('Item Info'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                            'Received Events & Alerts',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              Text('Count: ${_messages.length}'),
                              const SizedBox(width: 16),
                              DropdownButton<String>(
                                value: _selectedFilter,
                                items:
                                    [
                                          'ALL',
                                          'SECURITY',
                                          'COMPLIANCE',
                                          'NOTIFICATION',
                                          'FINANCIAL',
                                          'OPERATION',
                                          'SYSTEM',
                                          'COMMUNICATION',
                                          'GENERAL',
                                        ]
                                        .map(
                                          (filter) => DropdownMenuItem(
                                            value: filter,
                                            child: Text(filter),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFilter = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _getFilteredMessages().length,
                        itemBuilder: (context, index) {
                          final message = _getFilteredMessages()[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: _getMessageBackgroundColor(message),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getMessageBorderColor(message),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Connected to MQTT broker')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Test message sent')));
    }
  }

  Future<void> _sendScanCommand() async {
    final success = await _mqttTest.sendScanCommand('1234567890123');
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Scan command sent')));
    }
  }

  Future<void> _sendPaymentCommand() async {
    final success = await _mqttTest.sendPaymentCommand(25.50, 'card');
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment command sent')));
    }
  }

  Future<void> _sendAlertCommand() async {
    final success = await _mqttTest.sendAlertCommand(
      'error',
      'Test alert message',
    );
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Alert command sent')));
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
      _eventStats.clear();
    });
    _mqttTest.clearReceivedMessages();
  }

  void _clearImages() {
    setState(() {
      _imageData.clear();
    });
  }

  Future<void> _startMonitoring() async {
    if (_isMonitoring) {
      // Stop monitoring
      await _mqttTest.disconnect();
      setState(() {
        _isMonitoring = false;
        _isConnected = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Monitoring stopped')));
    } else {
      // Start monitoring
      final success = await _mqttTest.startContinuousMonitoring();
      setState(() {
        _isMonitoring = success;
        _isConnected = success;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Continuous monitoring started - listening for all events and alerts',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start monitoring'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _getFilteredMessages() {
    if (_selectedFilter == 'ALL') {
      return _messages;
    }
    return _messages
        .where((message) => message.contains('[$_selectedFilter]'))
        .toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'SECURITY':
        return Colors.red[100]!;
      case 'COMPLIANCE':
        return Colors.orange[100]!;
      case 'NOTIFICATION':
        return Colors.yellow[100]!;
      case 'FINANCIAL':
        return Colors.green[100]!;
      case 'OPERATION':
        return Colors.blue[100]!;
      case 'SYSTEM':
        return Colors.purple[100]!;
      case 'COMMUNICATION':
        return Colors.cyan[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getMessageBackgroundColor(String message) {
    if (message.contains('[SECURITY]')) {
      return Colors.red[50]!;
    } else if (message.contains('[COMPLIANCE]')) {
      return Colors.orange[50]!;
    } else if (message.contains('[NOTIFICATION]')) {
      return Colors.yellow[50]!;
    } else if (message.contains('[FINANCIAL]')) {
      return Colors.green[50]!;
    } else if (message.contains('[OPERATION]')) {
      return Colors.blue[50]!;
    } else if (message.contains('[SYSTEM]')) {
      return Colors.purple[50]!;
    } else if (message.contains('[COMMUNICATION]')) {
      return Colors.cyan[50]!;
    } else {
      return Colors.grey[50]!;
    }
  }

  Color _getMessageBorderColor(String message) {
    if (message.contains('[SECURITY]')) {
      return Colors.red[200]!;
    } else if (message.contains('[COMPLIANCE]')) {
      return Colors.orange[200]!;
    } else if (message.contains('[NOTIFICATION]')) {
      return Colors.yellow[200]!;
    } else if (message.contains('[FINANCIAL]')) {
      return Colors.green[200]!;
    } else if (message.contains('[OPERATION]')) {
      return Colors.blue[200]!;
    } else if (message.contains('[SYSTEM]')) {
      return Colors.purple[200]!;
    } else if (message.contains('[COMMUNICATION]')) {
      return Colors.cyan[200]!;
    } else {
      return Colors.grey[200]!;
    }
  }

  Widget _buildImageWidget(Map<String, dynamic> imageInfo) {
    try {
      final mimeType = imageInfo['mime'] as String?;
      final dataString = imageInfo['data'] as String?;

      if (dataString == null || dataString.isEmpty) {
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        );
      }

      // Decode base64 data
      final bytes = base64Decode(dataString);

      if (mimeType == 'image/gif') {
        // For GIF images, we'll display them as regular images
        // Note: Flutter doesn't natively support animated GIFs in Image.memory
        // You might want to use a package like 'flutter_gif' for animated GIFs
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 30, color: Colors.grey),
                    Text('GIF Error', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // For other image types (PNG, JPEG, etc.)
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 30, color: Colors.grey),
                    Text('Image Error', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 30, color: Colors.red),
              Text(
                'Decode Error',
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Event Test Methods
  Future<void> _testCheckoutStart() async {
    final success = await _mqttTest.sendCheckoutStart();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout Start event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Checkout Start event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testCheckoutEnd() async {
    final success = await _mqttTest.sendCheckoutEnd();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout End event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Checkout End event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testFraudAlert() async {
    final success = await _mqttTest.sendFraudAlert();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fraud Alert event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Fraud Alert event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testFraudAlertFeedback() async {
    final success = await _mqttTest.sendFraudAlertFeedback(
      alertId: 'TEST_ALERT_${DateTime.now().millisecondsSinceEpoch}',
      feedbackType: MqttFeedbackType.willRescan,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fraud Alert Feedback event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Fraud Alert Feedback event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testItemScan() async {
    final success = await _mqttTest.sendItemScan(
      scanType: MqttScanType.product,
      barcode: 'TEST_BARCODE_${DateTime.now().millisecondsSinceEpoch}',
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item Scan event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Item Scan event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testItemInfo() async {
    final success = await _mqttTest.sendItemInfo(
      scanType: MqttScanType.product,
      itemData: {
        'name': 'Test Product ${DateTime.now().millisecondsSinceEpoch}',
        'price': 12.99,
        'category': 'groceries',
        'barcode': 'TEST_BARCODE_${DateTime.now().millisecondsSinceEpoch}',
        'description': 'Test item for MQTT event testing',
      },
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item Info event sent'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send Item Info event'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageDialog(Map<String, dynamic> imageInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fraud Alert Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Type: ${imageInfo['mime']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Image Display
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildLargeImageWidget(imageInfo),
                    ),
                  ),
                ),

                // Footer with actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _saveImage(imageInfo);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Save Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLargeImageWidget(Map<String, dynamic> imageInfo) {
    try {
      final mimeType = imageInfo['mime'] as String?;
      final dataString = imageInfo['data'] as String?;

      if (dataString == null || dataString.isEmpty) {
        return Container(
          width: 400,
          height: 400,
          color: Colors.grey[200],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Image Data',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      // Decode base64 data
      final bytes = base64Decode(dataString);

      if (mimeType == 'image/gif') {
        // For GIF images, display them as regular images
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 400,
              height: 400,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'GIF Error',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // For other image types (PNG, JPEG, etc.)
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 400,
              height: 400,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Image Error',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      return Container(
        width: 400,
        height: 400,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Decode Error: $e',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _saveImage(Map<String, dynamic> imageInfo) {
    // For now, just show a message. In a real app, you'd implement actual file saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image save functionality would be implemented here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _runScannerTests() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Running comprehensive scanner tests...'),
          backgroundColor: Colors.deepPurple,
        ),
      );

      // Run the scanner tests
      ScannerTest.runTests();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Scanner tests completed! Check console for detailed results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanner test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testPopupFlow() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing popup flow with item scan background...'),
          backgroundColor: Colors.teal,
        ),
      );

      // Run the popup tests
      await PopupTest.testPopupFlow();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Popup tests completed! Check console for detailed results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Popup test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testTerminalClosed() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing terminal closed functionality...'),
          backgroundColor: Colors.orange,
        ),
      );

      // Run the terminal closed tests
      await PopupTest.testTerminalClosed();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terminal closed tests completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terminal closed test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testSpecialBarcode() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing special barcode 1111111111116...'),
          backgroundColor: Colors.indigo,
        ),
      );

      // Run the special barcode tests
      await PopupTest.testSpecialBarcode();
      await PopupTest.testPosOverrideMode();
      await PopupTest.testSubstatePopupFlow();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Special barcode tests completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Special barcode test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testStartupWith1010() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing startup with substate 1010...'),
          backgroundColor: Colors.purple,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testStartupWith1010();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Startup 1010 test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Startup 1010 test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testSubstate1008() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing substate 1008 popup closing...'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testSubstate1008PopupClosing();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Substate 1008 test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Substate 1008 test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testPrintingFlow() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing 1010 → 1002 printing popup flow...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testPrintingPopupFlow();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Printing flow test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Printing flow test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testMqttEvents() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing MQTT checkout events...'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testMqttCheckoutEvents();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'MQTT events test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('MQTT events test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testScanningSession() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing user scanning session behavior...'),
          backgroundColor: Colors.deepOrange,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testUserScanningSession();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Scanning session test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanning session test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testProcessingFlow() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing 1010 → 1002 → 1008 processing flow...'),
          backgroundColor: Colors.brown,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testProcessingPopupFlow();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Processing flow test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Processing flow test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testPersistentPages() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing persistent pages behavior...'),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testPersistentPages();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Persistent pages test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Persistent pages test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testCurrencyFormat() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing currency formatting...'),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testCurrencyFormatting();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Currency formatting test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Currency formatting test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testMqttReliability() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing MQTT connection reliability...'),
          backgroundColor: Colors.cyan,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testMqttConnectionReliability();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'MQTT reliability test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('MQTT reliability test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testAssistanceLamp() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing assistance call and lamp control...'),
          backgroundColor: Colors.deepPurple,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testAssistanceAndLampControl();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Assistance & lamp test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assistance & lamp test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testListViewPerformance() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing ListView update performance...'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testListViewPerformance();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ListView performance test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ListView performance test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testPopupConsistency() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing popup size consistency...'),
          backgroundColor: Colors.indigo,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testPopupSizeConsistency();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Popup consistency test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Popup consistency test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testPosCashierStability() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing POS Cashier screen stability...'),
          backgroundColor: Colors.brown,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testPosCashierStability();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'POS Cashier stability test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('POS Cashier stability test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testGrayBackgrounds() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing gray background consistency...'),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testGrayBackgrounds();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gray background test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gray background test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testPosButtonLayout() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing POS Cashier button layout...'),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testPosButtonLayout();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'POS button layout test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('POS button layout test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testStartPageStay() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing start page stay behavior...'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testStartPageStayBehavior();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Start page stay test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Start page stay test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _testFraudAlertFeatures() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Testing fraud alert features...'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      await PopupTest.testFraudAlertFeatures();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fraud alert features test completed! Check console for results.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fraud alert features test failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _testMposTxnEndPrevention() {
    try {
      final webApiService = Get.find<WebApiService>();

      // Show current flag status
      final currentStatus = webApiService.mposTxnEndPresent;
      print('🧪 [TEST] Current MPOS TXN END flag: $currentStatus');

      // Create test receipt with MPOS TXN END
      const testReceipt = '''
=== TEST RECEIPT ===
Date: 2024-01-01 12:00:00
Store: Almaya Supermarket
Terminal: SCO-500

Item 1: Test Product - 10.00 AED
Item 2: Another Product - 5.50 AED

Total: 15.50 AED
Payment: CASH

MPOS TXN END
Thank you for shopping!
''';

      // Simulate receipt processing multiple times
      print('🧪 [TEST] Simulating first MPOS TXN END receipt...');
      webApiService.testProcessReceipt(testReceipt);

      // Wait a moment then try again
      Future.delayed(const Duration(seconds: 1), () {
        print(
          '🧪 [TEST] Simulating second MPOS TXN END receipt (should be ignored)...',
        );
        webApiService.testProcessReceipt(testReceipt);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'MPOS TXN END duplicate prevention test started! Check console.',
          ),
          backgroundColor: Colors.indigo,
        ),
      );
    } catch (e) {
      print('❌ [TEST] Error testing MPOS TXN END prevention: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('MPOS test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetMposTxnEndFlag() {
    try {
      final webApiService = Get.find<WebApiService>();
      webApiService.resetMposTxnEndFlag();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('MPOS TXN END flag reset successfully!'),
          backgroundColor: Colors.teal,
        ),
      );
    } catch (e) {
      print('❌ [TEST] Error resetting MPOS flag: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _testCheckoutEventCycle() {
    try {
      final controller = Get.find<AppController>();
      controller.testCheckoutEventCycle();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Checkout event cycle test started! Check console for sequence.',
          ),
          backgroundColor: Colors.cyan,
        ),
      );
    } catch (e) {
      print('❌ [TEST] Error testing checkout event cycle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout cycle test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCheckoutEventFlags() {
    try {
      final controller = Get.find<AppController>();
      final flags = controller.getCheckoutEventFlagStatus();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Checkout Event Flags'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Can Send Checkout Start: ${flags['canSendCheckoutStart']}'),
              const SizedBox(height: 8),
              Text('Can Send Checkout End: ${flags['canSendCheckoutEnd']}'),
              const SizedBox(height: 16),
              const Text(
                'Logic:\n• Start=true, End=false: Ready for new transaction\n• Start=false, End=true: Transaction started, ready for end\n• Both false: Invalid state',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );

      print('🔍 [TEST] Current checkout event flags: $flags');
    } catch (e) {
      print('❌ [TEST] Error showing checkout flags: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to show flags: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetCheckoutEventFlags() {
    try {
      final controller = Get.find<AppController>();
      controller.resetCheckoutEventFlags();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout event flags reset to initial state!'),
          backgroundColor: Colors.amber,
        ),
      );
    } catch (e) {
      print('❌ [TEST] Error resetting checkout flags: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
