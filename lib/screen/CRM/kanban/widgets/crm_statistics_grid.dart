import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl untuk format rupiah

class CrmStatisticsGrid extends StatelessWidget {
  const CrmStatisticsGrid({super.key});

  // Fungsi untuk mengambil dan menghitung data dari Supabase
  Future<Map<String, dynamic>> _fetchStatistics() async {
    final response = await Supabase.instance.client
        .from('leads') // Ganti dengan nama tabel kamu jika berbeda
        .select('status, jumlah_pax, potensi_nilai');

    final data = response as List<dynamic>;

    int totalProspek = data.length;
    int totalPax = 0;
    double nilaiPipeline = 0;
    double dealClosed = 0;

    for (var item in data) {
      // Hitung Total Pax
      totalPax += (item['jumlah_pax'] as num? ?? 0).toInt();

      final nilai = (item['potensi_nilai'] as num? ?? 0).toDouble();
      nilaiPipeline += nilai;

      // Hitung Deal Closed jika status 'closed'
      if (item['status']?.toString().toLowerCase() == 'closed') {
        dealClosed += nilai;
      }
    }

    return {
      'totalProspek': totalProspek.toString(),
      'totalPax': '$totalPax Pax',
      'nilaiPipeline': _formatRupiah(nilaiPipeline),
      'dealClosed': _formatRupiah(dealClosed),
    };
  }

  // Helper untuk format angka ke Rupiah ringkas (Juta / Miliar)
  String _formatRupiah(double value) {
    if (value >= 1000000000) {
      return 'Rp ${(value / 1000000000).toStringAsFixed(2)} Miliar';
    } else if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(1)} Juta';
    } else {
      return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat statistik', style: TextStyle(color: Colors.red)));
        }

        final stats = snapshot.data ?? {
          'totalProspek': '0',
          'totalPax': '0 Pax',
          'nilaiPipeline': 'Rp 0',
          'dealClosed': 'Rp 0',
        };

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
              stats['totalProspek']!,
              AppColors.cyanAccent,
            ),
            _statCard(
              Icons.auto_awesome,
              'Estimasi Total Pax',
              stats['totalPax']!,
              AppColors.textLight,
            ),
            _statCard(
              Icons.attach_money,
              'Nilai Pipeline',
              stats['nilaiPipeline']!,
              AppColors.yellowAccent,
            ),
            _statCard(
              Icons.check_circle_outline,
              'Deal Closed ( WON )',
              stats['dealClosed']!,
              AppColors.greenAccent,
            ),
          ],
        );
      },
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
}