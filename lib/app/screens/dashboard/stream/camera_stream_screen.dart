// camera_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agro_sav/services/esp32_client_service.dart';
import 'package:agro_sav/services/crop_analysis_service.dart';
import 'package:agro_sav/services/firestore_service.dart';
import './widgets/joystick_widget.dart';

class CameraStreamScreen extends StatefulWidget {
  @override
  _CameraStreamScreenState createState() => _CameraStreamScreenState();
}

class _CameraStreamScreenState extends State<CameraStreamScreen> {
  final ESP32ClientService _esp32Service = ESP32ClientService();
  final CropAnalysisService _analysisService = CropAnalysisService();
  final FirestoreService _firestoreService = FirestoreService();

  Stream<Uint8List>? _cameraStream;
  bool _isStreaming = false;
  bool _isCapturing = false;
  bool _isAnalyzing = false;

  String _esp32IP = ESP32ClientService.defaultIP;
  int _streamPort = ESP32ClientService.defaultStreamPort;
  int _controlPort = ESP32ClientService.defaultControlPort;
  String _streamEndpoint = ESP32ClientService.defaultStreamEndpoint;
  String _captureEndpoint = ESP32ClientService.defaultCaptureEndpoint;
  String _moveEndpoint = ESP32ClientService.defaultMoveEndpoint;
  String _positionEndpoint = ESP32ClientService.defaultPositionEndpoint;

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _streamPortController = TextEditingController();
  final TextEditingController _controlPortController = TextEditingController();
  final TextEditingController _streamEndpointController = TextEditingController();
  final TextEditingController _captureEndpointController = TextEditingController();
  final TextEditingController _moveEndpointController = TextEditingController();
  final TextEditingController _positionEndpointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _initializeControllers() {
    _ipController.text = _esp32IP;
    _streamPortController.text = _streamPort.toString();
    _controlPortController.text = _controlPort.toString();
    _streamEndpointController.text = _streamEndpoint;
    _captureEndpointController.text = _captureEndpoint;
    _moveEndpointController.text = _moveEndpoint;
    _positionEndpointController.text = _positionEndpoint;
  }

  @override
  void dispose() {
    _esp32Service.dispose();
    // Reset orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _startStream() {
    if (!_isStreaming) {
      _updateESP32Settings();
      setState(() {
        _cameraStream = _esp32Service.startCameraStream();
        _isStreaming = true;
      });
    }
  }

  void _updateESP32Settings() {
    _esp32Service.setESP32IP(_esp32IP);
    _esp32Service.setStreamPort(_streamPort);
    _esp32Service.setControlPort(_controlPort);
    _esp32Service.setStreamEndpoint(_streamEndpoint);
    _esp32Service.setCaptureEndpoint(_captureEndpoint);
    _esp32Service.setMoveEndpoint(_moveEndpoint);
    _esp32Service.setPositionEndpoint(_positionEndpoint);
  }

  void _stopStream() {
    if (_isStreaming) {
      _esp32Service.stopCameraStream();
      setState(() {
        _cameraStream = null;
        _isStreaming = false;
      });
    }
  }

