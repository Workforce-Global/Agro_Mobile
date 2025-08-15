// widgets/settings_dialog.dart
import 'package:flutter/material.dart';
import 'package:agro_sav/services/esp32_client_service.dart';
import 'package:agro_sav/services/crop_analysis_service.dart';

class ESP32SettingsDialog extends StatelessWidget {
  final TextEditingController ipController;
  final TextEditingController streamPortController;
  final TextEditingController controlPortController;
  final TextEditingController streamEndpointController;
  final TextEditingController captureEndpointController;
  final TextEditingController moveEndpointController;
  final TextEditingController positionEndpointController;
  final VoidCallback onSave;

  const ESP32SettingsDialog({
    super.key,
    required this.ipController,
    required this.streamPortController,
    required this.controlPortController,
    required this.streamEndpointController,
    required this.captureEndpointController,
    required this.moveEndpointController,
    required this.positionEndpointController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSettingsField(
                      controller: ipController,
                      label: 'ESP32 IP Address',
                      hint: '192.168.1.100',
                      icon: Icons.wifi,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSettingsField(
                            controller: streamPortController,
                            label: 'Stream Port',
                            hint: '81',
                            icon: Icons.videocam,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildSettingsField(
                            controller: controlPortController,
                            label: 'Control Port',
                            hint: '80',
                            icon: Icons.settings_remote,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildSettingsField(
                      controller: streamEndpointController,
                      label: 'Stream Endpoint',
                      hint: '/stream',
                      icon: Icons.router,
                    ),
                    SizedBox(height: 16),
                    _buildSettingsField(
                      controller: captureEndpointController,
                      label: 'Capture Endpoint',
                      hint: '/capture',
                      icon: Icons.camera_alt,
                    ),
                    SizedBox(height: 16),
                    _buildSettingsField(
                      controller: moveEndpointController,
                      label: 'Move Endpoint',
                      hint: '/move',
                      icon: Icons.open_with,
                    ),
                    SizedBox(height: 16),
                    _buildSettingsField(
                      controller: positionEndpointController,
                      label: 'Position Endpoint',
                      hint: '/position',
                      icon: Icons.my_location,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.settings, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'ESP32 Configuration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              onSave();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}

class AnalysisResultDialog extends StatelessWidget {
  final CropAnalysisResponse result;

  const AnalysisResultDialog({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.analytics, color: Colors.green),
          SizedBox(width: 8),
          Flexible(child: Text('Analysis Result')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow('Model Used:', result.modelUsed),
            SizedBox(height: 8),
            _buildResultRow('Detected:', result.label),
            SizedBox(height: 8),
            _buildResultRow('Confidence:', '${(result.confidence * 100).toStringAsFixed(1)}%'),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getConfidenceColor(result.confidence).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getConfidenceColor(result.confidence)),
              ),
              child: Text(
                _getConfidenceMessage(result.confidence),
                style: TextStyle(
                  color: _getConfidenceColor(result.confidence),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('View History'),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }

  String _getConfidenceMessage(double confidence) {
    if (confidence >= 0.9) return 'High Confidence Detection';
    if (confidence >= 0.7) return 'Moderate Confidence Detection';
    return 'Low Confidence Detection';
  }
}