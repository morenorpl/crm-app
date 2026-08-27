import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';
import 'package:url_launcher/url_launcher.dart';

// 🛠️ IMPORT PATH ABSOLUT TERUPDATE
import 'package:crm_app/screen/CRM/kanban/controllers/crm_controller.dart';
import 'package:crm_app/screen/CRM/kanban/models/lead_model.dart';

class ScheduleScreen extends StatefulWidget {
  final String avatarLetter;

  const ScheduleScreen({super.key, required this.avatarLetter});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Tanggal acuan minggu (dimulai dari Senin minggu berjalan)
  late DateTime _selectedWeekStart;

  final List<String> _months = const [
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

  final List<String> _dayNames = const [
    'SENIN',
    'SELASA',
    'RABU',
    'KAMIS',
    'JUM’AT',
    'SABTU',
    'MINGGU',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrmController>(context, listen: false).fetchLeads();
    });
  }

  void _changeWeek(int days) {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(Duration(days: days));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.green,
              onPrimary: AppColors.white,
              surface: AppColors.card,
              onSurface: AppColors.white,
            ),
            dialogBackgroundColor: AppColors.background,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedWeekStart = picked.subtract(
          Duration(days: picked.weekday - 1),
        );
      });
    }
  }

  String _formatWeekRange(DateTime start) {
    final DateTime end = start.add(const Duration(days: 6));
    final String startStr = "${start.day} ${_months[start.month - 1]}";
    final String endStr = "${end.day} ${_months[end.month - 1]} ${end.year}";
    return '$startStr - $endStr';
  }

  Future<void> _launchWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final formattedPhone = phone.startsWith('0')
        ? '62${phone.substring(1)}'
        : phone;
    final Uri url = Uri.parse('https://wa.me/$formattedPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final crmController = Provider.of<CrmController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => crmController.fetchLeads(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(19, 16, 19, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderBar(
                    title: 'Dashboard CRM',
                    subtitle: 'Selamat datang kembali!',
                    avatarText: widget.avatarLetter,
                  ),
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 15),
                  _buildDateSelector(),
                  const SizedBox(height: 28),

                  if (crmController.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                        ),
                      ),
                    )
                  else
                    ...List.generate(7, (index) {
                      final DateTime currentDayDate = _selectedWeekStart.add(
                        Duration(days: index),
                      );
                      final String dayNumber = currentDayDate.day.toString();
                      final String dayName = _dayNames[index];

                      final dayLeads = crmController.leads.where((lead) {
                        if (lead.jadwalFollowUp == null) return false;
                        final followUpDate = lead.jadwalFollowUp!;
                        return followUpDate.year == currentDayDate.year &&
                            followUpDate.month == currentDayDate.month &&
                            followUpDate.day == currentDayDate.day;
                      }).toList();

                      return _buildDay(
                        day: dayNumber,
                        name: dayName,
                        prospects: dayLeads,
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.green, size: 20),
            const SizedBox(width: 7),
            const Text(
              'Manajemen Projects Leads',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Jadwal follow-up prospek mingguan berdasarkan tipe (Jama’ah, Mitra, B2B).',
          style: TextStyle(color: AppColors.muted, fontSize: 10, height: 1.35),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      width: 210,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35),
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.white,
              size: 18,
            ),
            onPressed: () => _changeWeek(-7),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  _formatWeekRange(_selectedWeekStart),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35),
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.white,
              size: 18,
            ),
            onPressed: () => _changeWeek(7),
          ),
        ],
      ),
    );
  }

  Widget _buildDay({
    required String day,
    required String name,
    required List<LeadModel> prospects,
  }) {
    final bool empty = prospects.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: empty
              ? AppColors.border.withOpacity(0.3)
              : AppColors.green.withOpacity(0.3),
          width: 0.9,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Sleek Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withOpacity(0.2),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: empty
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: empty ? Colors.transparent : AppColors.green,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: empty ? AppColors.white : AppColors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (!empty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${prospects.length} Leads',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content section
          if (empty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    color: AppColors.muted.withOpacity(0.4),
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tidak ada leads dengan jadwal follow-up',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: prospects
                    .map(
                      (lead) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildProspect(lead),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProspect(LeadModel lead) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Tag Tipe Lead
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3.5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF10164A),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  lead.tipeLead ?? 'Jamaah',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // Badge Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3.5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.yellow, width: 0.8),
                ),
                child: Text(
                  lead.status,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Nama Kontak
          Text(
            lead.nama,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          // No HP
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                color: AppColors.muted,
                size: 13,
              ),
              const SizedBox(width: 7),
              Text(
                lead.noHp ?? '-',
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 11),
          // Tombol Action Follow Up (WhatsApp Launcher)
          GestureDetector(
            onTap: () => _launchWhatsApp(lead.noHp),
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1437),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF5B467A), width: 0.8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.muted,
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Follow Up via WhatsApp',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
