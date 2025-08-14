// analysis_history_screen.dart
import 'package:flutter/material.dart';
import 'package:agro_sav/services/firestore_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _analysisHistory = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalysisHistory();
    _loadStatistics();
  }

  Future<void> _loadAnalysisHistory() async {
    try {
      final history = await _firestoreService.getUserAnalysisResults();
      setState(() {
        _analysisHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load analysis history'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _firestoreService.getAnalysisStatistics();
      setState(() {
        _statistics = stats;
      });
    } catch (e) {
      print('Failed to load statistics: $e');
    }
  }

  Future<void> _deleteResult(String docId) async {
    try {
      await _firestoreService.deleteAnalysisResult(docId);
      await _loadAnalysisHistory();
      await _loadStatistics();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Result deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete result'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis History'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadAnalysisHistory();
              _loadStatistics();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (_statistics.isNotEmpty) _buildStatisticsCard(),
          Expanded(
            child: _analysisHistory.isEmpty
                ? _buildEmptyState()
                : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final totalAnalyses = _statistics['total_analyses'] ?? 0;
    final averageConfidence = (_statistics['average_confidence'] ?? 0.0) * 100;
    final highConfidencePercentage = _statistics['high_confidence_percentage'] ?? 0.0;
    final detectionCounts = _statistics['detection_counts'] as Map<String, dynamic>? ?? {};

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total\nAnalyses', totalAnalyses.toString(), Icons.analytics),
                _buildStatItem('Avg Confidence', '${averageConfidence.toStringAsFixed(1)}%', Icons.speed),
                _buildStatItem('High Confidence', '${highConfidencePercentage.toStringAsFixed(1)}%', Icons.check_circle),
              ],
            ),
            if (detectionCounts.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Most Detected Issues:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: detectionCounts.entries
                    .take(3)
                    .map((entry) => Chip(
                  label: Text('${entry.key}: ${entry.value}'),
                  backgroundColor: Colors.green.withOpacity(0.1),
                ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Analysis History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Capture and analyze images to see your history here',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _analysisHistory.length,
      itemBuilder: (context, index) {
        final result = _analysisHistory[index];
        return _buildHistoryCard(result);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> result) {
    final label = result['label'] ?? 'Unknown';
    final confidence = ((result['confidence'] ?? 0.0) * 100);
    final modelUsed = result['model_used'] ?? 'Unknown';
    final timestamp = result['timestamp']?.toDate() ?? DateTime.now();
    final docId = result['id'] ?? '';

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - HH:mm').format(timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(docId, label);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    'Confidence',
                    '${confidence.toStringAsFixed(1)}%',
                    _getConfidenceColor(confidence / 100),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    'Model',
                    modelUsed,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }

  void _showDeleteConfirmation(String docId, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Analysis Result'),
        content: Text('Are you sure you want to delete the analysis for "$label"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteResult(docId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}