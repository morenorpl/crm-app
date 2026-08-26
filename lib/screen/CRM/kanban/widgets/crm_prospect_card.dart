import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/screen/CRM/kanban/models/lead_model.dart';

class CrmProspectCard extends StatelessWidget {
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
            'Apakah Anda yakin ingin menghapus data prospek ${leadData.nama}? Data yang dihapus tidak dapat dikembalikan.',
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
                onDelete(); // Trigger the actual delete callback
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
    final nama = leadData.nama ?? 'Unknown';
    final noHp = leadData.noHp ?? '-';
    final lokasi = leadData.lokasi ?? '-';
    final instansi = leadData.instansi ?? 'Tidak ada instansi';
    final catatan = leadData.catatan ?? 'Tidak ada catatan...';

    // Fallbacks for tags
    final sumberLeads = leadData.sumberLeads ?? 'Manual Input';
    final tipeLead = leadData.tipeLead ?? 'Umum';
    final jumlahPax = leadData.jumlahPax != null
        ? '${leadData.jumlahPax} Pax'
        : '- Pax';
    final potensiNilaiFormatted = _formatCurrency(leadData.potensiNilai);

    return Container(
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
                // Edit Button
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
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
                      color: const Color(0xFFFF3B30).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFFF3B30).withOpacity(0.5),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
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
                border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
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
                  style: TextStyle(color: AppColors.textMuted, fontSize: 8.5),
                ),
                const SizedBox(width: 6),

                // Status Dropdown implemented as a PopupMenuButton to match your exact UI style
                PopupMenuButton<String>(
                  color: AppColors.searchPanelBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: onStatusChange,
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
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _getStatusText(
                            leadData.status,
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
    );
  }

  Widget _cardBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
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
