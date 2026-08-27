import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lead_model.dart';

class CrmController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool isLoading = false;
  List<LeadModel> leads = [];

  // ==========================================
  // FITUR PENCARIAN (SEARCH) & FILTER
  // ==========================================
  String _searchQuery = '';
  String _selectedSource = 'Semua Sumber';
  String _selectedType = 'Semua Tipe (Output)'; // State filter Tipe Lead

  String get searchQuery => _searchQuery;
  String get selectedSource => _selectedSource;
  String get selectedType => _selectedType;

  /// Memproses perubahan kata kunci dari CrmSearchPanel
  void onSearchQueryChanged(String query) {
    _searchQuery = query.toLowerCase().trim();
    notifyListeners();
  }

  /// Memproses perubahan filter sumber leads dari CrmSearchPanel
  void onSourceFilterChanged(String source) {
    _selectedSource = source;
    notifyListeners();
  }

  /// Memproses perubahan filter tipe lead dari CrmSearchPanel
  void onTypeFilterChanged(String type) {
    _selectedType = type;
    notifyListeners();
  }

  /// Getter untuk mengambil data yang sudah difilter (Search + Sumber + Tipe)
  List<LeadModel> get filteredLeads {
    return leads.where((lead) {
      // 1. Logika Filter Pencarian Teks
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final nameMatch = lead.nama.toLowerCase().contains(_searchQuery);
        final instansiMatch = lead.instansi?.toLowerCase().contains(_searchQuery) ?? false;
        final catatanMatch = lead.catatan?.toLowerCase().contains(_searchQuery) ?? false;
        final emailMatch = lead.email?.toLowerCase().contains(_searchQuery) ?? false;
        final noHpMatch = lead.noHp?.toLowerCase().contains(_searchQuery) ?? false;
        final lokasiMatch = lead.lokasi?.toLowerCase().contains(_searchQuery) ?? false;
        final sumberMatch = lead.sumberLeads?.toLowerCase().contains(_searchQuery) ?? false;
        final tipeMatch = lead.tipeLead?.toLowerCase().contains(_searchQuery) ?? false;

        matchesSearch = nameMatch ||
            instansiMatch ||
            catatanMatch ||
            emailMatch ||
            noHpMatch ||
            lokasiMatch ||
            sumberMatch ||
            tipeMatch;
      }

      // 2. Logika Filter Dropdown Sumber
      bool matchesSource = true;
      if (_selectedSource != 'Semua Sumber') {
        matchesSource = (lead.sumberLeads?.toLowerCase() == _selectedSource.toLowerCase());
      }

      // 3. Logika Filter Dropdown Tipe Lead
      bool matchesType = true;
      if (_selectedType != 'Semua Tipe (Output)') {
        matchesType = (lead.tipeLead?.toLowerCase() == _selectedType.toLowerCase());
      }

      // Menggabungkan ketiga kriteria filter
      return matchesSearch && matchesSource && matchesType;
    }).toList();
  }

  // ==========================================
  // OPERASI SUPABASE
  // ==========================================

  // 1. Fetch / Ambil data leads dari Supabase
  Future<void> fetchLeads() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('leads')
          .select()
          .order('created_at', ascending: false);

      leads = (response as List)
          .map((item) => LeadModel.fromMap(item))
          .toList();
    } catch (e) {
      debugPrint('Error fetching leads: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. Tambah Prospek Baru ke Supabase
  Future<bool> addLead({
    required String nama,
    required String instansi,
    required String email,
    required String noHp,
    required String lokasi,
    required String sumberLeads,
    required String tipeLead,
    required String status,
    required int jumlahPax,
    required double potensiNilai,
    required String catatan,
    String? jadwalFollowUp, // 👈 PARAMETER BARU DITAMBAHKAN (Nullable)
  }) async {
    try {
      await _supabase.from('leads').insert({
        'user_id': 1,
        'nama': nama,
        'instansi': instansi,
        'email': email,
        'no_hp': noHp,
        'lokasi': lokasi,
        'sumber_leads': sumberLeads,
        'tipe_lead': tipeLead,
        'status': status,
        'jumlah_pax': jumlahPax,
        'potensi_nilai': potensiNilai,
        'catatan': catatan,
        'jadwal_follow_up': jadwalFollowUp, // 👈 MAPPING DITAMBAHKAN
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await fetchLeads();
      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan lead: $e');
      return false;
    }
  }

  /// Updates the status category of a lead in Supabase
  Future<void> updateLeadStatus(int id, String newStatus) async {
    try {
      await _supabase
          .from('leads')
          .update({'status': newStatus})
          .eq('id', id);

      debugPrint('Status updated to $newStatus for lead ID: $id');
      await fetchLeads();
    } catch (e) {
      debugPrint('Error updating lead status: $e');
    }
  }

  /// Updates multiple fields of a lead in Supabase
  Future<void> updateLead(int id, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('leads').update(updates).eq('id', id);

      debugPrint('Successfully updated lead ID: $id with data: $updates');
      await fetchLeads();
    } catch (e) {
      debugPrint('Error updating lead: $e');
    }
  }

  /// Deletes a lead from Supabase
  Future<void> deleteLead(int id) async {
    try {
      await _supabase.from('leads').delete().eq('id', id);

      debugPrint('Successfully deleted lead ID: $id');
      await fetchLeads();
    } catch (e) {
      debugPrint('Error deleting lead: $e');
    }
  }
}