import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class CrmBoardInfo extends StatelessWidget {
  const CrmBoardInfo({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white.withValues(alpha: 0.12),
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
}
