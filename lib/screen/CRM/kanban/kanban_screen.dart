import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';
import 'controllers/crm_controller.dart';
import 'widgets/crm_board_info.dart';
import 'widgets/crm_search_panel.dart';
import 'widgets/crm_statistics_grid.dart';
import 'widgets/crm_kanban_tabs.dart';
import 'widgets/crm_prospect_card.dart';
import 'package:crm_app/screen/CRM/kanban/models/lead_model.dart';

class CrmBoardScreen extends StatefulWidget {
  final String avatarLetter;

  const CrmBoardScreen({super.key, required this.avatarLetter});

  @override
  State<CrmBoardScreen> createState() => _CrmBoardScreenState();
}

class _CrmBoardScreenState extends State<CrmBoardScreen> {
  late final CrmController _crmController;

  // Track the active tab status. Defaulting to 'baru' as seen in the DB.
  String _activeStatus = 'baru';

  // Map your tab UI text to the exact string used in your database 'status' column
  final Map<String, String> _tabCategories = {
    'Prospek Baru': 'baru',
    'Dihubungi': 'dihubungi',
    'Prospek Layak': 'layak',
    'Closed': 'closed',
  };

  @override
  void initState() {
    super.initState();
    _crmController = CrmController();
    _crmController.fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // ListenableBuilder mendengarkan notifyListeners() dari _crmController
        child: ListenableBuilder(
          listenable: _crmController,
          builder: (context, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderBar(
                      title: 'Manajemen CRM Project Leads',
                      subtitle: 'Data tahap CRM prospek-prospek Sejadah...',
                    ),
                    const SizedBox(height: 12),
                    const CrmBoardInfo(),
                    const SizedBox(height: 12),
                    CrmSearchPanel(crmController: _crmController),
                    const SizedBox(height: 14),
                    const CrmStatisticsGrid(),
                    const SizedBox(height: 14),

                    // 1. Pass the state and callback to the Tabs
                    CrmKanbanTabs(
                      selectedStatus: _activeStatus,
                      tabData: _tabCategories,
                      onTabChanged: (newStatus) {
                        setState(() {
                          _activeStatus = newStatus;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    // 2. Filter and display the lists using filteredLeads
                    _buildFilteredProspects(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilteredProspects() {
    // 🔍 MENGGUNAKAN filteredLeads BUKAN leads
    final allFilteredLeads = _crmController.filteredLeads;

    // Memfilter data yang sudah dicari berdasarkan tab kategori aktif
    final filteredLeads = allFilteredLeads
        .where((lead) => lead.status == _activeStatus)
        .toList();

    if (filteredLeads.isEmpty) {
      String activeTabName = _tabCategories.entries
          .firstWhere(
            (entry) => entry.value == _activeStatus,
            orElse: () => const MapEntry('Layak', 'baru'),
          )
          .key;

      final isSearching = _crmController.searchQuery.isNotEmpty;

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            isSearching
                ? 'Tidak ditemukan prospek dengan nama "${_crmController.searchQuery}" di kategori "$activeTabName"'
                : 'belum ada prospek di kategori "$activeTabName"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    // Map the filtered leads to Prospect Cards
    return Column(
      children: filteredLeads.map((leadData) {
        return CrmProspectCard(
          leadData: leadData,
          onEdit: () {
            _showEditProspectDialog(context, leadData);
          },
          onDelete: () async {
            await _crmController.deleteLead(leadData.id);
          },
          onStatusChange: (newStatus) async {
            if (leadData.status == newStatus) return;

            await _crmController.updateLeadStatus(leadData.id, newStatus);
          },
        );
      }).toList(),
    );
  }

  void _showEditProspectDialog(BuildContext context, LeadModel lead) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return _EditProspectDialog(
          lead: lead,
          onSave: (updatedData) async {
            await _crmController.updateLead(lead.id, updatedData);
          },
        );
      },
    );
  }
}

class _EditProspectDialog extends StatefulWidget {
  final LeadModel lead;
  final Function(Map<String, dynamic>) onSave;

  const _EditProspectDialog({required this.lead, required this.onSave});

  @override
  State<_EditProspectDialog> createState() => _EditProspectDialogState();
}

class _EditProspectDialogState extends State<_EditProspectDialog> {
  late TextEditingController _namaCtrl;
  late TextEditingController _instansiCtrl;
  late TextEditingController _noHpCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _lokasiCtrl;
  late TextEditingController _jumlahPaxCtrl;
  late TextEditingController _potensiNilaiCtrl;
  late TextEditingController _catatanCtrl;

  String _sumberLeads = 'Manual Input';
  String _tipeLead = 'Umum';
  DateTime? _selectedJadwal;

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.lead.nama);
    _instansiCtrl = TextEditingController(text: widget.lead.instansi);
    _noHpCtrl = TextEditingController(text: widget.lead.noHp);
    _emailCtrl = TextEditingController(text: widget.lead.email);
    _lokasiCtrl = TextEditingController(text: widget.lead.lokasi);
    _jumlahPaxCtrl = TextEditingController(
      text: widget.lead.jumlahPax?.toString() ?? '',
    );

    double? val = widget.lead.potensiNilai;
    String initialPotensi = val != null ? val.toInt().toString() : '';
    _potensiNilaiCtrl = TextEditingController(text: initialPotensi);

    _catatanCtrl = TextEditingController(text: widget.lead.catatan);

    _sumberLeads = widget.lead.sumberLeads ?? 'Manual Input';
    _tipeLead = widget.lead.tipeLead ?? 'Jamaah (Individu)';

    // 👈 2. Inisialisasi tanggal dari data lead yang ada
    _selectedJadwal = widget.lead.jadwalFollowUp;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _instansiCtrl.dispose();
    _noHpCtrl.dispose();
    _emailCtrl.dispose();
    _lokasiCtrl.dispose();
    _jumlahPaxCtrl.dispose();
    _potensiNilaiCtrl.dispose();
    _catatanCtrl.dispose();
    super.dispose();
  }

  // 👈 3. Helper untuk format tanggal ke DD/MM/YYYY
  String _formatDateDDMMYYYY(DateTime? date) {
    if (date == null) return 'Pilih Tanggal Follow-Up (Opsional)';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  void _handleSave() {
    final updates = {
      'nama': _namaCtrl.text,
      'instansi': _instansiCtrl.text.isNotEmpty ? _instansiCtrl.text : null,
      'no_hp': _noHpCtrl.text,
      'email': _emailCtrl.text.isNotEmpty ? _emailCtrl.text : null,
      'lokasi': _lokasiCtrl.text,
      'sumber_leads': _sumberLeads,
      'tipe_lead': _tipeLead,
      'jumlah_pax': int.tryParse(_jumlahPaxCtrl.text),
      'potensi_nilai': double.tryParse(_potensiNilaiCtrl.text),
      'catatan': _catatanCtrl.text.isNotEmpty ? _catatanCtrl.text : null,
      // 👈 4. Masukkan ke dalam map updates sebagai ISO8601 string atau null
      'jadwal_follow_up': _selectedJadwal?.toIso8601String(),
    };

    widget.onSave(updates);
    Navigator.pop(context);
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    TextInputType? kbd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: kbd,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    final safeValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              dropdownColor: AppColors.searchPanelBg,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textMuted,
                size: 16,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: items.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.searchPanelBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Prospek',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField(
                'NAMA KONTAK (PROSPEK) *',
                _namaCtrl,
                hint: 'Contoh: H. Syarifudin',
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'INSTANSI / KBIH',
                      _instansiCtrl,
                      hint: 'Contoh: Nurul Huda',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'NO. WHATSAPP / HP',
                      _noHpCtrl,
                      hint: '081234567890',
                      kbd: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'EMAIL KONTAK',
                      _emailCtrl,
                      hint: 'syarif@gmail.com',
                      kbd: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'KOTA / ALAMAT',
                      _lokasiCtrl,
                      hint: 'Jakarta Timur',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown('SUMBER LEADS', _sumberLeads, [
                      'Manual Input',
                      'Social Media',
                      'News Leads',
                    ], (val) => setState(() => _sumberLeads = val!)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown('TIPE LEAD', _tipeLead, [
                      'Jamaah (Individu)',
                      'Mitra / Agen',
                      'Umum',
                    ], (val) => setState(() => _tipeLead = val!)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'JUMLAH PAX JAMAAH',
                      _jumlahPaxCtrl,
                      hint: 'Contoh: 20',
                      kbd: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'POTENSI NILAI (IDR)',
                      _potensiNilaiCtrl,
                      hint: '600000000',
                      kbd: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('JADWAL FOLLOW-UP'),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedJadwal ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.greenAccent,
                                onPrimary: Colors.black,
                                surface: AppColors.searchPanelBg,
                                onSurface: Colors.white,
                              ),
                              dialogBackgroundColor: AppColors.searchPanelBg,
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          _selectedJadwal = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDateDDMMYYYY(_selectedJadwal),
                            style: TextStyle(
                              color: _selectedJadwal == null
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              // Tampilkan tombol 'X' jika tanggal sudah dipilih agar bisa dihapus
                              if (_selectedJadwal != null) ...[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedJadwal = null; // Reset jadi null
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              const Icon(
                                Icons.calendar_month,
                                color: AppColors.textMuted,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _buildTextField(
                'CATATAN TAMBAHAN & FOLLOW UP',
                _catatanCtrl,
                hint: 'Masukkan kebutuhan khusus, catatan...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _handleSave,
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
