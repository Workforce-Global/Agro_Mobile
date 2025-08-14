// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save a crop analysis result under the user's document
  Future<void> saveAnalysisResult(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .add({
      'timestamp': FieldValue.serverTimestamp(),
      ...data,
    });
  }

  /// Get all analysis results of the logged-in user
  Future<List<Map<String, dynamic>>> getUserAnalysisResults() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // ✅ Add document ID
      return data;
    }).toList();
  }

  /// Delete a specific result by document ID
  Future<void> deleteAnalysisResult(String docId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .doc(docId)
        .delete();
  }

  /// Get analysis results with real-time updates
  Stream<List<Map<String, dynamic>>> getUserAnalysisResultsStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  /// Update analysis result
  Future<void> updateAnalysisResult(String docId,
      Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .doc(docId)
        .update(data);
  }

  /// Get analysis statistics
  Future<Map<String, dynamic>> getAnalysisStatistics() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return {};

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('analysis_results')
        .get();

    final results = snapshot.docs.map((doc) => doc.data()).toList();

    // Calculate statistics
    final totalAnalyses = results.length;
    final Map<String, int> detectionCounts = {};
    double averageConfidence = 0.0;
    int highConfidenceCount = 0;

    for (final result in results) {
      final label = result['label'] as String? ?? 'Unknown';
      final confidence = (result['confidence'] as num?)?.toDouble() ?? 0.0;

      detectionCounts[label] = (detectionCounts[label] ?? 0) + 1;
      averageConfidence += confidence;

      if (confidence >= 0.9) {
        highConfidenceCount++;
      }
    }

    if (totalAnalyses > 0) {
      averageConfidence /= totalAnalyses;
    }

    return {
      'total_analyses': totalAnalyses,
      'detection_counts': detectionCounts,
      'average_confidence': averageConfidence,
      'high_confidence_count': highConfidenceCount,
      'high_confidence_percentage': totalAnalyses > 0 ? (highConfidenceCount /
          totalAnalyses) * 100 : 0.0,
    };
  }
}