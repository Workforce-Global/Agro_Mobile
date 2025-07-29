// dashboard/widgets/recent_scans_list.dart
import 'package:flutter/material.dart';

class RecentScansList extends StatelessWidget {
  const RecentScansList({super.key});

  final List<Map<String, dynamic>> recentScans = const [
    {
      'id': 'SC001',
      'crop': 'Tomato',
      'status': 'Healthy',
      'date': '2 hours ago',
      'confidence': '94%',
      'statusColor': Color(0xFF4CAF50),
    },
    {
      'id': 'SC002',
      'crop': 'Cassava',
      'status': 'Leaf Blight Detected',
      'date': '4 hours ago',
      'confidence': '87%',
      'statusColor': Color(0xFFF44336),
    },
    {
      'id': 'SC003',
      'crop': 'Maize',
      'status': 'Healthy',
      'date': '6 hours ago',
      'confidence': '91%',
      'statusColor': Color(0xFF4CAF50),
    },
    {
      'id': 'SC004',
      'crop': 'Cashew',
      'status': 'Powdery Mildew',
      'date': '8 hours ago',
      'confidence': '89%',
      'statusColor': Color(0xFFFF9800),
    },
    {
      'id': 'SC005',
      'crop': 'Tomato',
      'status': 'Bacterial Wilt',
      'date': '12 hours ago',
      'confidence': '76%',
      'statusColor': Color(0xFFF44336),
    },
    {
      'id': 'SC006',
      'crop': 'Cassava',
      'status': 'Healthy',
      'date': '1 day ago',
      'confidence': '96%',
      'statusColor': Color(0xFF4CAF50),
    },
  ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Scans',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentScans.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final scan = recentScans[index];
              return _buildScanItem(scan);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScanItem(Map<String, dynamic> scan) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scan['statusColor'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            scan['status'] == 'Healthy' ? Icons.check_circle : Icons.warning,
            color: scan['statusColor'],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${scan['crop']} - ${scan['id']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                scan['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: scan['statusColor'],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              scan['date'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                scan['confidence'],
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}