import 'package:flutter/material.dart';
import 'widgets/sidebar_menu.dart';
import 'widgets/top_stats_cards.dart';
import 'widgets/disease_chart.dart';
import 'widgets/crop_distribution_chart.dart';
import 'widgets/recent_scans_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 900;

          return Row(
            children: [
              if (isWideScreen) const SidebarMenu(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TopStatsCards(),
                          const SizedBox(height: 24),
                          Flex(
                            direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(child: DiseaseChartCard()),
                              SizedBox(width: 16, height: 16),
                              Expanded(child: CropDistributionChartCard()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const RecentScansList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
