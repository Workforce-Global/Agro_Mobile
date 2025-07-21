import 'package:flutter/material.dart';

class RecentScansList extends StatelessWidget {
  const RecentScansList({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = List.generate(5, (i) => "Scan ${i + 1}: Tomato Leaf Blight");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Scans", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dummyData.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.search),
                title: Text(dummyData[index]),
                subtitle: const Text("Detected on 2025-07-20"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        ),
      ],
    );
  }
}
