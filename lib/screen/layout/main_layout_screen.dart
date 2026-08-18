import 'package:flutter/material.dart';
import 'package:crm_app/screen/dashboard/dashboard_screen.dart';
import 'package:crm_app/screen/CRM/jadwal_screen.dart';
import 'package:crm_app/screen/CRM/kanban_screen.dart';
import 'package:crm_app/screen/profile/profile_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  static const Color background = Color(0xFF1E1B3A);
  static const Color white = Colors.white;
  static const Color muted = Colors.white54;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CrmBoardScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // 1. Main Page Content
          IndexedStack(index: _currentIndex, children: _pages),

          // 2. Floating Navbar overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Center(child: _buildBottomBarCapsule()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarCapsule() {
    return Container(
      width: 255,
      height: 49,
      decoration: BoxDecoration(
        color: const Color(0xFF5B4C6D).withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home_outlined, 'Home', 0),
          _navItem(Icons.grid_view_rounded, 'Pipeline', 1),
          _navItem(Icons.calendar_month_outlined, 'Schedule', 2),
          _navItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 19, color: active ? white : muted),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active ? white : muted,
                fontSize: 8,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
