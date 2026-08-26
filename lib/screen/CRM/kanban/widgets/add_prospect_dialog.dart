import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import '../controllers/crm_controller.dart';

class AddProspectDialog {
  static void show(BuildContext context, CrmController crmController) {
    final nameController = TextEditingController();
    final instansiController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final cityController = TextEditingController();
    final paxController = TextEditingController();
    final nilaiDealController = TextEditingController();
    final notesController = TextEditingController();

    String selectedStatus = 'baru';
    String selectedSumberLeads = 'Manual Input';
    String selectedTipeLead = 'Jamaah (Individu)';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1735),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tambah Prospek Leads Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLabel('NAMA KONTAK (PROSPEK) *'),
                      _buildTextField(nameController, 'Contoh: H. Syarifudin'),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('INSTANSI / KBIH'),
                                _buildTextField(
                                  instansiController,
                                  'Contoh: Nurul Huda',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('NO. WHATSAPP / HP'),
                                _buildTextField(
                                  phoneController,
                                  '081234567890',
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('EMAIL KONTAK'),
                                _buildTextField(
                                  emailController,
                                  'syarif@gmail.com',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('KOTA / ALAMAT'),
                                _buildTextField(
                                  cityController,
                                  'Jakarta Timur',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Dropdown Sumber Leads
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('SUMBER LEADS'),
                                _buildDropdown(
                                  value: selectedSumberLeads,
                                  items: const [
                                    'Google Maps',
                                    'Social Media',
                                    'News Leads',
                                    'Manual Input',
                                  ],
                                  onChanged: (val) {
                                    if (val != null)
                                      setDialogState(
                                        () => selectedSumberLeads = val,
                                      );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Dropdown Tipe Lead
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('TIPE LEAD'),
                                _buildDropdown(
                                  value: selectedTipeLead,
                                  items: const [
                                    'Jamaah (Individu)',
                                    'Mitra / Agen',
                                    'B2B (Grup/Pengajian)',
                                  ],
                                  onChanged: (val) {
                                    if (val != null)
                                      setDialogState(
                                        () => selectedTipeLead = val,
                                      );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      _buildLabel('STATUS TAHAPAN CRM'),
                      _buildDropdown(
                        value: selectedStatus,
                        items: const {
                          'baru': 'Baru (Prospek Baru)',
                          'dihubungi': 'Dihubungi',
                          'prospek': 'Prospek Layak',
                          'selesai': 'Closed (WON)',
                        },
                        onChanged: (val) {
                          if (val != null)
                            setDialogState(() => selectedStatus = val);
                        },
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('JUMLAH PAX JAMAAH'),
                                _buildTextField(
                                  paxController,
                                  'Contoh: 20',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('POTENSI NILAI (IDR)'),
                                _buildTextField(
                                  nilaiDealController,
                                  '600000000',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      _buildLabel('CATATAN TAMBAHAN & FOLLOW UP'),
                      _buildTextField(
                        notesController,
                        'Masukkan kebutuhan khusus, catatan...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama kontak wajib diisi!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    // Panggil controller untuk menyimpan data
                    final success = await crmController.addLead(
                      nama: nameController.text.trim(),
                      instansi: instansiController.text.trim(),
                      email: emailController.text.trim(),
                      noHp: phoneController.text.trim(),
                      lokasi: cityController.text.trim(),
                      sumberLeads: selectedSumberLeads,
                      tipeLead: selectedTipeLead,
                      status: selectedStatus,
                      jumlahPax: int.tryParse(paxController.text.trim()) ?? 0,
                      potensiNilai:
                          double.tryParse(nilaiDealController.text.trim()) ??
                          0.0,
                      catatan: notesController.text.trim(),
                    );

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prospek berhasil ditambahkan!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menyimpan prospek!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Tambah Prospek',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
      ),
    );
  }

  static Widget _buildDropdown({
    required String value,
    required dynamic items,
    required ValueChanged<String?> onChanged,
  }) {
    Map<String, String> dropdownItems = items is List
        ? {for (var v in items) v: v}
        : items;

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2D234A),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 11),
          items: dropdownItems.entries.map((entry) {
            return DropdownMenuItem(value: entry.key, child: Text(entry.value));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
