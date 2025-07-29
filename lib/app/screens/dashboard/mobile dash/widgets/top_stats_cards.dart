// dashboard/widgets/top_stats_cards.dart
import 'package:flutter/material.dart';

class TopStatsCards extends StatelessWidget {
  const TopStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Scans',
                value: '1,254',
                subtitle: '+20.1% from last month',
                icon: Icons.trending_up,
                iconColor: const Color(0xFF4CAF50),
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Crops Identified',
                value: '4',
                subtitle: 'Cashew, cassava, tomato, and maize.',
                icon: Icons.refresh,
                iconColor: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Diseases Detected',
                value: '89',
                subtitle: '+12 from last month',
                icon: Icons.auto_fix_high,
                iconColor: const Color(0xFFFF9800),
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Healthy Yields',
                value: '92%',
                subtitle: 'Trending upwards',
                icon: Icons.timeline,
                iconColor: const Color(0xFF4CAF50),
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    bool isPositive = false,
  }) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFF666666),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}