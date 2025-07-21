import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFFF9F9E4),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.agriculture, size: 40, color: Colors.green),
          const Text(
            "AgroSaviour",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildMenuItem(Icons.dashboard, "Dashboard", true),
          _buildMenuItem(Icons.image_search, "Analyze Image", false),
          _buildMenuItem(Icons.insights, "Insights", false),
          _buildMenuItem(Icons.settings, "Settings", false),
          const Spacer(),
          const CircleAvatar(child: Text("N")),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: ListTile(
          leading: Icon(icon, color: selected ? Colors.green : Colors.grey),
          title: Text(title),
          onTap: () {},
        ),
      ),
    );
  }
}
