// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:crm_app/widgets/header_bar.dart';

class DashboardScreen extends StatefulWidget {
  final String avatarLetter;

  const DashboardScreen({super.key, required this.avatarLetter});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State sederhana hanya untuk perpindahan visual tab filter
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
                // --- Top Bar Header (Tidak Diubah) ---
                HeaderBar(
                  title: 'Dashboard CRM',
                  subtitle: 'Selamat datang kembali!',
                  avatarText: widget.avatarLetter,
                ),
                const SizedBox(height: 16),

                // --- Filter Pills ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              'Tim Bawahanku',
                              _selectedTeamFilter == 'Tim Bawahanku',
                              () => setState(
                                () => _selectedTeamFilter = 'Tim Bawahanku',
                              ),
                              activeColor: const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 4),
                            _buildFilterChip(
                              'Kinerja Ku Saja',
                              _selectedTeamFilter == 'Kinerja Ku Saja',
                              () => setState(
                                () => _selectedTeamFilter = 'Kinerja Ku Saja',
                              ),
                              activeColor: const Color(0xFF3B82F6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              'Semua waktu',
                              _selectedTimeFilter == 'Semua waktu',
                              () => setState(
                                () => _selectedTimeFilter = 'Semua waktu',
                              ),
                              activeColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            _buildFilterChip(
                              'Hari ini',
                              _selectedTimeFilter == 'Hari ini',
                              () => setState(
                                () => _selectedTimeFilter = 'Hari ini',
                              ),
                              activeColor: const Color(0xFF10B981),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- 4 Card Metrik Utama ---
                _buildMetricCard(
                  title: 'Kalender Posting',
                  titleColor: const Color(0xFF10B981),
                  value: '4',
                  subtitle: 'Jadwal Konten Tersimpan',
                  actionText: 'Sinkronisasi Otomatis',
                  icon: Icons.calendar_month_rounded,
                  iconBgColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                  iconColor: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),

                _buildMetricCard(
                  title: 'Maps Leads Terkumpul',
                  titleColor: const Color(0xFFF43F5E),
                  value: '80',
                  subtitle: 'Calon Jamaah travel terdekat',
                  actionText: 'Sinkronisasi Otomatis',
                  icon: Icons.calendar_month_rounded,
                  iconBgColor: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                  iconColor: const Color(0xFFF43F5E),
                ),
                const SizedBox(height: 12),

                _buildMetricCard(
                  title: 'Total Generasi Media',
                  titleColor: const Color(0xFF38BDF8),
                  value: '156',
                  subtitle: 'Text, Gambar, Video & TTS',
                  actionText: 'Status Generator',
                  icon: Icons.calendar_month_rounded,
                  iconBgColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                  iconColor: const Color(0xFF38BDF8),
                ),
                const SizedBox(height: 12),

                _buildMetricCard(
                  title: 'Total Generasi Media',
                  titleColor: const Color(0xFFF59E0B),
                  value: '156',
                  subtitle: 'Text, Gambar, Video & TTS',
                  actionText: null,
                  icon: Icons.calendar_month_rounded,
                  iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                  iconColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),

                // --- Section 1: Produktifitas Harian ---
                _buildProduktifitasHarianCard(),
                const SizedBox(height: 16),

                // --- Section 2: Laporan Harian ---
                _buildLaporanHarianCard(),
                const SizedBox(height: 16),

                // --- Section 3: Pipeline CRM Calon Jemaah ---
                _buildPipelineCrmCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Filter Chip
  Widget _buildFilterChip(
    String label,
    bool isActive,
    VoidCallback onTap, {
    Color activeColor = const Color(0xFF3B82F6),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
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

  // Helper Card Metrik
  Widget _buildMetricCard({
    required String title,
    required Color titleColor,
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
        color: const Color(0xFF4A3B69).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 14),
            Text(
              actionText,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Card Produktifitas Harian
  Widget _buildProduktifitasHarianCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '7 Hari Terakhir',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Total item tergenerate harian (Gabungan social post, gambar, video, tts, dan leads).',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Max (1)',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),

          // Visual Bar Chart Horizontal Lines & Items
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarItem('7 Agu'),
                _buildBarItem('8 Agu'),
                _buildBarItem('9 Agu'),
                _buildBarItem('10 Agu'),
                _buildBarItem('11 Agu'),
                _buildBarItem('12 Agu'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Hari ini',
                style: TextStyle(color: Color(0xFFA197B4), fontSize: 10),
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Text(
                  'Ujung kolom dapat di-hover untuk melihat rincian item',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 8,
          width: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // Card Laporan Harian
  Widget _buildLaporanHarianCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Harian',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Daftar lengkap hitungan generator per hari.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),

          _buildDailyReportItem(
            date: 'Kamis, 9 Juli 2026',
            total: 23,
            badges: [
              _buildBadge('Social : 1', const Color(0xFF3B82F6)),
              _buildBadge('Social : 1', const Color(0xFF10B981)),
              _buildBadge('Leads : 17', const Color(0xFF0284C7)),
            ],
          ),
          const SizedBox(height: 8),

          _buildDailyReportItem(
            date: 'Jumat, 10 Juli 2026',
            total: 10,
            badges: [
              _buildBadge('Social : 1', const Color(0xFF3B82F6)),
              _buildBadge('Social : 4', const Color(0xFF10B981)),
              _buildBadge('Leads : 5', const Color(0xFF0284C7)),
            ],
          ),
          const SizedBox(height: 8),

          _buildDailyReportItem(
            date: 'Sabtu, 11 Juli 2026',
            total: 15,
            badges: [_buildBadge('Social : 1', const Color(0xFF10B981))],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportItem({
    required String date,
    required int total,
    required List<Widget> badges,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total : $total item',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: badges),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Card Pipeline CRM
  Widget _buildPipelineCrmCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Papeline CRM Calon Jemaah',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pantau dan kelola prospek jamaah umrah dari berbagai sumber secara terintegrasi.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Text(
              'Buka Board Crm',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            label: const Icon(
              Icons.north_east_rounded,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                _buildSearchInput(),
                const SizedBox(height: 8),
                _buildDropdownFilter(Icons.filter_list_rounded, 'Semua Sumber'),
                const SizedBox(height: 8),
                _buildDropdownFilter(
                  Icons.people_outline_rounded,
                  'Semua Tipe (Output)',
                ),
                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.file_download_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Ekspor CSV',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),

                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    'Tambah Prospek Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 16,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Text(
            'Cari prospek (nama, KTP, catatan)...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
