import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/screen/CRM/kanban/models/lead_model.dart';
import 'package:crm_app/screen/CRM/jadwal_screen.dart';
import 'package:crm_app/screen/layout/main_layout_screen.dart';

class CrmProspectCard extends StatefulWidget {
  final LeadModel leadData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String) onStatusChange;

  const CrmProspectCard({
    super.key,
    required this.leadData,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  State<CrmProspectCard> createState() => _CrmProspectCardState();
}

class _CrmProspectCardState extends State<CrmProspectCard> {
  bool _showWarning = false;

  // Helper function to format currency nicely (e.g., to "Rp 1.5 Miliar" or "Rp 750.0 Juta")
  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp 0';
    double val = double.tryParse(amount.toString()) ?? 0;

    if (val >= 1000000000) {
      return 'Rp ${(val / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (val >= 1000000) {
      return 'Rp ${(val / 1000000).toStringAsFixed(1)} Juta';
    }

    return 'Rp ${val.toStringAsFixed(0)}';
  }

  // Helper to format date into DD/MM/YYYY
  String _formatDateDDMMYYYY(DateTime? date) {
    if (date == null) return 'Pilih Tanggal Follow-Up (Opsional)';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  // Helper to map DB status to Human Readable UI text
  String _getStatusText(String? status) {
    switch (status) {
      case 'baru':
        return 'Prospek Baru';
      case 'dihubungi':
        return 'Dihubungi';
      case 'layak':
        return 'Prospek Layak';
      case 'closed':
        return 'Closed';
      default:
        return 'Prospek Baru';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.searchPanelBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus data prospek ${widget.leadData.nama}? Data yang dihapus tidak dapat dikembalikan.',
            style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                widget.onDelete(); // Trigger the actual delete callback
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safely extract data from model with fallbacks for NULL database values
    final nama = widget.leadData.nama ?? 'Unknown';
    final noHp = widget.leadData.noHp ?? '-';
    final lokasi = widget.leadData.lokasi ?? '-';
    final instansi = widget.leadData.instansi ?? 'Tidak ada instansi';
    final catatan = widget.leadData.catatan ?? 'Tidak ada catatan...';

    // Fallbacks for tags
    final sumberLeads = widget.leadData.sumberLeads ?? 'Manual Input';
    final tipeLead = widget.leadData.tipeLead ?? 'Umum';
    final jumlahPax = widget.leadData.jumlahPax != null
        ? '${widget.leadData.jumlahPax} Pax'
        : '- Pax';
    final potensiNilaiFormatted = _formatCurrency(widget.leadData.potensiNilai);

    final bool hasSchedule = widget.leadData.jadwalFollowUp != null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.prospectCardBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        nama,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Ke Jadwal Follow Up Button
                    GestureDetector(
                      onTap: () {
                        if (hasSchedule) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainLayoutScreen(
                                initialIndex: 2,
                                initialScheduleDate:
                                    widget.leadData.jadwalFollowUp,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            _showWarning = true;
                          });

                          // Auto hide after 2.5 seconds with fade out capability
                          Future.delayed(
                            const Duration(milliseconds: 2200),
                            () {
                              if (mounted) {
                                setState(() {
                                  _showWarning = false;
                                });
                              }
                            },
                          );
                        }
                      },
                      child: Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: hasSchedule
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: hasSchedule
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.transparent,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'Ke Jadwal',
                          style: TextStyle(
                            color: hasSchedule
                                ? AppColors.textLight
                                : AppColors.textMuted.withValues(alpha: 0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Edit Button
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textLight,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Delete Button
                    GestureDetector(
                      onTap: () => _showDeleteConfirmation(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(
                              0xFFFF3B30,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFFF5252),
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      color: AppColors.textMuted,
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      instansi,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _cardBadge(sumberLeads, AppColors.purpleAccent),
                    _cardBadge(tipeLead, AppColors.cyanAccent),
                    _cardBadge(jumlahPax, AppColors.yellowAccent),
                    _cardBadge(potensiNilaiFormatted, AppColors.greenAccent),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.prospectNoteBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    '“$catatan”',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 9.5,
                      fontStyle: FontStyle.italic,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.call_outlined,
                      color: AppColors.textMuted,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      noHp,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      lokasi,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: AppColors.textLight,
                              size: 12,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hubungi via WhatsApp',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Pindah ke :',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 8.5,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Status Dropdown implemented as a PopupMenuButton to match your exact UI style
                    PopupMenuButton<String>(
                      color: AppColors.searchPanelBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: widget.onStatusChange,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'baru',
                          child: Text(
                            'Prospek Baru',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'dihubungi',
                          child: Text(
                            'Dihubungi',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'layak',
                          child: Text(
                            'Prospek Layak',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'closed',
                          child: Text(
                            'Closed',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _getStatusText(
                                widget.leadData.status,
                              ), // Shows current category
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textLight,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Warning Tooltip with Fade Transition
        Positioned(
          top: 42,
          right: 85,
          child: AnimatedOpacity(
            opacity: _showWarning ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_showWarning,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.searchPanelBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'tidak ada jadwal follow up untuk leads ini',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 7.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
