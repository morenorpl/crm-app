import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Pastikan import supabase
import 'package:crm_app/screen/dashboard/dashboard_screen.dart';
import 'package:crm_app/screen/CRM/jadwal_screen.dart';
import 'package:crm_app/screen/CRM/kanban/kanban_screen.dart';
import 'package:crm_app/screen/profile/profile_screen.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';
import 'package:crm_app/screen/CRM/jadwal_screen.dart';
import 'package:crm_app/models/user_session.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;
  final DateTime? initialScheduleDate;

  const MainLayoutScreen({
    super.key,
    this.initialIndex = 0,
    this.initialScheduleDate,
  });

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex = 0;
  String _avatarLetter = 'K'; // Default jika data belum dimuat

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadUserInitial(); // Ambil inisial saat layout pertama kali dibuka
  }

  // Fungsi untuk mengambil huruf depan nama user dari database/metadata
  Future<void> _loadUserInitial() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        String? name;

        // 1. Try checking userMetadata first
        name = user.userMetadata?['name'] ?? user.userMetadata?['username'];

        // 2. If not found in metadata, fetch from public.users table using auth_id
        if (name == null || name.isEmpty) {
          final data = await Supabase.instance.client
              .from('users')
              .select('name')
              .eq('auth_id', user.id)
              .maybeSingle();

          if (data != null && data['name'] != null) {
            name = data['name'];
          }
        }

        // 3. Fallback to email username if both metadata and database name are empty
        if ((name == null || name.isEmpty) && user.email != null) {
          name = user.email!.split('@').first;
        }

        // 4. Extract first letter and update state + global session
        if (name != null && name.isNotEmpty) {
          final fetchedLetter = name[0].toUpperCase();
          UserSession.globalInitial = fetchedLetter; // Save globally

          if (mounted) {
            setState(() {
              _avatarLetter = fetchedLetter;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user initial: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang diberi akses membawa variabel _avatarLetter jika dibutuhkan
    final List<Widget> pages = [
      DashboardScreen(
        avatarLetter: _avatarLetter,
        onNavigateToPipeline: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      CrmBoardScreen(avatarLetter: _avatarLetter),
      ScheduleScreen(
        avatarLetter: _avatarLetter,
        initialDate: widget.initialScheduleDate,
      ),
      ProfileScreen(avatarLetter: _avatarLetter),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Main Page Content
          IndexedStack(index: _currentIndex, children: pages),

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
        color: const Color(0xFF5B4C6D).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.dashboard_outlined, 'Dashboard', 0),
          _navItem(Icons.analytics_outlined, 'Pipeline', 1),
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
            Icon(
              icon,
              size: 19,
              color: active ? AppColors.white : AppColors.muted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.white : AppColors.muted,
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
