import 'dart:convert';
import 'dart:io';
import 'package:agro_sav/app/screens/dashboard/crop%20analysis/utils/show_analysis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> analyzeImage({
  required BuildContext context,
  required String modelName,
  required File imageFile,
}) async {
  try {
    // API endpoint
    final uri = Uri.parse('https://agrosaviour-backend-947103695812.europe-west1.run.app/predict/');

    // Prepare multipart request
    final request = http.MultipartRequest('POST', uri)
      ..fields['model_name'] = modelName
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String label = data['label'] ?? 'Unknown';
      final double confidenceDecimal = (data['confidence'] ?? 0.0).toDouble();
      final double confidencePercent = confidenceDecimal * 100;

      // Show result in dialog
      showAnalysisResultsDialog(
        context: context,
        label: label,
        confidence: confidencePercent,
      );

      // Save to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('crop_analysis_results')
            .add({
          'uid': user.uid,
          'label': label,
          'confidence': confidencePercent,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error analyzing image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to analyze image. Please try again.')),
    );
  }
}
