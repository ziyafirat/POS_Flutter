import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
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
                              _isMonitoring ? Icons.visibility : Icons.visibility_off,
                              color: _isMonitoring ? Colors.blue : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_mqttTest.getConnectionStatus()),
                    Text('Messages received: ${_mqttTest.getReceivedMessagesCount()}'),
                    if (_isMonitoring)
                      Text(
                        '🔍 Continuous monitoring active',
                        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
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
                                        onTap: () => _showImageDialog(imageInfo),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
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
                                    style: TextStyle(fontSize: 8, color: Colors.blue),
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
                                items: ['ALL', 'SECURITY', 'COMPLIANCE', 'NOTIFICATION', 'FINANCIAL', 'OPERATION', 'SYSTEM', 'COMMUNICATION', 'GENERAL']
                                    .map((filter) => DropdownMenuItem(
                                          value: filter,
                                          child: Text(filter),
                                        ))
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monitoring stopped')),
      );
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
            content: Text('Continuous monitoring started - listening for all events and alerts'),
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
    return _messages.where((message) => message.contains('[$_selectedFilter]')).toList();
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
              Text('Decode Error', style: TextStyle(fontSize: 10, color: Colors.red)),
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
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                Text('No Image Data', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                    Text('GIF Error', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                    Text('Image Error', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
              Text('Decode Error: $e', style: const TextStyle(fontSize: 16, color: Colors.red)),
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
}