  Future<void> _captureImage() async {
    if (_isCapturing || !_isStreaming) return;

    setState(() {
      _isCapturing = true;
      _isAnalyzing = false;
    });

    try {
      final imageData = await _esp32Service.captureImage();
      if (imageData != null) {
        await _saveImage(imageData);
        _showCaptureSuccess();

        // Start analysis
        setState(() {
          _isAnalyzing = true;
        });

        final analysisResult = await _analysisService.analyzeImage(imageData);

        setState(() {
          _isAnalyzing = false;
        });

        if (analysisResult != null) {
          await _saveAnalysisResult(analysisResult);
          _showAnalysisResult(analysisResult);
        } else {
          _showAnalysisError();
        }
      } else {
        _showCaptureError();
      }
    } catch (e) {
      _showCaptureError();
    } finally {
      setState(() {
        _isCapturing = false;
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _saveAnalysisResult(CropAnalysisResponse result) async {
    try {
      await _firestoreService.saveAnalysisResult(result.toJson());
    } catch (e) {
      print('Failed to save analysis result: $e');
    }
  }

  void _showAnalysisResult(CropAnalysisResponse result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.green),
            SizedBox(width: 8),
            Text('Analysis Result'),
          ],
        ),
        content: Column(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // You could add functionality to view all results here
            },
            child: Text('View History'),
          ),
        ],
      ),
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

  void _showAnalysisError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to analyze image. Please try again.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveImage(Uint8List imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/capture_$timestamp.jpg');
    await file.writeAsBytes(imageData);
  }

  void _showCaptureSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image captured successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCaptureError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to capture image'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onJoystickMove(double position) {
    // Convert joystick position (-1.0 to 1.0) to arm movement
    _esp32Service.setArmPosition(position);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ESP32 Configuration'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: 'ESP32 IP Address',
                  hintText: '192.168.1.100',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wifi),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _streamPortController,
                      decoration: InputDecoration(
                        labelText: 'Stream Port',
                        hintText: '81',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.videocam),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controlPortController,
                      decoration: InputDecoration(
                        labelText: 'Control Port',
                        hintText: '80',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.settings_remote),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _streamEndpointController,
                decoration: InputDecoration(
                  labelText: 'Stream Endpoint',
                  hintText: '/stream',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.router),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _captureEndpointController,
                decoration: InputDecoration(
                  labelText: 'Capture Endpoint',
                  hintText: '/capture',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.camera_alt),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _moveEndpointController,
                decoration: InputDecoration(
                  labelText: 'Move Endpoint',
                  hintText: '/move',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.open_with),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _positionEndpointController,
                decoration: InputDecoration(
                  labelText: 'Position Endpoint',
                  hintText: '/position',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.my_location),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveSettings();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    setState(() {
      _esp32IP = _ipController.text.trim();
      _streamPort = int.tryParse(_streamPortController.text) ?? ESP32ClientService.defaultStreamPort;
      _controlPort = int.tryParse(_controlPortController.text) ?? ESP32ClientService.defaultControlPort;
      _streamEndpoint = _streamEndpointController.text.trim().isEmpty
          ? ESP32ClientService.defaultStreamEndpoint
          : _streamEndpointController.text.trim();
      _captureEndpoint = _captureEndpointController.text.trim().isEmpty
          ? ESP32ClientService.defaultCaptureEndpoint
          : _captureEndpointController.text.trim();
      _moveEndpoint = _moveEndpointController.text.trim().isEmpty
          ? ESP32ClientService.defaultMoveEndpoint
          : _moveEndpointController.text.trim();
      _positionEndpoint = _positionEndpointController.text.trim().isEmpty
          ? ESP32ClientService.defaultPositionEndpoint
          : _positionEndpointController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Row(
          children: [
            // Camera Stream Section
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildCameraStream(),
              ),
            ),

            // Controls Section
            Container(
              width: 200,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Connection Status
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isStreaming ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isStreaming ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      _isStreaming ? 'Connected' : 'Disconnected',
                      style: TextStyle(
                        color: _isStreaming ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Stream Controls
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isStreaming ? _stopStream : _startStream,
                        icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                        label: Text(_isStreaming ? 'Stop Stream' : 'Start Stream'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isStreaming ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _showSettingsDialog,
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                        ),
                      ),
                    ],
                  ),

                  // Capture Button
                  ElevatedButton.icon(
                    onPressed: _isStreaming && !_isCapturing ? _captureImage : null,
                    icon: _isCapturing
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(Icons.camera_alt),
                    label: Text(_isCapturing ? 'Capturing...' : 'Capture'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),

                  // Joystick for Arm Control
                  Text(
                    'Arm Control',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  JoystickWidget(
                    onMove: _onJoystickMove,
                    size: 120,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraStream() {
    if (!_isStreaming || _cameraStream == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off,
              size: 64,
              color: Colors.white54,
            ),
            SizedBox(height: 16),
            Text(
              'Camera Stream Disconnected',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Press "Start Stream" to connect',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<Uint8List>(
      stream: _cameraStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                SizedBox(height: 16),
                Text(
                  'Stream Error',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Check ESP32 connection',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Connecting to camera...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
