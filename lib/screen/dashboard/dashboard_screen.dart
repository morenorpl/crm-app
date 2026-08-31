// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:crm_app/widgets/header_bar.dart';
import '../CRM/kanban/widgets/crm_kanban_tabs.dart';
import '../CRM/kanban/widgets/crm_prospect_card.dart';
import '../CRM/kanban/models/lead_model.dart';
import '../CRM/kanban/widgets/crm_search_panel.dart';
import '../CRM/kanban/controllers/crm_controller.dart';

class DashboardScreen extends StatefulWidget {
  final String avatarLetter;

  const DashboardScreen({super.key, required this.avatarLetter});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CrmController _crmController = CrmController();

  // ==========================================
  // FILTER DASHBOARD
  // ==========================================

  String _selectedTeamFilter = 'Tim Bawahanku';
  String _selectedTimeFilter = 'Semua waktu';

  // ==========================================
  // FILTER PIPELINE CRM
  // ==========================================

  String _selectedPipelineStatus = 'baru';

  // ==========================================
  // SUPABASE
  // ==========================================

  final _supabase = Supabase.instance.client;

  // ==========================================
  // STREAM LEADS
  // ==========================================

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

  // ==========================================
  // DATA TAB KANBAN
  // ==========================================

  final Map<String, String> _kanbanTabsData = {
    'Prospek Baru': 'baru',
    'Dihubungi': 'dihubungi',
    'Prospek Layak': 'layak',
    'Closed': 'closed',
  };

  // ==========================================
  // UPDATE STATUS LEAD
  // ==========================================

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

  // ==========================================
  // DELETE LEAD
  // ==========================================

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

  // ==========================================
  // BUILD
  // ==========================================

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
                // ==========================================
                // HEADER
                // ==========================================

                HeaderBar(
                  title: 'Dashboard CRM',
                  subtitle: 'Selamat datang kembali!',
                  avatarText: widget.avatarLetter,
                ),

                const SizedBox(height: 16),

