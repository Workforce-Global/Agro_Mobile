// crop_analysis_service.dart
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropAnalysisResponse {
  final String modelUsed;
  final int predictedClass;
  final String label;
  final double confidence;

  CropAnalysisResponse({
    required this.modelUsed,
    required this.predictedClass,
    required this.label,
    required this.confidence,
  });

  factory CropAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return CropAnalysisResponse(
      modelUsed: json['model_used'] ?? '',
      predictedClass: json['result']['predicted_class'] ?? 0,
      label: json['result']['label'] ?? '',
      confidence: (json['result']['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_used': modelUsed,
      'predicted_class': predictedClass,
      'label': label,
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

class CropAnalysisService {
  static const String _baseUrl = 'https://agrosaviour-backend-947103695812.europe-west1.run.app';
  static const String _predictEndpoint = '/predict/';
  static const String _modelName = 'efficientnet';

  Future<CropAnalysisResponse?> analyzeImage(Uint8List imageData) async {
    try {
      final uri = Uri.parse('$_baseUrl$_predictEndpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageData,
          filename: 'capture_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      // Add the model name
      request.fields['model_name'] = _modelName;

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CropAnalysisResponse.fromJson(jsonResponse);
      } else {
        print('Analysis API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Analysis error: $e');
      return null;
    }
  }
}