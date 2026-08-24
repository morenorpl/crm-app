import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class CrmStatisticsGrid extends StatelessWidget {
  const CrmStatisticsGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
}
