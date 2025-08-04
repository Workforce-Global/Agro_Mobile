// dashboard/widgets/history_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final String label;
  final double confidence;
  final Timestamp timestamp;
  final VoidCallback? onDelete; // ✅ Optional delete callback

  const HistoryCard({
    super.key,
    required this.label,
    required this.confidence,
    required this.timestamp,
    this.onDelete, // ✅ Accepts delete function
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text('Label: $label'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confidence: ${(confidence * 100).toStringAsFixed(2)}%'),
            Text('Analyzed on: $formattedDate'),
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete, // ✅ Delete action
              )
            : null,
      ),
    );
  }
}
