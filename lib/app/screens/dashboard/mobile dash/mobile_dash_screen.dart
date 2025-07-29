// dashboard/mobile_dashboard_screen.dart
import 'package:agro_sav/app/screens/dashboard/widgets/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'widgets/disease_chart.dart';
import 'widgets/crop_distribution_chart.dart';
import 'widgets/recent_scans_list.dart';

class MobileDashboardScreen extends StatelessWidget {
  const MobileDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF2E7D32)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'AgroSaviour',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined),
            onPressed: () {},
            color: Colors.grey[600],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Sidebar(
          isCollapsed: false,
          currentPage: 'dashboard',
          onToggle: () {},
          onPageChanged: (String page) {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Cards (Mobile Layout - 2x2 Grid)
            const MobileStatsCards(),
            
            const SizedBox(height: 24),
            
            // Disease Chart
            SizedBox(
              height: 350,
              child: const DiseaseChart(),
            ),
            
            const SizedBox(height: 16),
            
            // Crop Distribution Chart
            SizedBox(
              height: 350,
              child: const CropDistributionChart(),
            ),
            
            const SizedBox(height: 16),
            
            // Recent Scans
            const RecentScansList(),
          ],
        ),
      ),
    );
  }
}

class MobileStatsCards extends StatelessWidget {
  const MobileStatsCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Total Scans',
                value: '1,254',
                change: '+20.1% from last month',
                icon: Icons.trending_up,
                iconColor: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Crops Identified',
                value: '4',
                subtitle: 'Cashew, cassava, tomato, and maize.',
                icon: Icons.eco,
                iconColor: const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Diseases Detected',
                value: '89',
                change: '+12 from last month',
                icon: Icons.bug_report,
                iconColor: const Color(0xFFD32F2F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Healthy Yields',
                value: '92%',
                change: 'Trending upwards',
                icon: Icons.trending_up,
                iconColor: const Color(0xFF388E3C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Re-export the StatsCard from top_stats_cards.dart
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? change;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    this.change,
    this.subtitle,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: iconColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          
          const SizedBox(height: 4),
          
          if (change != null)
            Text(
              change!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}