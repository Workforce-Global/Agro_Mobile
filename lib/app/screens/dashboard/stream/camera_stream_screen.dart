// camera_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agro_sav/services/esp32_client_service.dart';
import 'package:agro_sav/services/crop_analysis_service.dart';
import 'package:agro_sav/services/firestore_service.dart';
import './widgets/camera_overlay_widgets.dart';
import './widgets/camera_stream_widget.dart';
import './widgets/settings_dialog.dart';

class CameraStreamScreen extends StatefulWidget {
  const CameraStreamScreen({super.key});

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
  bool _showCaptureFlash = false;

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
    _requestPermissions();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.photos.request();
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

  Future<void> _captureCurrentFrame() async {
    if (_isCapturing || !_isStreaming) return;

    setState(() {
      _isCapturing = true;
      _isAnalyzing = false;
      _showCaptureFlash = true;
    });

    try {
      final imageData = _esp32Service.captureCurrentFrame();

      if (imageData != null) {
        await _saveImageToGallery(imageData);
        _showCaptureSuccess();

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
        _showCaptureError('No frame available to capture');
      }
    } catch (e) {
      print('Capture error: $e');
      _showCaptureError('Failed to capture frame');
    } finally {
      setState(() {
        _isCapturing = false;
        _isAnalyzing = false;
      });

      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showCaptureFlash = false;
          });
        }
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
      builder: (context) => AnalysisResultDialog(result: result),
    );
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

  // NEW: Save image to gallery (visible to phone's gallery app)
  Future<void> _saveImageToGallery(Uint8List imageData) async {
    try {
      // For Android 10+ (API 29+), save to Pictures directory
      String? externalStoragePath;

      if (Platform.isAndroid) {
        // Try to get the Pictures directory
        final directory = Directory('/storage/emulated/0/Pictures/AgroSav');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        externalStoragePath = directory.path;
      } else if (Platform.isIOS) {
        // For iOS, save to documents directory
        final directory = await getApplicationDocumentsDirectory();
        externalStoragePath = directory.path;
      }

      if (externalStoragePath != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'crop_analysis_$timestamp.jpg';
        final file = File('$externalStoragePath/$fileName');
        await file.writeAsBytes(imageData);

        print('Image saved to: ${file.path}');
      }
    } catch (e) {
      print('Error saving image to gallery: $e');
      // Fallback to app documents directory
      await _saveImage(imageData);
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
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text('Frame captured & saved to gallery!')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCaptureError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onJoystickMove(double position) {
    _esp32Service.setArmPosition(position);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => ESP32SettingsDialog(
        ipController: _ipController,
        streamPortController: _streamPortController,
        controlPortController: _controlPortController,
        streamEndpointController: _streamEndpointController,
        captureEndpointController: _captureEndpointController,
        moveEndpointController: _moveEndpointController,
        positionEndpointController: _positionEndpointController,
        onSave: _saveSettings,
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              // Full-screen camera stream
              CameraStreamWidget(
                cameraStream: _cameraStream,
                isStreaming: _isStreaming,
                showCaptureFlash: _showCaptureFlash,
                isAnalyzing: _isAnalyzing,
              ),

              // Overlay controls based on orientation
              if (orientation == Orientation.portrait)
                _buildPortraitOverlays()
              else
                _buildLandscapeOverlays(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPortraitOverlays() {
    return Stack(
      children: [
        // Top controls
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          right: 20,
          child: TopControlsOverlay(
            isStreaming: _isStreaming,
            onSettingsPressed: _showSettingsDialog,
            onStreamToggle: _isStreaming ? _stopStream : _startStream,
          ),
        ),

        // Compact arm control overlay (directly above shutter button)
        Positioned(
          bottom: 120, // Small space above shutter button
          left: 0,
          right: 0,
          child: CompactArmControlOverlay(
            onMove: _onJoystickMove,
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 20,
          right: 20,
          child: BottomControlsOverlay(
            isStreaming: _isStreaming,
            isCapturing: _isCapturing,
            isAnalyzing: _isAnalyzing,
            onCapture: _captureCurrentFrame,
            onGalleryPressed: () {
              // Navigate to gallery
            },
            onSwitchPressed: () {
              // Switch camera or other function
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeOverlays() {
    return Stack(
      children: [
        // Top center controls
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 0,
          right: 0,
          child: Center(
            child: TopCenterControlsOverlay(
              isStreaming: _isStreaming,
              onSettingsPressed: _showSettingsDialog,
              onStreamToggle: _isStreaming ? _stopStream : _startStream,
            ),
          ),
        ),

        // Right side controls
        Positioned(
          top: 0,
          bottom: 0,
          right: 20,
          child: Center(
            child: RightSideControlsOverlay(
              isStreaming: _isStreaming,
              isCapturing: _isCapturing,
              isAnalyzing: _isAnalyzing,
              onCapture: _captureCurrentFrame,
              onGalleryPressed: () {
                // Navigate to gallery
              },
              onSwitchPressed: () {
                // Switch camera or other function
              },
            ),
          ),
        ),

        // Full-width arm control overlay (bottom center)
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 0,
          right: 0,
          child: FullWidthArmControlOverlay(
            onMove: _onJoystickMove,
          ),
        ),
      ],
    );
  }
}