import 'package:flutter/material.dart';

class CropDistributionChartCard extends StatelessWidget {
  const CropDistributionChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[100],
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text("Crop Distribution Chart (Coming Soon)",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
