import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../services/mqtt_service.dart';
import '../services/web_api_service.dart';

class ParametersPage extends StatefulWidget {
  const ParametersPage({super.key});

  @override
  State<ParametersPage> createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage> {
  final _formKey = GlobalKey<FormState>();
  final _webApiUrlController = TextEditingController();
  final _terminalNumberController = TextEditingController();
  final _mqttIpController = TextEditingController();
  final _mqttPortController = TextEditingController();
  final _mqttUsernameController = TextEditingController();
  final _mqttPasswordController = TextEditingController();
  final _mqttTopicController = TextEditingController();
  final _mqttTerminalIdController = TextEditingController();
  final _mqttTopicPrefixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    try {
      // Load current settings from services
      final webApiService = Get.find<WebApiService>();
      final mqttService = Get.find<MqttService>();
      final appController = Get.find<AppController>();

      _webApiUrlController.text = webApiService.baseUrl;
      _terminalNumberController.text = appController.terminalId ?? '500';
      _mqttIpController.text = mqttService.brokerHost;
      _mqttPortController.text = mqttService.brokerPort.toString();
      _mqttUsernameController.text = mqttService.username;
      _mqttPasswordController.text = mqttService.password;
      _mqttTopicController.text = mqttService.topic;
      _mqttTerminalIdController.text = mqttService.terminalId;
      _mqttTopicPrefixController.text = mqttService.topicPrefix;
    } catch (e) {
      // Handle case where services are not yet initialized
      print('Error loading current settings: $e');
      // Set default values
      _webApiUrlController.text =
          'http://192.168.2.100:50000/AEFProcess/restaefprocess/aefrun/posService';
      _terminalNumberController.text = '500';
      _mqttIpController.text = '192.168.2.173';
      _mqttPortController.text = '1883';
      _mqttUsernameController.text = 'admin';
      _mqttPasswordController.text = 'admin';
      _mqttTopicController.text = 'ssco/idol/alerts';
      _mqttTerminalIdController.text = '500';
      _mqttTopicPrefixController.text = 'ssco/idol/';
    }
  }

  @override
  void dispose() {
    _webApiUrlController.dispose();
    _terminalNumberController.dispose();
    _mqttIpController.dispose();
    _mqttPortController.dispose();
    _mqttUsernameController.dispose();
    _mqttPasswordController.dispose();
    _mqttTopicController.dispose();
    _mqttTerminalIdController.dispose();
    _mqttTopicPrefixController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Update Web API Service settings
        final webApiService = Get.find<WebApiService>();
        webApiService.updateBaseUrl(_webApiUrlController.text);
        webApiService.updateTerminalId(_terminalNumberController.text);

        // Update App Controller terminal ID
        final appController = Get.find<AppController>();
        appController.updateTerminalId(_terminalNumberController.text);

        // Update MQTT Service settings
        final mqttService = Get.find<MqttService>();

        // Update terminal ID in MQTT service
        mqttService.updateTerminalId(_mqttTerminalIdController.text);

        // Update topic prefix in MQTT service
        mqttService.updateTopicPrefix(_mqttTopicPrefixController.text);

        // Update other MQTT settings
        await mqttService.updateSettings(
          brokerHost: _mqttIpController.text,
          brokerPort: int.tryParse(_mqttPortController.text) ?? 1883,
          username: _mqttUsernameController.text,
          password: _mqttPasswordController.text,
          topic: _mqttTopicController.text,
        );

        // Reconnect MQTT with new settings
        await mqttService.disconnect();
        await mqttService.connect();

        // Show success message
        _showSuccessDialog('Settings saved successfully');

        // Navigate back
        appController.navigateToStart();
      } catch (e) {
        _showErrorDialog('Failed to save settings: $e');
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Parameters'),
        backgroundColor: const Color(0xFFE31E24),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => appController.navigateToStart(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Web API Settings Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.web, color: Color(0xFFE31E24)),
                          const SizedBox(width: 8),
                          Text(
                            'Web API Settings',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE31E24),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _webApiUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Web API URL',
                          hintText: 'https://api.example.com',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.link),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Web API URL';
                          }
                          final uri = Uri.tryParse(value);
                          if (uri == null || !uri.hasAbsolutePath) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _terminalNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Terminal Number',
                          hintText: '500',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.confirmation_number),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter terminal number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // MQTT Settings Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.wifi, color: Color(0xFFE31E24)),
                          const SizedBox(width: 8),
                          Text(
                            'MQTT Settings',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE31E24),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _mqttIpController,
                              decoration: const InputDecoration(
                                labelText: 'MQTT IP Address',
                                hintText: '192.168.1.100',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.computer),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter MQTT IP';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _mqttPortController,
                              decoration: const InputDecoration(
                                labelText: 'Port',
                                hintText: '1883',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Port required';
                                }
                                final port = int.tryParse(value);
                                if (port == null || port < 1 || port > 65535) {
                                  return 'Invalid port';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mqttUsernameController,
                        decoration: const InputDecoration(
                          labelText: 'MQTT Username',
                          hintText: 'username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mqttPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'MQTT Password',
                          hintText: 'password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mqttTopicController,
                        decoration: const InputDecoration(
                          labelText: 'MQTT Topic',
                          hintText: 'ssco/idol/alerts',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.topic),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter MQTT topic';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _mqttTerminalIdController,
                              decoration: const InputDecoration(
                                labelText: 'MQTT Terminal ID',
                                hintText: '500',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.confirmation_number),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter terminal ID';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _mqttTopicPrefixController,
                              decoration: const InputDecoration(
                                labelText: 'MQTT Topic Prefix',
                                hintText: 'ssco/idol/',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.label),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter topic prefix';
                                }
                                if (!value.endsWith('/')) {
                                  return 'Topic prefix should end with /';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loadCurrentSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31E24),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save Settings'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
