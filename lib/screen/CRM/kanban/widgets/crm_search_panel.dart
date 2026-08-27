import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:file_saver/file_saver.dart';
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

  // Fungsi Ekspor Data ke Excel (.xlsx) dengan Otomatis Lebar Kolom (Auto-Fit)
  Future<void> _exportExcel(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mengunduh data Excel dari Supabase...'),
          duration: Duration(seconds: 1),
        ),
      );

      // 1. Fetch data dari tabel 'leads' Supabase
      final response = await Supabase.instance.client
          .from('leads')
          .select();

      final dataList = response as List<dynamic>;

      if (dataList.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada data leads untuk diekspor.')),
          );
        }
        return;
      }

      // 2. Buat dokumen Excel baru
      var excel = excel_lib.Excel.createExcel();
      excel_lib.Sheet sheetObject = excel['Data Leads'];
      excel.setDefaultSheet('Data Leads');

      // 3. Header sesuai kolom di Supabase
      List<String> headers = [
        'ID',
        'User ID',
        'Nama',
        'Email',
        'No HP',
        'Lokasi',
        'Status',
        'Created At',
        'Updated At',
        'Instansi',
        'Sumber Leads',
        'Tipe Lead',
        'Jadwal Follow Up',
        'Jumlah Pax',
        'Potensi Nilai',
        'Catatan',
        'Tanggal',
      ];

      // Array untuk menyimpan panjang maksimum tiap kolom (untuk auto-width)
      List<int> colLengths = headers.map((h) => h.length).toList();

      // Masukkan header ke baris pertama Excel
      sheetObject.appendRow(headers.map((e) => excel_lib.TextCellValue(e)).toList());

      // 4. Masukkan isi data per baris & hitung panjang string maksimum
      for (var item in dataList) {
        List<String> values = [
          '${item['id'] ?? ''}',
          '${item['user_id'] ?? ''}',
          '${item['nama'] ?? ''}',
          '${item['email'] ?? ''}',
          '${item['no_hp'] ?? ''}',
          '${item['lokasi'] ?? ''}',
          '${item['status'] ?? ''}',
          '${item['created_at'] ?? ''}',
          '${item['updated_at'] ?? ''}',
          '${item['instansi'] ?? ''}',
          '${item['sumber_leads'] ?? ''}',
          '${item['tipe_lead'] ?? ''}',
          '${item['jadwal_follow_up'] ?? ''}',
          '${item['jumlah_pax'] ?? ''}',
          '${item['potensi_nilai'] ?? ''}',
          '${item['catatan'] ?? ''}',
          '${item['tanggal'] ?? ''}',
        ];

        // Update panjang maksimum per kolom jika isi teksnya lebih panjang
        for (int i = 0; i < values.length; i++) {
          if (values[i].length > colLengths[i]) {
            colLengths[i] = values[i].length;
          }
        }

        sheetObject.appendRow(values.map((v) => excel_lib.TextCellValue(v)).toList());
      }

      // 5. ATUR LEBAR KOLOM OTOMATIS (AUTO-FIT)
      // Menambahkan padding spasi ekstra (+3) agar teks tidak mepet dengan batas garis
      for (int i = 0; i < colLengths.length; i++) {
        double calculatedWidth = (colLengths[i] + 4).toDouble();
        // Batas minimal lebar 12, maksimal 40 agar kolom catatan tidak terlalu melebar
        double finalWidth = calculatedWidth.clamp(12.0, 40.0);
        sheetObject.setColumnWidth(i, finalWidth);
      }

      // 6. Encode ke bytes
      List<int>? fileBytes = excel.save();

      if (fileBytes != null) {
        Uint8List bytes = Uint8List.fromList(fileBytes);

        // 7. Simpan file sebagai .xlsx
        await FileSaver.instance.saveFile(
          name: 'data_leads_${DateTime.now().millisecondsSinceEpoch}',
          bytes: bytes,
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil mengunduh Excel rapi (Auto-Fit)!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal ekspor Excel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              Expanded(
                child: _sourceDropdownField(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _typeDropdownField(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _exportExcel(context),
            child: Container(
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
                    'Ekspor Excel (.xlsx)',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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