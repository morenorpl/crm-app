// ignore_for_file: deprecated_member_use

import 'package:crm_app/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Filter States
  String _selectedTeamFilter = 'Tim Bawahanku';
  String _selectedTimeFilter = 'Semua waktu';

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
                // --- Top Bar (Dashboard Title & Profile Avatar) ---
                const HeaderBar(
                  title: 'Dashboard',
                  subtitle: 'Siap membuat konten berkah hari ini?',
                ),
                const SizedBox(height: 12),

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
                        () => setState(
                          () => _selectedTeamFilter = 'Tim Bawahanku',
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Kinerja Ku Saja',
                        _selectedTeamFilter == 'Kinerja Ku Saja',
                        () => setState(
                          () => _selectedTeamFilter = 'Kinerja Ku Saja',
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildFilterChip(
                        'Semua waktu',
                        _selectedTimeFilter == 'Semua waktu',
                        () =>
                            setState(() => _selectedTimeFilter = 'Semua waktu'),
                        activeColor: const Color(0xFF32C770),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Hari ini',
                        _selectedTimeFilter == 'Hari ini',
                        () => setState(() => _selectedTimeFilter = 'Hari ini'),
                        activeColor: const Color(0xFF32C770),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- Metric Cards ---
                _buildMetricCard(
                  title: 'Kalender Posting',
                  value: '4',
                  subtitle: 'Jadwal Konten Tersimpan',
                  actionText: 'Selesaikan Otomatis',
                  icon: Icons.calendar_today_rounded,
                  iconBgColor: const Color(0xFF10B981).withOpacity(0.2),
                  iconColor: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  title: 'Maju Leads Terkumpul',
                  value: '80',
                  subtitle: 'Galeri Jemaah Travel Terdekat',
                  actionText: 'Selesaikan Otomatis',
                  icon: Icons.people_alt_rounded,
                  iconBgColor: const Color(0xFFEC4899).withOpacity(0.2),
                  iconColor: const Color(0xFFEC4899),
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  title: 'Total Generasi Media',
                  value: '156',
                  subtitle: 'Teks, Gambar, Video & TTS',
                  actionText: 'Status Generasi',
                  icon: Icons.grid_view_rounded,
                  iconBgColor: const Color(0xFF3B82F6).withOpacity(0.2),
                  iconColor: const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  title: 'Total Generasi Media',
                  value: '156',
                  subtitle: 'Teks, Gambar, Video & TTS',
                  actionText: null,
                  icon: Icons.folder_copy_rounded,
                  iconBgColor: const Color(0xFFF59E0B).withOpacity(0.2),
                  iconColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 24),

                // --- Produktifitas Harian Card ---
                Container(
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
                          const Text(
                            'Produktifitas Harian',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Total Terakhir',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Total item tergenerasi harian (Posting sosial media, gambar, video, tts, dan leads).',
                        style: TextStyle(
                          color: Color(0xFFA197B4),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Chart Placeholder Representation
                      SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Max: 22',
                                style: TextStyle(
                                  color: Color(0xFFA197B4),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Divider(color: Color(0xFF4A3E63), height: 1),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Text(
                                  '7 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '8 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '9 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '10 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '11 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '12 Agu',
                                  style: TextStyle(
                                    color: Color(0xFFA197B4),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF10B981),
                            size: 10,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Hari ini',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          Spacer(),
                          Text(
                            'Ujung kolom dapat di-hover untuk melihat rincian item',
                            style: TextStyle(
                              color: Color(0xFFA197B4),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Laporan Harian Section ---
                Container(
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
                      const Text(
                        'Laporan Harian',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Daftar lengkap rincian generator per hari.',
                        style: TextStyle(
                          color: Color(0xFFA197B4),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildReportRow(
                        'Kamis, 11 Juli 2026',
                        'Total : 22 item',
                        tags: ['Situs 7', 'Konten 11', 'Leads 19'],
                      ),
                      const SizedBox(height: 8),
                      _buildReportRow(
                        'Jumat, 10 Juli 2026',
                        'Total : 10 item',
                        tags: ['Situs 7', 'Situs 4', 'Leads 11'],
                      ),
                      const SizedBox(height: 8),
                      _buildReportRow(
                        'Sabtu, 11 Juli 2026',
                        'Total : 18 item',
                        tags: ['Situs 7'],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Pipeline CRM Card ---
                Container(
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
                      const Text(
                        'Pipeline CRM Calon Jemaah',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau dan kelola prospek jemaah umrah dari berbagai sumber secara terintegrasi.',
                        style: TextStyle(
                          color: Color(0xFFA197B4),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF7B6C9B)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Text(
                          'Buka Board CRM',
                          style: TextStyle(fontSize: 12),
                        ),
                        label: const Icon(Icons.north_east, size: 14),
                      ),
                      const SizedBox(height: 16),

                      // Filter Sub-Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1735).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildInputDropdown(
                              'Cari prospek/nama CRM/telepon...',
                            ),
                            const SizedBox(height: 8),
                            _buildInputDropdown('Semua Sumber'),
                            const SizedBox(height: 8),
                            _buildInputDropdown('Semua Tipe Output'),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF61547D),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.file_download_outlined,
                                size: 18,
                              ),
                              label: const Text('Ekspor CSV'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF32C770),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Tambah Prospek Baru'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notes, color: Colors.white70, size: 22),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CRM Pipeline — Kanban Board',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Siap membuat konten berkah hari ini?',
                style: TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.purpleAccent,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'k',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildReportRow(
    String date,
    String total, {
    required List<String> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1735).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3152),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  total,
                  style: const TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: tags
                .map(
                  (tag) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xFF60A5FA),
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDropdown(String placeholder) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D234A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4A3E63)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFA197B4), size: 16),
          const SizedBox(width: 8),
          Text(
            placeholder,
            style: const TextStyle(color: Color(0xFFA197B4), fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D234A),
        title: const Text('Keluar Akun', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: Color(0xFFA197B4)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
