import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import '../controllers/crm_controller.dart';
import 'add_prospect_dialog.dart';

class CrmSearchPanel extends StatelessWidget {
  final CrmController crmController;

  const CrmSearchPanel({super.key, required this.crmController});

  // Opsi pilihan dropdown sumber leads
  final List<String> _sourceOptions = const [
    'Semua Sumber',
    'Google Maps',
    'Social Media',
    'News Leads',
  ];

  // Opsi pilihan dropdown tipe lead
  final List<String> _typeOptions = const [
    'Semua Tipe (Output)',
    'Jamaah (Individu)',
    'Mitra / Agen',
    'B2B (Grup/Pengajian)',
  ];

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
          // Input Search Aktif
          _searchInputField(
            icon: Icons.search,
            hintText: 'Cari prospek (nama, KBIH, catatan)...',
            onChanged: (value) {
              crmController.onSearchQueryChanged(value);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // 🔍 Dropdown Filter Sumber
              Expanded(
                child: _sourceDropdownField(),
              ),
              const SizedBox(width: 8),
              // 👥 Dropdown Filter Tipe Lead
              Expanded(
                child: _typeDropdownField(),
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

  // Widget Dropdown Filter Sumber
  Widget _sourceDropdownField() {
    final String currentValue =
        _sourceOptions.contains(crmController.selectedSource)
            ? crmController.selectedSource
            : 'Semua Sumber';

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: AppColors.searchPanelBg,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: AppColors.textLight,
          ),
          style: const TextStyle(color: AppColors.white, fontSize: 9.5),
          items: _sourceOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 12,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              crmController.onSourceFilterChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  // Widget Dropdown Filter Tipe Lead
  Widget _typeDropdownField() {
    final String currentValue =
        _typeOptions.contains(crmController.selectedType)
            ? crmController.selectedType
            : 'Semua Tipe (Output)';

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: AppColors.searchPanelBg,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: AppColors.textLight,
          ),
          style: const TextStyle(color: AppColors.white, fontSize: 9.5),
          items: _typeOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 12,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              crmController.onTypeFilterChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  // Widget TextField untuk Pencarian
  Widget _searchInputField({
    required IconData icon,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textLight),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.white, fontSize: 11),
              cursorColor: AppColors.white,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 9.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}