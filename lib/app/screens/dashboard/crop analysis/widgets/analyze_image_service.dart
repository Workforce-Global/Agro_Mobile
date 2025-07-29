// lib/app/screens/dashboard/crop_analysis/widgets/analyze_image_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AnalysisResult {
  final String label;
  final double confidence;
  final String modelUsed;

  AnalysisResult({
    required this.label,
    required this.confidence,
    required this.modelUsed,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      modelUsed: json['model_used'],
      label: json['result']['label'],
      confidence: json['result']['confidence'].toDouble(),
    );
  }
}

class AnalyzeImageService {
  static Future<AnalysisResult> analyzeImage({
    required File imageFile,
    required String modelName,
  }) async {
    final uri = Uri.parse('https://agrosaviour-backend-947103695812.europe-west1.run.app/predict/');
    final request = http.MultipartRequest('POST', uri);

    request.fields['model_name'] = modelName;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = json.decode(responseBody);
      return AnalysisResult.fromJson(jsonData);
    } else {
      throw Exception('Failed to analyze image: ${response.statusCode}');
    }
  }
}
