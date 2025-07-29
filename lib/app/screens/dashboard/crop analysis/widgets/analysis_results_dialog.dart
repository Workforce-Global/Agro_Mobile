// dashboard/crop_analysis/widgets/analysis_results_dialog.dart
import 'package:flutter/material.dart';
import 'result_item.dart';

class AnalysisResultsDialog extends StatelessWidget {
  final String label;
  final double confidence;

  const AnalysisResultsDialog({
    Key? key,
    required this.label,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Analysis Results',
        style: TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResultItem(
            icon: Icons.health_and_safety,
            label: 'Crop Health',
            value: label,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          ResultItem(
            icon: Icons.percent,
            label: 'Confidence',
            value: '${confidence.toStringAsFixed(2)}%',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          ResultItem(
            icon: Icons.lightbulb,
            label: 'Recommendation',
            value: _generateRecommendation(label),
            color: Colors.orange,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _generateRecommendation(String label) {
    switch (label.toLowerCase()) {
      case 'healthy':
        return 'Continue current care';
      case 'infected':
      case 'diseased':
        return 'Apply treatment or consult an expert';
      default:
        return 'Monitor plant regularly';
    }
  }
}
