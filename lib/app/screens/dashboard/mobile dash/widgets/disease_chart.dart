// dashboard/widgets/disease_chart.dart
import 'package:flutter/material.dart';

class DiseaseChart extends StatelessWidget {
  const DiseaseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Disease Frequency',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'An overview of detected diseases in the last 30 days.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 20),
          // Simple bar chart representation
          SizedBox(
            height: 150,
            child: Column(
              children: [
                _buildDiseaseBar('Leaf Blight', 0.8, const Color(0xFF4CAF50)),
                const SizedBox(height: 8),
                _buildDiseaseBar('Root Rot', 0.6, const Color(0xFF2196F3)),
                const SizedBox(height: 8),
                _buildDiseaseBar('Mosaic Virus', 0.4, const Color(0xFFFF9800)),
                const SizedBox(height: 8),
                _buildDiseaseBar('Bacterial Wilt', 0.3, const Color(0xFFF44336)),
                const SizedBox(height: 8),
                _buildDiseaseBar('Powdery Mildew', 0.2, const Color(0xFF9C27B0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseBar(String disease, double percentage, Color color) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              disease,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF666666),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}