                // ==========================================
                // FILTER PILLS
                // ==========================================
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
                              () {
                                setState(() {
                                  _selectedTeamFilter = 'Tim Bawahanku';
                                });
                              },
                              activeColor: const Color(0xFF3B82F6),
                            ),

                            const SizedBox(width: 4),

                            _buildFilterChip(
                              'Kinerja Ku Saja',
                              _selectedTeamFilter == 'Kinerja Ku Saja',
                              () {
                                setState(() {
                                  _selectedTeamFilter = 'Kinerja Ku Saja';
                                });
                              },
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
                              () {
                                setState(() {
                                  _selectedTimeFilter = 'Semua waktu';
                                });
                              },
                              activeColor: const Color(0xFF10B981),
                            ),

                            const SizedBox(width: 4),

                            _buildFilterChip(
                              'Hari ini',
                              _selectedTimeFilter == 'Hari ini',
                              () {
                                setState(() {
                                  _selectedTimeFilter = 'Hari ini';
                                });
                              },
                              activeColor: const Color(0xFF10B981),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // METRIC CARDS
                // ==========================================
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

                // ==========================================
                // PRODUKTIFITAS
                // ==========================================
                _buildProduktifitasHarianCard(),

                const SizedBox(height: 16),

                // ==========================================
                // LAPORAN HARIAN
                // ==========================================
                _buildLaporanHarianCard(),

                const SizedBox(height: 16),

                // ==========================================
                // PIPELINE CRM
                // ==========================================
                _buildPipelineCrmCard(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // FILTER CHIP
  // ==========================================

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

  // ==========================================
  // METRIC CARD
  // ==========================================

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

  // ==========================================
  // PRODUCTIVITY STREAM
  // ==========================================

  Stream<List<Map<String, dynamic>>> _getProductivityLeadsStream() {
    return _supabase
        .from('leads')
        .stream(primaryKey: ['id'])
        .map(
          (data) =>
              data.map((json) => Map<String, dynamic>.from(json)).toList(),
        );
  }

  // ==========================================
  // PRODUKTIFITAS HARIAN
  // ==========================================

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

            if (createdAtValue == null) {
              continue;
            }

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

  // ==========================================
  // PRODUKTIFITAS CONTENT
  // ==========================================

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

  // ==========================================
  // BAR ITEM
  // ==========================================

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

  // ==========================================
  // FORMAT CHART DATE
  // ==========================================

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

  // ==========================================
  // SAME DATE
  // ==========================================

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  // ==========================================
  // LAPORAN HARIAN
  // ==========================================

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

          if (createdAtValue == null) {
            continue;
          }

          DateTime? createdAt;

          try {
            createdAt = DateTime.parse(createdAtValue.toString()).toLocal();
          } catch (_) {
            continue;
          }

          final dateKey = _formatLongDate(createdAt);

          final String status = lead['status']?.toString() ?? 'baru';

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

  // ==========================================
  // LAPORAN CONTAINER
  // ==========================================

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

  // ==========================================
  // FORMAT LONG DATE
  // ==========================================

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

    String dayName = days[date.weekday - 1];

    String monthName = months[date.month - 1];

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  // ==========================================
  // DAILY REPORT ITEM
  // ==========================================

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

  // ==========================================
  // BADGE
  // ==========================================

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

  // ==========================================
  // PIPELINE CRM
  // ==========================================

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

          // ==========================================
          // SEARCH + FILTER
          // ==========================================
          AnimatedBuilder(
            animation: _crmController,
            builder: (context, child) {
              return CrmSearchPanel(crmController: _crmController);
            },
          ),

          const SizedBox(height: 14),

          // ==========================================
          // KANBAN TABS
          // ==========================================
          CrmKanbanTabs(
            tabData: _kanbanTabsData,
            selectedStatus: _selectedPipelineStatus,
            onTabChanged: (statusKey) {
              setState(() {
                _selectedPipelineStatus = statusKey;
              });
            },
          ),

          const SizedBox(height: 14),

          // ==========================================
          // BAGIAN INI PENTING
          //
          // AnimatedBuilder membuat Dashboard
          // rebuild setiap kali:
          //
          // search berubah
          // source berubah
          // type berubah
          //
          // ==========================================
          AnimatedBuilder(
            animation: _crmController,
            builder: (context, _) {
              return StreamBuilder<List<LeadModel>>(
                stream: _getLeadsStream(),
                builder: (context, snapshot) {
                  // ==========================================
                  // LOADING
                  // ==========================================

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  // ==========================================
                  // ERROR
                  // ==========================================

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Gagal memuat data: ${snapshot.error}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }

                  // ==========================================
                  // SEMUA DATA DARI SUPABASE
                  // ==========================================

                  final allLeads = snapshot.data ?? [];

                  // ==========================================
                  // FILTER DATA
                  // ==========================================

                  final searchQuery = _crmController.searchQuery
                      .toLowerCase()
                      .trim();

                  final selectedSource = _crmController.selectedSource;

                  final selectedType = _crmController.selectedType;

                  final filteredLeads = allLeads.where((lead) {
                    // ======================================
                    // 1. STATUS KANBAN
                    // ======================================

                    final matchStatus =
                        lead.status.toLowerCase() ==
                        _selectedPipelineStatus.toLowerCase();

                    // ======================================
                    // 2. SEARCH
                    // ======================================

                    bool matchSearch = true;

                    if (searchQuery.isNotEmpty) {
                      final namaMatch = lead.nama.toLowerCase().contains(
                        searchQuery,
                      );

                      final instansiMatch =
                          lead.instansi?.toLowerCase().contains(searchQuery) ??
                          false;

                      final catatanMatch =
                          lead.catatan?.toLowerCase().contains(searchQuery) ??
                          false;

                      final emailMatch =
                          lead.email?.toLowerCase().contains(searchQuery) ??
                          false;

                      final noHpMatch =
                          lead.noHp?.toLowerCase().contains(searchQuery) ??
                          false;

                      final lokasiMatch =
                          lead.lokasi?.toLowerCase().contains(searchQuery) ??
                          false;

                      final sumberMatch =
                          lead.sumberLeads?.toLowerCase().contains(
                            searchQuery,
                          ) ??
                          false;

                      final tipeMatch =
                          lead.tipeLead?.toLowerCase().contains(searchQuery) ??
                          false;

                      matchSearch =
                          namaMatch ||
                          instansiMatch ||
                          catatanMatch ||
                          emailMatch ||
                          noHpMatch ||
                          lokasiMatch ||
                          sumberMatch ||
                          tipeMatch;
                    }

                    // ======================================
                    // 3. FILTER SUMBER
                    // ======================================

                    bool matchSource = true;

                    if (selectedSource != 'Semua Sumber') {
                      matchSource =
                          lead.sumberLeads?.toLowerCase() ==
                          selectedSource.toLowerCase();
                    }

                    // ======================================
                    // 4. FILTER TIPE
                    // ======================================

                    bool matchType = true;

                    if (selectedType != 'Semua Tipe (Output)') {
                      matchType =
                          lead.tipeLead?.toLowerCase() ==
                          selectedType.toLowerCase();
                    }

                    // ======================================
                    // GABUNG SEMUA FILTER
                    // ======================================

                    return matchStatus &&
                        matchSearch &&
                        matchSource &&
                        matchType;
                  }).toList();

                  // ==========================================
                  // TIDAK ADA DATA
                  // ==========================================

                  if (filteredLeads.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            color: Colors.white.withOpacity(0.35),
                            size: 30,
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Tidak ada prospek ditemukan.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            searchQuery.isNotEmpty
                                ? 'Coba gunakan kata kunci lain.'
                                : 'Belum ada data pada filter ini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // ==========================================
                  // LIST HASIL FILTER
                  // ==========================================

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredLeads.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final lead = filteredLeads[index];

                      return CrmProspectCard(
                        leadData: lead,

                        // UPDATE STATUS
                        onStatusChange: (newStatus) {
                          _updateLeadStatus(lead.id, newStatus);
                        },

                        // EDIT
                        onEdit: () {},

                        // DELETE
                        onDelete: () {
                          _deleteLead(lead.id);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}