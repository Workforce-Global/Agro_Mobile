// dashboard/crop_analysis/widgets/top_bar.dart
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onSidebarToggle;
  final String title;
  final bool isMobile;

  const TopBar({
    Key? key,
    required this.onSidebarToggle,
    required this.title,
    required this.isMobile, // 👈 Accept isMobile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8), // 👈 Move menu icon down
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onSidebarToggle, // 👈 This will trigger Drawer or collapse
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.light_mode),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
