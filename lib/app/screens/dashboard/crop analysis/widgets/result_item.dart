// lib/app/screens/dashboard/crop_analysis/widgets/result_item.dart
import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const ResultItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value),
          ],
        ),
      ],
    );
  }
}
