// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crm_app/widgets/header_bar.dart';
import '../CRM/kanban/widgets/crm_kanban_tabs.dart';
import '../CRM/kanban/widgets/crm_prospect_card.dart';
import '../CRM/kanban/models/lead_model.dart';

class DashboardScreen extends StatefulWidget {
  final String avatarLetter;

  const DashboardScreen({super.key, required this.avatarLetter});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State filter umum dashboard
  String _selectedTeamFilter = 'Tim Bawahanku';
  String _selectedTimeFilter = 'Semua waktu';

  // State Pipeline CRM Kanban (Pastikan menggunakan key singkat yang sesuai dengan tab data)
  String _selectedPipelineStatus = 'baru';

  // Instance Supabase Client
  final _supabase = Supabase.instance.client;

  // Stream data langsung dari Supabase tabel 'leads'
  Stream<List<LeadModel>> _getLeadsStream() {
    return _supabase
        .from('leads')
        .stream(primaryKey: ['id'])
        .order('id', ascending: false)
        .map((data) {
          return data
              .map((json) => LeadModel.fromMap(Map<String, dynamic>.from(json)))
              .toList();
        });
  }

  // Map Data Tab Kanban
  final Map<String, String> _kanbanTabsData = {
    'Prospek Baru': 'baru',
    'Dihubungi': 'dihubungi',
    'Prospek Layak': 'layak',
    'Closed': 'closed',
  };

  // Function untuk Update Status Lead ke Supabase
  Future<void> _updateLeadStatus(dynamic leadId, String newStatus) async {
    try {
      await _supabase
          .from('leads')
          .update({'status': newStatus})
          .eq('id', leadId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memperbarui status: $e')));
      }
    }
  }

