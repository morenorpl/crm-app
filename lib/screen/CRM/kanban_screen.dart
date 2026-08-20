import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class CrmBoardScreen extends StatelessWidget {
  const CrmBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(), // Memanggil header yang berisi logo sejadah
                const SizedBox(height: 12),
                _buildBoardInfo(),
                const SizedBox(height: 12),
                _buildSearchPanel(),
                const SizedBox(height: 14),
                _buildStatistics(),
                const SizedBox(height: 14),
                _buildTabs(),
                const SizedBox(height: 14),
                _buildProspectCard(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Header Navigation Bar
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
          // Menggunakan logo dari folder assets kamu
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
                style: TextStyle(color: AppColors.textMuted, fontSize: 9),
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

  // 2. Banner Informasi Board
  Widget _buildBoardInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: AppColors.textMuted, size: 9),
                SizedBox(width: 4),
                Text(
                  'CRM Pipeline — Kanban Board',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 7.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.work_outline, color: AppColors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Mitra Retali Pipeline Board',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Kelola prospek calon jamaah umrah Anda dengan visualisasi Kanban board yang intuitif. Pindahkan kartu prospek antar kolom untuk memantau siklus konversi leads.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 9.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Search & Action Panel
  Widget _buildSearchPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.searchPanelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          _inputField(Icons.search, 'Cari prospek (nama, KBIH, catatan)...'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _inputField(Icons.filter_alt_outlined, 'Semua Sumber'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _inputField(Icons.people_outline, 'Semua Tipe (Output)'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 32,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  color: AppColors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Ekspor CSV',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 34,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.greenAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.white, size: 18),
                SizedBox(width: 4),
                Text(
                  'Tambah Prospek Baru',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(IconData icon, String hintText) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppColors.textLight),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              hintText,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 8.5),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Statistics Grid Cards
  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: [
        _statCard(
          Icons.group_outlined,
          'Total Prospek',
          '4',
          AppColors.cyanAccent,
        ),
        _statCard(
          Icons.auto_awesome,
          'Estimasi Total Pax',
          '115 Pax',
          AppColors.textLight,
        ),
        _statCard(
          Icons.attach_money,
          'Nilai Pipeline',
          'Rp. 3.38 Miliar',
          AppColors.yellowAccent,
        ),
        _statCard(
          Icons.check_circle_outline,
          'Deal Closed ( WON )',
          'Rp 750.0 Juta',
          AppColors.greenAccent,
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.searchPanelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: iconColor, width: 1),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: (iconColor == AppColors.textLight)
                        ? AppColors.white
                        : iconColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Kanban Stage Tabs
  Widget _buildTabs() {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.searchPanelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabItem('Prospek Baru (1)', false),
          _tabItem('Dihubungi (1)', false),
          _tabItem('Prospek Layak (1)', false),
          _tabItem('Closed (1)', true),
        ],
      ),
    );
  }

  Widget _tabItem(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: active
          ? BoxDecoration(
              color: AppColors.greenAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greenAccent, width: 1),
            )
          : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? AppColors.white : AppColors.textLight,
            fontSize: 8,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 6. Detailed Prospect Card
  Widget _buildProspectCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.prospectCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Ibu Hj. Aminah',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.textLight,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFFFF3B30).withOpacity(0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF5252),
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Row(
              children: [
                Icon(Icons.work_outline, color: AppColors.textMuted, size: 12),
                SizedBox(width: 6),
                Text(
                  'Mitra Travel',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _cardBadge('Manual Input', AppColors.yellowAccent),
                _cardBadge('Mitra', AppColors.greenAccent),
                _cardBadge('25 Pax', AppColors.greenAccent),
                _cardBadge('Rp 750.0 Juta', AppColors.yellowAccent),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.prospectNoteBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Text(
                '“Alhamdulillah closing! DP Rp 100 Juta sudah masuk untuk booking seat keberangkatan Maulid Nabi 25 pax.”',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 9.5,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(Icons.call_outlined, color: AppColors.textMuted, size: 12),
                SizedBox(width: 4),
                Text(
                  '085678901234',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                ),
                Spacer(),
                Text(
                  'Surabaya',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: AppColors.textLight,
                          size: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Hubungi via WhatsApp',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pindah ke :',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 8.5),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Closed',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textLight,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 7.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}