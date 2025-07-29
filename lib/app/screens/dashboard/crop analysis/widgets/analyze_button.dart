// dashboard/crop_analysis/widgets/analyze_button.dart
import 'package:flutter/material.dart';

class AnalyzeButton extends StatelessWidget {
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final bool isEnabled;

  const AnalyzeButton({
    Key? key,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      child: ElevatedButton(
        onPressed: isEnabled && !isAnalyzing ? onAnalyze : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: isAnalyzing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Analyzing Crop...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : const Text(
                'Analyze Crop',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}