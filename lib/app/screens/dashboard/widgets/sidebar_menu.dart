import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final String currentPage;
  final VoidCallback onToggle;
  final Function(String) onPageChanged;

  const Sidebar({
    Key? key,
    required this.isCollapsed,
    required this.currentPage,
    required this.onToggle,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 60 : 200,
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32), // Dark green
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 28,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AgroSaviour',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                SidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isCollapsed: isCollapsed,
                  isSelected: currentPage == 'Dashboard',
                  onTap: () => onPageChanged('Dashboard'),
                ),
                SidebarItem(
                  icon: Icons.analytics,
                  title: 'Analysis',
                  isCollapsed: isCollapsed,
                  isSelected: currentPage == 'Analysis',
                  onTap: () {
                    // Use consistent navigation approach
                    onPageChanged('Analysis');
                    // If you need to navigate to a different route, you can do:
                    Get.toNamed('/crop-analysis');
                  },
                ),
                SidebarItem(
                  icon: Icons.insights,
                  title: 'Insights',
                  isCollapsed: isCollapsed,
                  isSelected: currentPage == 'Insights',
                  onTap: () => onPageChanged('Insights'),
                ),
                SidebarItem(
                  icon: Icons.history,
                  title: 'History',
                  isCollapsed: isCollapsed,
                  isSelected: currentPage == 'History',
                  onTap: () => onPageChanged('History'),
                ),
                SidebarItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isCollapsed: isCollapsed,
                  isSelected: currentPage == 'Settings',
                  onTap: () => onPageChanged('Settings'),
                ),
              ],
            ),
          ),
          

        ],
      ),
    );
  }
}

// Sidebar Item Widget
class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCollapsed;
  final bool isSelected;
  final VoidCallback? onTap;

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.isCollapsed,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        title: isCollapsed
            ? null
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 18 : 16,
          vertical: 4,
        ),
        minLeadingWidth: isCollapsed ? 0 : 40,
        onTap: onTap,
        // Add tap feedback for mobile
        splashColor: Colors.white24,
      ),
    );
  }
}