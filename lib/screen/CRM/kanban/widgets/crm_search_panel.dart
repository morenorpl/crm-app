import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import '../controllers/crm_controller.dart';
import 'add_prospect_dialog.dart';

class CrmSearchPanel extends StatelessWidget {
  final CrmController crmController;

  const CrmSearchPanel({super.key, required this.crmController});

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: () => AddProspectDialog.show(context, crmController),
            child: Container(
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
}
