import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis History'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // ✅ Listen to the current user's analysis results
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('analysis_results')
            .orderBy('timestamp', descending: true)
            .snapshots(), // 🔄 Enables auto-refresh on any update
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching history.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('No analysis history yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final label = doc['label'];
              final confidence = doc['confidence'];
              final timestamp = doc['timestamp'];
              final docId = doc.id; // ✅ Needed for deletion

              return HistoryCard(
                label: label,
                confidence: confidence,
                timestamp: timestamp,
                onDelete: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('analysis_results')
                      .doc(docId)
                      .delete(); // 🗑️ Delete the specific result
                },
              );
            },
          );
        },
      ),
    );
  }
}
