// dashboard/widgets/crop_distribution_chart.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CropDistributionChart extends StatelessWidget {
  const CropDistributionChart({Key? key}) : super(key: key);

  final List<CropData> cropData = const [
    CropData(name: 'Cashew', percentage: 40, color: Color(0xFF2E7D32)),
    CropData(name: 'Cassava', percentage: 25, color: Color(0xFF1976D2)),
    CropData(name: 'Tomato', percentage: 20, color: Color(0xFFD32F2F)),
    CropData(name: 'Maize', percentage: 15, color: Color(0xFFFF9800)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crop Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Distribution of all scanned crop types.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: CustomPaint(
                        painter: PieChartPainter(cropData),
                      ),
                    ),
                  ),
                ),
                
                // Legend
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: cropData.map((crop) => _buildLegendItem(crop)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(CropData crop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: crop.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              crop.name,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Text(
            '${crop.percentage}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class CropData {
  final String name;
  final double percentage;
  final Color color;

  const CropData({
    required this.name,
    required this.percentage,
    required this.color,
  });
}

class PieChartPainter extends CustomPainter {
  final List<CropData> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    
    double startAngle = -math.pi / 2; // Start from top

    for (final crop in data) {
      final sweepAngle = 2 * math.pi * (crop.percentage / 100);
      
      final paint = Paint()
        ..color = crop.color
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw inner circle to create donut effect
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.5, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}