  // Function untuk Hapus Lead di Supabase
  Future<void> _deleteLead(dynamic leadId) async {
    try {
      await _supabase.from('leads').delete().eq('id', leadId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus data: $e')));
      }
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
                HeaderBar(
                  title: 'Dashboard CRM',
                  subtitle: 'Selamat datang kembali!',
                  avatarText: widget.avatarLetter,
                ),
                const SizedBox(height: 16),

                // Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
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
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
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

                // Metric Cards
                _buildMetricCard(
                  title: 'Kalender Posting',
                  titleColor: const Color(0xFF10B981),
                  value: '4',
                  subtitle: 'Jadwal Konten Tersimpan',
                  actionText: 'Sinkronisasi Otomatis',
                  icon: Icons.calendar_month_rounded,
                  iconBgColor: const Color(0xFF10B981).withOpacity(0.2),
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
                  iconBgColor: const Color(0xFFF43F5E).withOpacity(0.2),
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
                  iconBgColor: const Color(0xFF38BDF8).withOpacity(0.2),
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
                  iconBgColor: const Color(0xFFF59E0B).withOpacity(0.2),
                  iconColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),

                _buildProduktifitasHarianCard(),
                const SizedBox(height: 16),

                // Dynamic Laporan Harian Terperinci Card
                _buildLaporanHarianCard(),
                const SizedBox(height: 16),

                _buildPipelineCrmCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        color: const Color(0xFF4A3B69).withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
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
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 14),
            Text(
              actionText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getProductivityLeadsStream() {
    return _supabase
        .from('leads')
        .stream(primaryKey: ['id'])
        .map(
          (data) =>
              data.map((json) => Map<String, dynamic>.from(json)).toList(),
        );
  }

  Widget _buildProduktifitasHarianCard() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getProductivityLeadsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildProduktifitasCardContent(isLoading: true);
        }

        if (snapshot.hasError) {
          return _buildProduktifitasCardContent(
            errorText: 'Gagal mengambil data leads: ${snapshot.error}',
          );
        }

        final leads = snapshot.data ?? [];
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final List<Map<String, dynamic>> dailyData = [];

        for (int i = 6; i >= 0; i--) {
          final date = today.subtract(Duration(days: i));
          int total = 0;

          for (final lead in leads) {
            final createdAtValue = lead['created_at'];
            if (createdAtValue == null) continue;

            DateTime? createdAt;
            try {
              createdAt = DateTime.parse(createdAtValue.toString()).toLocal();
            } catch (_) {
              continue;
            }

            final createdDate = DateTime(
              createdAt.year,
              createdAt.month,
              createdAt.day,
            );

            if (createdDate.year == date.year &&
                createdDate.month == date.month &&
                createdDate.day == date.day) {
              total++;
            }
          }

          dailyData.add({
            'date': date,
            'total': total,
            'label': _formatChartDate(date),
          });
        }

        int maxTotal = 0;
        for (final item in dailyData) {
          final total = item['total'] as int;
          if (total > maxTotal) {
            maxTotal = total;
          }
        }

        return _buildProduktifitasCardContent(
          dailyData: dailyData,
          maxTotal: maxTotal,
        );
      },
    );
  }

  Widget _buildProduktifitasCardContent({
    bool isLoading = false,
    String? errorText,
    List<Map<String, dynamic>>? dailyData,
    int maxTotal = 0,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
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
                  color: const Color(0xFF10B981).withOpacity(0.2),
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
            'Jumlah leads yang dibuat setiap hari berdasarkan data Supabase.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            Text(
              'Memuat data...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
              ),
            )
          else if (errorText != null)
            Text(
              errorText,
              style: const TextStyle(color: Colors.redAccent, fontSize: 10),
            )
          else
            Text(
              'Max ($maxTotal)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            height: 125,
            child: isLoading || errorText != null
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: dailyData!.map((item) {
                      final total = item['total'] as int;
                      final label = item['label'] as String;
                      final date = item['date'] as DateTime;
                      final isToday = _isSameDate(date, DateTime.now());

                      return _buildBarItem(
                        label,
                        total,
                        maxTotal,
                        isToday: isToday,
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 8),
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
              Flexible(
                child: Text(
                  'Jumlah bar mengikuti jumlah leads yang dibuat pada hari tersebut.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
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

  Widget _buildBarItem(
    String label,
    int total,
    int maxTotal, {
    bool isToday = false,
  }) {
    double barHeight = 0;

    if (maxTotal > 0 && total > 0) {
      barHeight = 10 + ((total / maxTotal) * 65);
    } else if (total > 0) {
      barHeight = 10;
    }

    return SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 16,
            child: Text(
              '$total',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isToday
                    ? const Color(0xFF10B981)
                    : Colors.white.withOpacity(0.55),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: barHeight > 0 ? barHeight : 4,
            width: 38,
            decoration: BoxDecoration(
              color: isToday
                  ? const Color(0xFF10B981)
                  : Colors.white.withOpacity(total > 0 ? 0.45 : 0.12),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 16,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: isToday
                    ? const Color(0xFF10B981)
                    : Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatChartDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  // --- Dynamic Laporan Harian Terperinci Card ---
  Widget _buildLaporanHarianCard() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getProductivityLeadsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLaporanContainer(
            child: const Text(
              'Memuat laporan...',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          );
        }

        final leads = snapshot.data ?? [];
        Map<String, Map<String, int>> groupedData = {};

        for (final lead in leads) {
          final createdAtValue = lead['created_at'];
          if (createdAtValue == null) continue;

          DateTime? createdAt;
          try {
            createdAt = DateTime.parse(createdAtValue.toString()).toLocal();
          } catch (_) {
            continue;
          }

          // Format tanggal tampilan, misal: "Kamis, 9 Juli 2026"
          String dateKey = _formatLongDate(createdAt);
          String status = lead['status'] ?? 'baru';

          if (!groupedData.containsKey(dateKey)) {
            groupedData[dateKey] = {
              'baru': 0,
              'dihubungi': 0,
              'layak': 0,
              'closed': 0,
            };
          }

          if (groupedData[dateKey]!.containsKey(status)) {
            groupedData[dateKey]![status] = groupedData[dateKey]![status]! + 1;
          }
        }

        // Ambil maksimal 3 hari terakhir yang memiliki data (atau hari-hari terkini)
        final sortedKeys = groupedData.keys.take(3).toList();

        return _buildLaporanContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Laporan Harian Terperinci',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Daftar rinci dari prospek-prospek yang ditambah per hari.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 14),
              if (sortedKeys.isEmpty)
                Text(
                  'Belum ada data laporan harian.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                )
              else
                ...sortedKeys.map((dateStr) {
                  final counts = groupedData[dateStr]!;
                  final total = counts.values.fold(0, (sum, val) => sum + val);

                  List<Widget> dynamicBadges = [];

                  if ((counts['baru'] ?? 0) > 0) {
                    dynamicBadges.add(
                      _buildBadge(
                        'Baru : ${counts['baru']}',
                        const Color(0xFF3B82F6),
                      ),
                    );
                  }
                  if ((counts['dihubungi'] ?? 0) > 0) {
                    dynamicBadges.add(
                      _buildBadge(
                        'Dihubungi : ${counts['dihubungi']}',
                        const Color(0xFF0284C7),
                      ),
                    );
                  }
                  if ((counts['layak'] ?? 0) > 0) {
                    dynamicBadges.add(
                      _buildBadge(
                        'Prospek Layak : ${counts['layak']}',
                        const Color(0xFF10B981),
                      ),
                    );
                  }
                  if ((counts['closed'] ?? 0) > 0) {
                    dynamicBadges.add(
                      _buildBadge(
                        'Closed : ${counts['closed']}',
                        const Color(0xFF8B5CF6),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildDailyReportItem(
                      date: dateStr,
                      total: total,
                      badges: dynamicBadges,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLaporanContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: child,
    );
  }

  String _formatLongDate(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    // weekday returns 1 for Monday through 7 for Sunday
    String dayName = days[date.weekday - 1];
    String monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  Widget _buildDailyReportItem({
    required String date,
    required int total,
    required List<Widget> badges,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 4, children: badges),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
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

  // --- Pipeline CRM Card dengan Supabase Stream ---
  Widget _buildPipelineCrmCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3B69).withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pipeline CRM Calon Jemaah',
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
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                    backgroundColor: Colors.white.withOpacity(0.12),
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
          const SizedBox(height: 16),

          // Kanban Tabs
          CrmKanbanTabs(
            selectedStatus: _selectedPipelineStatus,
            tabData: _kanbanTabsData,
            onTabChanged: (newStatus) {
              setState(() {
                _selectedPipelineStatus = newStatus;
              });
            },
          ),
          const SizedBox(height: 12),

          // Realtime Stream Data Supabase
          StreamBuilder<List<LeadModel>>(
            stream: _getLeadsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }

              final allLeads = snapshot.data ?? [];
              final filteredLeads = allLeads
                  .where((lead) => lead.status == _selectedPipelineStatus)
                  .toList();

              if (filteredLeads.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: Text(
                    'Belum ada prospek pada kategori ini.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                );
              }

              return Column(
                children: filteredLeads.map((lead) {
                  return CrmProspectCard(
                    leadData: lead,
                    onEdit: () {
                      // Action Edit
                    },
                    onDelete: () => _deleteLead(lead.id),
                    onStatusChange: (newStatus) =>
                        _updateLeadStatus(lead.id, newStatus),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 16,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(width: 8),
          Text(
            'Cari prospek (nama, KTP, catatan)...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
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
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(0.5)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
