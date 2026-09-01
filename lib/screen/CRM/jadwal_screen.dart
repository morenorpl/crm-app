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
  final DateTime? initialDate;

  const ScheduleScreen({
    super.key,
    required this.avatarLetter,
    this.initialDate,
  });

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
    final targetDate = widget.initialDate ?? DateTime.now();
    _selectedWeekStart = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    ).subtract(Duration(days: targetDate.weekday - 1));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrmController>(context, listen: false).fetchLeads();
    });
  }

  void _changeWeek(int days) {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(Duration(days: days));
    });
  }

  // Fungsi Helper untuk memformat angka jadi Rupiah
  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp 0';
    double val = double.tryParse(amount.toString()) ?? 0;

    if (val >= 1000000000) {
      return 'Rp ${(val / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (val >= 1000000) {
      return 'Rp ${(val / 1000000).toStringAsFixed(1)} Juta';
    }
    return 'Rp ${val.toStringAsFixed(0)}';
  }

  // Fungsi Helper untuk memformat tanggal jadi DD/MM/YYYY
  String _formatDateDDMMYYYY(DateTime? date) {
    if (date == null) return '-';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
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

    // Format phone number if needed (e.g., replace leading '0' with '62')
    String formattedPhone = phone;
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '62${formattedPhone.substring(1)}';
    }

    final Uri url = Uri.parse('https://wa.me/$formattedPhone');

    try {
      // Try launching directly with external application mode
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
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
                    title: 'Manajemen Schedule Project Leads',
                    subtitle: 'Jadwal follow-up prospek mingguan...',
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
    final now = DateTime.now();
    final currentWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final bool isCurrentWeek =
        _selectedWeekStart.year == currentWeekStart.year &&
        _selectedWeekStart.month == currentWeekStart.month &&
        _selectedWeekStart.day == currentWeekStart.day;

    return Row(
      children: [
        // Wrapper Kalender Picker
        Container(
          width: 210,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
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
        ),
        const SizedBox(width: 10),

        // Tombol Minggu Ini
        Expanded(
          child: GestureDetector(
            onTap: isCurrentWeek
                ? null
                : () {
                    setState(() {
                      _selectedWeekStart = currentWeekStart;
                    });
                  },
            child: Container(
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrentWeek
                    ? Colors.white.withValues(alpha: 0.02)
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrentWeek
                      ? AppColors.border.withValues(alpha: 0.3)
                      : AppColors.border,
                  width: 0.8,
                ),
              ),
              child: Text(
                'Minggu Ini',
                style: TextStyle(
                  color: isCurrentWeek
                      ? AppColors.muted.withValues(alpha: 0.5)
                      : AppColors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
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
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: empty
              ? AppColors.border.withValues(alpha: 0.3)
              : AppColors.green.withValues(alpha: 0.3),
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
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.2),
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
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.green.withValues(alpha: 0.15),
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
                      color: AppColors.green.withValues(alpha: 0.15),
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
                    color: AppColors.muted.withValues(alpha: 0.4),
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
                        child: _buildProspect(
                          context,
                          lead,
                        ), // Mem-pass context kesini
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProspect(BuildContext context, LeadModel lead) {
    final instansi = lead.instansi ?? 'Personal';
    final jumlahPax = lead.jumlahPax != null ? '${lead.jumlahPax} Pax' : '-';
    final potensiNilai = _formatCurrency(lead.potensiNilai);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10164A),
                  borderRadius: BorderRadius.circular(6),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.yellow.withValues(alpha: 0.6),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  lead.status.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lead.nama,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.business_center_outlined,
                color: AppColors.muted,
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  instansi,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.people_outline,
                color: AppColors.muted,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                jumlahPax,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.monetization_on_outlined,
                color: AppColors.green,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                potensiNilai,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                color: AppColors.muted,
                size: 13,
              ),
              const SizedBox(width: 6),
              Text(
                lead.noHp ?? '-',
                style: const TextStyle(color: AppColors.white, fontSize: 11),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              children: [
                // Tombol Hubungi WhatsApp diubah menjadi bentuk kapsul dalam row
                Expanded(
                  child: GestureDetector(
                    onTap: () => _launchWhatsApp(lead.noHp),
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Hubungi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Jadwal :',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 8.5),
                ),
                const SizedBox(width: 6),

                // Date Picker Button replacing the previous status dropdown
                GestureDetector(
                  onTap: () async {
                    final initialDateToOpen =
                        lead.jadwalFollowUp ?? DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDateToOpen,
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

                    // Jika user memilih tanggal baru
                    if (picked != null && picked != initialDateToOpen) {
                      // 1. Panggil controller untuk memperbarui database Supabase
                      await context.read<CrmController>().updateLeadSchedule(
                        lead.id,
                        picked,
                      );

                      // 2. Geser tampilan jadwal (`_selectedWeekStart`) ke minggu dari tanggal yang baru dipilih
                      setState(() {
                        _selectedWeekStart = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                        ).subtract(Duration(days: picked.weekday - 1));
                      });

                      // 3. Tampilkan Snackbar konfirmasi
                      if (context.mounted) {
                        final formattedNewDate = _formatDateDDMMYYYY(picked);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'leads ${lead.nama} telah dipindahkan ke jadwal $formattedNewDate',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: AppColors.card,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _formatDateDDMMYYYY(lead.jadwalFollowUp),
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.textLight,
                          size: 11,
                        ),
                      ],
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
}
