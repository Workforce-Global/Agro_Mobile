import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ESP32ClientService {
  static const String defaultIP = '192.168.1.100'; // Change to your ESP32 IP
  static const int defaultStreamPort = 81;
  static const int defaultControlPort = 80;
  static const String defaultStreamEndpoint = '/stream';
  static const String defaultCaptureEndpoint = '/capture';
  static const String defaultMoveEndpoint = '/move';
  static const String defaultPositionEndpoint = '/position';

  String _esp32IP = defaultIP;
  int _streamPort = defaultStreamPort;
  int _controlPort = defaultControlPort;
  String _streamEndpoint = defaultStreamEndpoint;
  String _captureEndpoint = defaultCaptureEndpoint;
  String _moveEndpoint = defaultMoveEndpoint;
  String _positionEndpoint = defaultPositionEndpoint;

  StreamController<Uint8List>? _streamController;
  bool _isStreaming = false;
  http.Client? _httpClient;

  String get esp32IP => _esp32IP;
  int get streamPort => _streamPort;
  int get controlPort => _controlPort;
  String get streamEndpoint => _streamEndpoint;
  String get captureEndpoint => _captureEndpoint;
  String get moveEndpoint => _moveEndpoint;
  String get positionEndpoint => _positionEndpoint;

  void setESP32IP(String ip) {
    _esp32IP = ip;
  }

  void setStreamPort(int port) {
    _streamPort = port;
  }

  void setControlPort(int port) {
    _controlPort = port;
  }

  void setStreamEndpoint(String endpoint) {
    _streamEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  void setCaptureEndpoint(String endpoint) {
    _captureEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  void setMoveEndpoint(String endpoint) {
    _moveEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  void setPositionEndpoint(String endpoint) {
    _positionEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  // Start camera stream
  Stream<Uint8List> startCameraStream() {
    if (_isStreaming) {
      return _streamController!.stream;
    }

    _streamController = StreamController<Uint8List>.broadcast();
    _isStreaming = true;
    _httpClient = http.Client();

    _startStreamingProcess();
    return _streamController!.stream;
  }

  void _startStreamingProcess() async {
    try {
      final streamUrl = 'http://$_esp32IP:$_streamPort$_streamEndpoint';
      final request = http.Request('GET', Uri.parse(streamUrl));
      final response = await _httpClient!.send(request);

      if (response.statusCode == 200) {
        await for (var chunk in response.stream) {
          if (!_isStreaming) break;

          // Process MJPEG stream - look for JPEG boundaries
          _processStreamChunk(chunk);
        }
      }
    } catch (e) {
      print('Stream error: $e');
      _streamController?.addError('Failed to connect to ESP32 camera stream');
    }
  }

  List<int> _buffer = [];
  static final List<int> jpegStart = [0xFF, 0xD8];
  static final List<int> jpegEnd = [0xFF, 0xD9];

  void _processStreamChunk(List<int> chunk) {
    _buffer.addAll(chunk);

    while (true) {
      int startIndex = _findPattern(_buffer, jpegStart);
      if (startIndex == -1) break;

      int endIndex = _findPattern(_buffer, jpegEnd, startIndex + 2);
      if (endIndex == -1) break;

      // Extract complete JPEG image
      List<int> imageData = _buffer.sublist(startIndex, endIndex + 2);
      _streamController?.add(Uint8List.fromList(imageData));

      // Remove processed data from buffer
      _buffer = _buffer.sublist(endIndex + 2);
    }
  }

  int _findPattern(List<int> data, List<int> pattern, [int startFrom = 0]) {
    for (int i = startFrom; i <= data.length - pattern.length; i++) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (data[i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  // Stop camera stream
  void stopCameraStream() {
    _isStreaming = false;
    _streamController?.close();
    _streamController = null;
    _httpClient?.close();
    _httpClient = null;
    _buffer.clear();
  }

  // Capture current frame (this would be called when capture button is pressed)
  Future<Uint8List?> captureImage() async {
    try {
      final captureUrl = 'http://$_esp32IP:$_controlPort$_captureEndpoint';
      final response = await http.get(Uri.parse(captureUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Capture error: $e');
    }
    return null;
  }

  // Control robotic arm movement
  Future<bool> moveArm(String direction) async {
    try {
      final controlUrl = 'http://$_esp32IP:$_controlPort$_moveEndpoint';
      final response = await http.post(
        Uri.parse(controlUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"direction": "$direction"}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Arm control error: $e');
      return false;
    }
  }

  // Send continuous movement commands (for joystick)
  Future<bool> setArmPosition(double position) async {
    try {
      final controlUrl = 'http://$_esp32IP:$_controlPort$_positionEndpoint';
      final response = await http.post(
        Uri.parse(controlUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"position": $position}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Arm position error: $e');
      return false;
    }
  }

  void dispose() {
    stopCameraStream();
  }
}
