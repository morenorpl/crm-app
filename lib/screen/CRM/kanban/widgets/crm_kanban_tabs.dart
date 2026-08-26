import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';

class CrmKanbanTabs extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onTabChanged;
  final Map<String, String> tabData;

  const CrmKanbanTabs({
    super.key,
    required this.selectedStatus,
    required this.onTabChanged,
    required this.tabData,
  });

  // Helper function to assign a unique accent color based on the status value
  Color _getStatusColor(String statusValue) {
    switch (statusValue) {
      case 'baru':
        return Colors.blueAccent; // Color for Prospek Baru
      case 'dihubungi':
        return AppColors.yellowAccent; // Color for Dihubungi
      case 'layak':
        return AppColors.greenAccent; // Color for Prospek Layak
      case 'closed':
        return Colors.purpleAccent; // Color for Closed
      default:
        return AppColors.greenAccent;
    }
  }

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
        children: tabData.entries.map((entry) {
          final isSelected = selectedStatus == entry.value;
          final tabColor = _getStatusColor(entry.value);

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(entry.value),
              child: _tabItem(entry.key, isSelected, tabColor),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tabItem(String text, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: active
          ? BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 1),
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
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
