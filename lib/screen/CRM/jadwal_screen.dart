import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  static const Color background = Color(0xFF261943);
  static const Color white = Color(0xFFF7F3FA);
  static const Color muted = Color(0xFFAAA0B5);
  static const Color border = Color(0xFF81718F);
  static const Color green = Color(0xFF00D084);
  static const Color blue = Color(0xFF6577FF);
  static const Color yellow = Color(0xFFFFC400);
  static const Color card = Color(0xFF271642);
  static const Color header = Color(0xFF665579);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(19, 16, 19, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 15),
                _buildDateSelector(),
                const SizedBox(height: 38),
                _buildDay(
                  day: '10',
                  name: 'SENIN',
                  prospects: const [],
                ),
                _buildDay(
                  day: '11',
                  name: 'SELASA',
                  prospects: const [
                    'Ibu Hj. Aminah',
                  ],
                ),
                _buildDay(
                  day: '12',
                  name: 'RABU',
                  prospects: const [
                    'Ibu Hj. Aminah',
                    'Ibu Hj. Aminah',
                  ],
                ),
                _buildDay(
                  day: '13',
                  name: 'KAMIS',
                  prospects: const [
                    'Ibu Hj. Aminah',
                  ],
                ),
                _buildDay(
                  day: '14',
                  name: 'JUM’AT',
                  prospects: const [],
                ),
                _buildDay(
                  day: '15',
                  name: 'SABTU',
                  prospects: const [],
                ),
                _buildDay(
                  day: '16',
                  name: 'MINGGU',
                  prospects: const [],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: green,
            size: 19,
          ),
          const SizedBox(width: 9),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CRM System - Jadwal Follow Up',
                style: TextStyle(
                  color: white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Siap membuat konten berkah hari ini?',
                style: TextStyle(
                  color: muted,
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFB63BDB),
              shape: BoxShape.circle,
            ),
            child: const Text(
              'k',
              style: TextStyle(
                color: white,
                fontSize: 12,
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
            const Icon(
              Icons.calendar_month,
              color: green,
              size: 20,
            ),
            const SizedBox(width: 7),
            const Text(
              'Manajemen projects Leads',
              style: TextStyle(
                color: white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Jadwal follow-up prospek mingguan berdasarkan tipe (Jama’ah, Mitra,\nB2B).',
          style: TextStyle(
            color: muted,
            fontSize: 9,
            height: 1.35,
          ),
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
        border: Border.all(
          color: border,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 35,
            child: Icon(
              Icons.chevron_left,
              color: white,
              size: 17,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '10 Agu - 16 Agu 2026',
                style: TextStyle(
                  color: white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 35,
            child: Icon(
              Icons.chevron_right,
              color: white,
              size: 17,
            ),
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
          color: border.withOpacity(0.65),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              color: header.withOpacity(0.9),
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
                    color: white,
                    fontSize: 25,
                    height: 0.95,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: white,
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
                    color: muted,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                15,
                14,
                14,
              ),
              child: Column(
                children: prospects
                    .map(
                      (name) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
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
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        12,
      ),
      decoration: BoxDecoration(
        color: card,
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
                    color: blue,
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
                  border: Border.all(
                    color: yellow,
                    width: 0.8,
                  ),
                ),
                child: const Text(
                  'Contacted',
                  style: TextStyle(
                    color: yellow,
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
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                color: muted,
                size: 13,
              ),
              const SizedBox(width: 8),
              const Text(
                '085678901234',
                style: TextStyle(
                  color: muted,
                  fontSize: 8,
                ),
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
              border: Border.all(
                color: const Color(0xFF5B467A),
                width: 0.8,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: muted,
                  size: 13,
                ),
                SizedBox(width: 6),
                Text(
                  'Follow Up',
                  style: TextStyle(
                    color: muted,
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

  Widget _buildBottomBar() {
    return Container(
      height: 67,
      color: background,
      child: SafeArea(
        top: false,
        child: Center(
          child: Container(
            width: 255,
            height: 49,
            decoration: BoxDecoration(
              color: const Color(0xFF5B4C6D),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(
                  Icons.home_outlined,
                  'Home',
                  false,
                ),
                _navItem(
                  Icons.grid_view_rounded,
                  'Pipeline',
                  false,
                ),
                _navItem(
                  Icons.calendar_month_outlined,
                  'Schedule',
                  true,
                ),
                _navItem(
                  Icons.person_outline,
                  'Profile',
                  false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool active,
  ) {
    return SizedBox(
      width: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 19,
            color: active ? white : muted,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? white : muted,
              fontSize: 6.5,
              fontWeight:
                  active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}