import 'package:flutter/material.dart';
import '../widgets/analysis_results_dialog.dart';

void showAnalysisResultsDialog({
  required BuildContext context,
  required String label,
  required double confidence, // Expected as percentage
}) {
  showDialog(
    context: context,
    builder: (_) => AnalysisResultsDialog(
      label: label,
      confidence: confidence,
    ),
  );
}
