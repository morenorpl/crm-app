import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            // Bottom padding ditingkatkan menjadi 80 agar tidak tertutup bottom bar
            padding: const EdgeInsets.fromLTRB(19, 16, 19, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 15),
                _buildDateSelector(),
                const SizedBox(height: 38),
                _buildDay(day: '10', name: 'SENIN', prospects: const []),
                _buildDay(
                  day: '11',
                  name: 'SELASA',
                  prospects: const ['Ibu Hj. Aminah'],
                ),
                _buildDay(
                  day: '12',
                  name: 'RABU',
                  prospects: const ['Ibu Hj. Aminah', 'Ibu Hj. Aminah'],
                ),
                _buildDay(
                  day: '13',
                  name: 'KAMIS',
                  prospects: const ['Ibu Hj. Aminah'],
                ),
                _buildDay(day: '14', name: 'JUM’AT', prospects: const []),
                _buildDay(day: '15', name: 'SABTU', prospects: const []),
                _buildDay(day: '16', name: 'MINGGU', prospects: const []),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          Image.asset(
            'assets/images/Logo-sejadah.png',
            height: 32,
            fit: BoxFit.contain,
          ),
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

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.green, size: 20),
            const SizedBox(width: 7),
            const Text(
              'Manajemen projects Leads',
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
          'Jadwal follow-up prospek mingguan berdasarkan tipe (Jama’ah, Mitra,\nB2B).',
          style: TextStyle(color: AppColors.muted, fontSize: 9, height: 1.35),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      width: 183,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 35,
            child: Icon(Icons.chevron_left, color: AppColors.white, size: 17),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '10 Agu - 16 Agu 2026',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 35,
            child: Icon(Icons.chevron_right, color: AppColors.white, size: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildDay({
    required String day,
    required String name,
    required List<String> prospects,
  }) {
    final bool empty = prospects.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppColors.border.withOpacity(0.65),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 4, bottom: 5),
            decoration: BoxDecoration(
              color: AppColors.header.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (empty)
            const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Kosong',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 14, 14),
              child: Column(
                children: prospects
                    .map(
                      (name) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildProspect(name),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProspect(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 19,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF10164A),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'Jamaah',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 65,
                height: 19,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: AppColors.yellow, width: 0.8),
                ),
                child: const Text(
                  'Contacted',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                color: AppColors.muted,
                size: 13,
              ),
              const SizedBox(width: 8),
              const Text(
                '085678901234',
                style: TextStyle(color: AppColors.muted, fontSize: 8),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            height: 27,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1437),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: const Color(0xFF5B467A), width: 0.8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.muted,
                  size: 13,
                ),
                SizedBox(width: 6),
                Text(
                  'Follow Up',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
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