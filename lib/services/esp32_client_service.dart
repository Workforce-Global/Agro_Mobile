import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ESP32ClientService {
  static const String defaultIP = '192.168.1.100';
  static const int defaultStreamPort = 81;
  static const String defaultStreamEndpoint = '/stream';

  String _esp32IP = defaultIP;
  int _streamPort = defaultStreamPort;
  String _streamEndpoint = defaultStreamEndpoint;

  StreamController<Uint8List>? _streamController;
  bool _isStreaming = false;
  http.Client? _httpClient;

  // Add these for frame capture
  Uint8List? _lastFrame;
  final StreamController<Uint8List> _frameController = StreamController<Uint8List>.broadcast();

  String get esp32IP => _esp32IP;
  int get streamPort => _streamPort;
  String get streamEndpoint => _streamEndpoint;

  // Getter for the last captured frame
  Uint8List? get lastFrame => _lastFrame;

  // Stream for captured frames
  Stream<Uint8List> get frameStream => _frameController.stream;

  void setESP32IP(String ip) {
    _esp32IP = ip;
  }

  void setStreamPort(int port) {
    _streamPort = port;
  }

  void setStreamEndpoint(String endpoint) {
    _streamEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
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
      Uint8List frameData = Uint8List.fromList(imageData);

      // Store the last frame for capture functionality
      _lastFrame = frameData;

      // Emit to both streams
      _streamController?.add(frameData);
      _frameController.add(frameData);

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
    _lastFrame = null;
  }

  // Capture current frame from stream
  Uint8List? captureCurrentFrame() {
    if (!_isStreaming || _lastFrame == null) {
      print('No active stream or no frame available');
      return null;
    }

    // Return a copy of the last frame
    return Uint8List.fromList(_lastFrame!);
  }

  void dispose() {
    stopCameraStream();
    _frameController.close();
  }
}