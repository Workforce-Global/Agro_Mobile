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
}
