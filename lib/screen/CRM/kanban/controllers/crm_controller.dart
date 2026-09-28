import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lead_model.dart';
import '/config/api_config.dart';

class CrmController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool isLoading = false;
  List<LeadModel> leads = [];

  // ==========================================
  // FITUR PENCARIAN & FILTER
  // ==========================================

  String _searchQuery = '';
  String _selectedSource = 'Semua Sumber';
  String _selectedType = 'Semua Tipe (Output)';

  String get searchQuery => _searchQuery;
  String get selectedSource => _selectedSource;
  String get selectedType => _selectedType;

  void onSearchQueryChanged(String query) {
    _searchQuery = query.toLowerCase().trim();
    notifyListeners();
  }

  void onSourceFilterChanged(String source) {
    _selectedSource = source;
    notifyListeners();
  }

  void onTypeFilterChanged(String type) {
    _selectedType = type;
    notifyListeners();
  }

  List<LeadModel> get filteredLeads {
    return leads.where((lead) {
      bool matchesSearch = true;

      if (_searchQuery.isNotEmpty) {
        final nameMatch = lead.nama.toLowerCase().contains(_searchQuery);
        final instansiMatch =
            lead.instansi?.toLowerCase().contains(_searchQuery) ?? false;
        final catatanMatch =
            lead.catatan?.toLowerCase().contains(_searchQuery) ?? false;
        final emailMatch =
            lead.email?.toLowerCase().contains(_searchQuery) ?? false;
        final noHpMatch =
            lead.noHp?.toLowerCase().contains(_searchQuery) ?? false;
        final lokasiMatch =
            lead.lokasi?.toLowerCase().contains(_searchQuery) ?? false;
        final sumberMatch =
            lead.sumberLeads?.toLowerCase().contains(_searchQuery) ?? false;
        final tipeMatch =
            lead.tipeLead?.toLowerCase().contains(_searchQuery) ?? false;

        matchesSearch =
            nameMatch ||
            instansiMatch ||
            catatanMatch ||
            emailMatch ||
            noHpMatch ||
            lokasiMatch ||
            sumberMatch ||
            tipeMatch;
      }

      bool matchesSource = true;

      if (_selectedSource != 'Semua Sumber') {
        matchesSource =
            lead.sumberLeads?.toLowerCase() == _selectedSource.toLowerCase();
      }

      bool matchesType = true;

      if (_selectedType != 'Semua Tipe (Output)') {
        matchesType =
            lead.tipeLead?.toLowerCase() == _selectedType.toLowerCase();
      }

      return matchesSearch && matchesSource && matchesType;
    }).toList();
  }

  // ==========================================
  // FETCH LEADS (MENDUKUNG WEB & EMULATOR)
  // ==========================================

  Future<void> fetchLeads() async {
    isLoading = true;
    notifyListeners();

    try {
      final session = _supabase.auth.currentSession;

      if (session == null) {
        debugPrint('FETCH LEADS: User belum login');
        leads = [];
        return;
      }

      final accessToken = session.accessToken;

      // Menggunakan ApiConfig agar seragam
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/leads');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('STATUS FETCH LEADS: ${response.statusCode}');
      debugPrint('RESPONSE FETCH LEADS: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];

        if (data is List) {
          leads = data
              .map((item) => LeadModel.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        } else {
          leads = [];
        }
      } else {
        debugPrint('Gagal mengambil leads: ${response.body}');
        leads = [];
      }
    } catch (e) {
      debugPrint('Error fetching leads: $e');
      leads = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // TAMBAH LEAD (MENDUKUNG WEB & EMULATOR)
  // ==========================================

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
    String? jadwalFollowUp,
  }) async {
    try {
      final session = _supabase.auth.currentSession;

      if (session == null) {
        debugPrint('Gagal menyimpan lead: User belum login');
        return false;
      }

      final accessToken = session.accessToken;

      // Gunakan ApiConfig.baseUrl agar IP seragam
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/leads');

      final body = {
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
        'jadwal_follow_up': jadwalFollowUp,
      };

      // Menggunakan package http yang aman untuk Web & Mobile
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      debugPrint('STATUS CREATE LEAD: ${response.statusCode}');
      debugPrint('RESPONSE CREATE LEAD: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await fetchLeads(); // Refresh list setelah berhasil
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Gagal menyimpan lead: $e');
      return false;
    }
  }

  // ==========================================
  // UPDATE STATUS
  // ==========================================

  Future<void> updateLeadStatus(int id, String newStatus) async {
    try {
      await _supabase.from('leads').update({'status': newStatus}).eq('id', id);

      debugPrint('Status updated to $newStatus for lead ID: $id');

      await fetchLeads();
    } catch (e) {
      debugPrint('Error updating lead status: $e');
    }
  }

  // ==========================================
  // UPDATE JADWAL FOLLOW UP
  // ==========================================

  Future<void> updateLeadSchedule(int id, DateTime newDate) async {
    try {
      final formattedDate = newDate.toIso8601String();

      await _supabase
          .from('leads')
          .update({'jadwal_follow_up': formattedDate})
          .eq('id', id);

      debugPrint('Schedule updated to $formattedDate for lead ID: $id');

      await fetchLeads();
    } catch (e) {
      debugPrint('Error updating lead schedule: $e');
    }
  }

  // ==========================================
  // UPDATE LEAD
  // ==========================================

  Future<void> updateLead(int id, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('leads').update(updates).eq('id', id);

      debugPrint('Successfully updated lead ID: $id with data: $updates');

      await fetchLeads();
    } catch (e) {
      debugPrint('Error updating lead: $e');
    }
  }

  // ==========================================
  // DELETE LEAD
  // ==========================================

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
