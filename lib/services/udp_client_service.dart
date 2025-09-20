// services/udp_client_service.dart
import 'dart:io';
import 'dart:convert';

class UDPClientService {
  static const int defaultUDPPort = 8888; // ESP32 will listen on this port

  RawDatagramSocket? _socket;
  String _esp32IP = '192.168.1.100';
  int _udpPort = defaultUDPPort;
  bool _isConnected = false;

  String get esp32IP => _esp32IP;
  int get udpPort => _udpPort;
  bool get isConnected => _isConnected;

  void setESP32IP(String ip) {
    _esp32IP = ip;
  }

  void setUDPPort(int port) {
    _udpPort = port;
  }

  // Initialize UDP socket
  Future<bool> initializeUDP() async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _isConnected = true;
      print('UDP Client initialized on local port: ${_socket!.port}');
      return true;
    } catch (e) {
      print('Failed to initialize UDP socket: $e');
      _isConnected = false;
      return false;
    }
  }

  // Send direction command to ESP32
  Future<bool> sendDirectionCommand(String direction) async {
    if (!_isConnected || _socket == null) {
      print('UDP socket not initialized');
      return false;
    }

    try {
      // Create command JSON
      final command = {
        'command': 'move',
        'direction': direction,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Convert to JSON string
      final jsonString = json.encode(command);
      final data = utf8.encode(jsonString);

      // Send UDP packet to ESP32
      final targetAddress = InternetAddress(_esp32IP);
      final bytesSent = _socket!.send(data, targetAddress, _udpPort);

      if (bytesSent > 0) {
        print('Sent command to $_esp32IP:$_udpPort - $direction');
        return true;
      } else {
        print('Failed to send UDP packet');
        return false;
      }
    } catch (e) {
      print('Error sending UDP command: $e');
      return false;
    }
  }

  // Send stop command (convenience method)
  Future<bool> sendStopCommand() async {
    return await sendDirectionCommand('Stop');
  }

  // Test connection to ESP32
  Future<bool> testConnection() async {
    if (!_isConnected) {
      await initializeUDP();
    }

    try {
      // Send a ping command
      final pingCommand = {
        'command': 'ping',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final jsonString = json.encode(pingCommand);
      final data = utf8.encode(jsonString);
      final targetAddress = InternetAddress(_esp32IP);
      final bytesSent = _socket!.send(data, targetAddress, _udpPort);

      return bytesSent > 0;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Close UDP socket
  void dispose() {
    _socket?.close();
    _socket = null;
    _isConnected = false;
    print('UDP Client disposed');
  }
}