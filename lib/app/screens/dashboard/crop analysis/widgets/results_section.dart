// dashboard/crop_analysis/widgets/results_section.dart
import 'package:flutter/material.dart';

class ResultsSection extends StatelessWidget {
  final bool isAnalyzing;

  const ResultsSection({Key? key, required this.isAnalyzing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAnalyzing) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
              SizedBox(height: 16),
              Text(
                'Analyzing your crop image...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      child: const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Crop Health: Healthy',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Disease Detection: None detected',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Confidence: 94.2%',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}