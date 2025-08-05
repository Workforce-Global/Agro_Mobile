// camera_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agro_sav/services/esp32_client_service.dart';
import '\../stream/widgets/joystick_widget.dart';

class CameraStreamScreen extends StatefulWidget {
  @override
  _CameraStreamScreenState createState() => _CameraStreamScreenState();
}

class _CameraStreamScreenState extends State<CameraStreamScreen> {
  final ESP32ClientService _esp32Service = ESP32ClientService();
  Stream<Uint8List>? _cameraStream;
  bool _isStreaming = false;
  bool _isCapturing = false;
  String _esp32IP = ESP32ClientService.defaultIP;
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ipController.text = _esp32IP;
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
      _esp32Service.setESP32IP(_esp32IP);
      setState(() {
        _cameraStream = _esp32Service.startCameraStream();
        _isStreaming = true;
      });
    }
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
    });

    try {
      final imageData = await _esp32Service.captureImage();
      if (imageData != null) {
        await _saveImage(imageData);
        _showCaptureSuccess();
      } else {
        _showCaptureError();
      }
    } catch (e) {
      _showCaptureError();
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
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

  void _showIPDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ESP32 IP Address'),
        content: TextField(
          controller: _ipController,
          decoration: InputDecoration(
            hintText: 'Enter ESP32 IP address',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _esp32IP = _ipController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
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
                      color: _isStreaming
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
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
                        icon: Icon(
                          _isStreaming ? Icons.stop : Icons.play_arrow,
                        ),
                        label: Text(
                          _isStreaming ? 'Stop Stream' : 'Start Stream',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isStreaming
                              ? Colors.red
                              : Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _showIPDialog,
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
                    onPressed: _isStreaming && !_isCapturing
                        ? _captureImage
                        : null,
                    icon: _isCapturing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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
                  JoystickWidget(onMove: _onJoystickMove, size: 120),
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
            Icon(Icons.videocam_off, size: 64, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Camera Stream Disconnected',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Press "Start Stream" to connect',
              style: TextStyle(color: Colors.white38, fontSize: 14),
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
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Stream Error',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Check ESP32 connection',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
