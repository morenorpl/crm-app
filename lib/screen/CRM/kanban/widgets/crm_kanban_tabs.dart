import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class CrmKanbanTabs extends StatelessWidget {
  const CrmKanbanTabs({super.key});

  @override
  Widget build(BuildContext context) {
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
}
