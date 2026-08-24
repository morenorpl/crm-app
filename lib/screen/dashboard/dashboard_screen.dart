// ignore_for_file: deprecated_member_use

import 'package:crm_app/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/widgets/header_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final String avatarLetter;

  const DashboardScreen({super.key, required this.avatarLetter});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Filter States
  String _selectedTeamFilter = 'Tim Bawahanku';
  String _selectedTimeFilter = 'Semua waktu';

  // Dynamic Metric Variables
  int _postingCount = 0;
  int _leadsCount = 0;
  int _totalMedia = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardMetrics();
  }

  Future<void> _fetchDashboardMetrics() async {
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // NOTE: Since your table uses integer IDs (1, 2, 3),
      // we can set a test user ID (e.g., 1) for "Kinerja Ku Saja" while testing!
      const int testCurrentUserId = 1;

      // 1. Determine Date Filter Range for "Hari ini" (Aug 24, 2026 based on your table data)
      DateTime? startDate;
      DateTime? endDate;

      if (_selectedTimeFilter == 'Hari ini') {
        // Using August 24, 2026 to match your table's sample data for testing
        startDate = DateTime(2026, 8, 24, 0, 0, 0);
        endDate = DateTime(2026, 8, 24, 23, 59, 59);
      }

      // 2. Base Queries for Tables
      var postingQuery = supabase
          .from('posting')
          .select('id, created_at, user_id');
      var leadsQuery = supabase.from('leads').select('id, created_at, user_id');
      var mediaQuery = supabase
          .from('media_generations')
          .select('jumlah, created_at, user_id');

      // 3. Apply User Scope Filter ('Kinerja Ku Saja' vs 'Tim Bawahanku')
      if (_selectedTeamFilter == 'Kinerja Ku Saja') {
        postingQuery = postingQuery.eq('user_id', testCurrentUserId);
        leadsQuery = leadsQuery.eq('user_id', testCurrentUserId);
        mediaQuery = mediaQuery.eq('user_id', testCurrentUserId);
      }

      // 4. Apply Time Filter if "Hari ini" is selected
      if (_selectedTimeFilter == 'Hari ini' &&
          startDate != null &&
          endDate != null) {
        postingQuery = postingQuery
            .gte('created_at', startDate.toIso8601String())
            .lte('created_at', endDate.toIso8601String());
        leadsQuery = leadsQuery
            .gte('created_at', startDate.toIso8601String())
            .lte('created_at', endDate.toIso8601String());
        mediaQuery = mediaQuery
            .gte('created_at', startDate.toIso8601String())
            .lte('created_at', endDate.toIso8601String());
      }

      // 5. Execute Queries
      final postingData = await postingQuery;
      final leadsData = await leadsQuery;
      final mediaData = await mediaQuery;

      // Calculate total generated media by summing the 'jumlah' column
      int mediaSum = 0;
      for (var item in mediaData) {
        mediaSum += (item['jumlah'] as num?)?.toInt() ?? 0;
      }

      if (mounted) {
        setState(() {
          _postingCount = postingData.length;
          _leadsCount = leadsData.length;
          _totalMedia = mediaSum;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint("Error fetching dashboard metrics: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1735),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF382D54), Color(0xFF1E1735)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Top Bar ---
                HeaderBar(
                  title: 'Dashboard CRM',
                  subtitle: 'Selamat datang kembali!',
                  avatarText: widget.avatarLetter,
                ),
                const SizedBox(height: 16),

                // --- Section Header ---
                Row(
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF32C770),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Dashboard Analitik Mitra',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Menampilkan kinerja mitra dibawah Anda.',
                  style: TextStyle(color: Color(0xFFA197B4), fontSize: 12),
                ),
                const SizedBox(height: 16),

                // --- Filter Pills ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'Tim Bawahanku',
                        _selectedTeamFilter == 'Tim Bawahanku',
                        () {
                          setState(() => _selectedTeamFilter = 'Tim Bawahanku');
                          _fetchDashboardMetrics();
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Kinerja Ku Saja',
                        _selectedTeamFilter == 'Kinerja Ku Saja',
                        () {
                          setState(
                            () => _selectedTeamFilter = 'Kinerja Ku Saja',
                          );
                          _fetchDashboardMetrics();
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildFilterChip(
                        'Semua waktu',
                        _selectedTimeFilter == 'Semua waktu',
                        () {
                          setState(() => _selectedTimeFilter = 'Semua waktu');
                          _fetchDashboardMetrics();
                        },
                        activeColor: const Color(0xFF32C770),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Hari ini',
                        _selectedTimeFilter == 'Hari ini',
                        () {
                          setState(() => _selectedTimeFilter = 'Hari ini');
                          _fetchDashboardMetrics();
                        },
                        activeColor: const Color(0xFF32C770),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- Metric Cards ---
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF32C770),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          _buildMetricCard(
                            title: 'Kalender Posting',
                            value: '$_postingCount',
                            subtitle: 'Jadwal Konten Tersimpan',
                            actionText: 'Selesaikan Otomatis',
                            icon: Icons.calendar_today_rounded,
                            iconBgColor: const Color(
                              0xFF10B981,
                            ).withOpacity(0.2),
                            iconColor: const Color(0xFF10B981),
                          ),
                          const SizedBox(height: 12),
                          _buildMetricCard(
                            title: 'Maju Leads Terkumpul',
                            value: '$_leadsCount',
                            subtitle: 'Galeri Jemaah Travel Terdekat',
                            actionText: 'Selesaikan Otomatis',
                            icon: Icons.people_alt_rounded,
                            iconBgColor: const Color(
                              0xFFEC4899,
                            ).withOpacity(0.2),
                            iconColor: const Color(0xFFEC4899),
                          ),
                          const SizedBox(height: 12),
                          _buildMetricCard(
                            title: 'Total Generasi Media',
                            value: '$_totalMedia',
                            subtitle: 'Teks, Gambar, Video & TTS',
                            actionText: 'Status Generasi',
                            icon: Icons.grid_view_rounded,
                            iconBgColor: const Color(
                              0xFF3B82F6,
                            ).withOpacity(0.2),
                            iconColor: const Color(0xFF3B82F6),
                          ),
                        ],
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildFilterChip(
    String label,
    bool isActive,
    VoidCallback onTap, {
    Color activeColor = const Color(0xFF4285F4),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFF3A3152),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFFA197B4),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required String? actionText,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D234A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A3E63)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFA197B4),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFFA197B4), fontSize: 11),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 12),
            Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFFA197B4),
                fontSize: 10,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
