import 'package:flutter/material.dart';

class TopStatsCards extends StatelessWidget {
  const TopStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(
              title: "Total Scans",
              value: "48",
              description: "Diseases detected",
              icon: Icons.qr_code_scanner_rounded,
            ),
            _StatCard(
              title: "Healthy Crops",
              value: "34",
              description: "No diseases found",
              icon: Icons.eco,
            ),
            _StatCard(
              title: "Disease Rate",
              value: "29%",
              description: "Affected crops",
              icon: Icons.warning_amber_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title, value, description;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 260,
        height: isExpanded ? 160 : 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDF1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Icon(widget.icon, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (isExpanded)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("Tap again to collapse", style: TextStyle(fontSize: 10, color: Colors.grey)),
              )
          ],
        ),
      ),
    );
  }
}
