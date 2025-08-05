// dashboard/mobile_dash/mobile_dashboard.dart
import 'package:agro_sav/app/screens/dashboard/crop%20analysis/crop_analysis_dashboard.dart';
import 'package:agro_sav/app/screens/dashboard/stream/camera_stream_screen.dart';
import 'package:agro_sav/app/screens/dashboard/widgets/sidebar_menu.dart';
import 'package:flutter/material.dart';

class MobileDashboard extends StatefulWidget {
  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  bool _isSidebarCollapsed = true;
  String _currentPage = 'Dashboard'; // Track current page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: Row(
        children: [
          // Sidebar with navigation
          Sidebar(
            isCollapsed: _isSidebarCollapsed,
            currentPage: _currentPage,
            onToggle: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
          // Main Content Area
          Expanded(child: _buildCurrentPage()),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'Dashboard':
        return _buildDashboardContent();
      case 'Analysis':
      case 'Insights':
        return CropAnalysisDashboard();
      case 'History':
        return _buildHistoryContent();
      case 'Settings':
        return _buildSettingsContent();
      case 'Camera Stream':
        return CameraStreamScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        // Top Bar
        _buildTopBar(),
        // Dashboard Content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dashboard, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Welcome to AgroSaviour Mobile Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Navigate to Analysis to start crop image analysis',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Quick action cards
                _buildQuickActionCards(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.analytics,
                  title: 'Crop Analysis',
                  description: 'Analyze crop health',
                  color: const Color(0xFF4CAF50),
                  onTap: () {
                    setState(() {
                      _currentPage = 'Analysis';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.history,
                  title: 'View History',
                  description: 'Past analyses',
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    setState(() {
                      _currentPage = 'History';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.insights,
                  title: 'Insights',
                  description: 'Crop insights',
                  color: const Color(0xFFFF9800),
                  onTap: () {
                    setState(() {
                      _currentPage = 'Insights';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  description: 'App settings',
                  color: const Color(0xFF9C27B0),
                  onTap: () {
                    setState(() {
                      _currentPage = 'Settings';
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Dummy data count
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF4CAF50),
                            child: Icon(Icons.eco, color: Colors.white),
                          ),
                          title: Text('Analysis ${index + 1}'),
                          subtitle: Text(
                            '${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]} - Healthy crop detected',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            // Show analysis details
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notifications'),
                        subtitle: const Text('Manage notification preferences'),
                        trailing: Switch(value: true, onChanged: (value) {}),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.dark_mode),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Switch to dark theme'),
                        trailing: Switch(value: false, onChanged: (value) {}),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Language'),
                        subtitle: Text('English'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        subtitle: Text('App version and information'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
          ),
          const Spacer(),
          Text(
            _currentPage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.light_mode), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
    );
  }
}
