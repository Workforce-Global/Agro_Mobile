import 'package:flutter/material.dart';

class DiseaseChartCard extends StatelessWidget {
  const DiseaseChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightGreen[100],
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text("Disease Detection Chart (Coming Soon)",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
