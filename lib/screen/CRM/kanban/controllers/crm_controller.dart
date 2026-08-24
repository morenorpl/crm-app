import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lead_model.dart'; // Sesuaikan path import model Anda

class CrmController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool isLoading = false;
  List<LeadModel> leads = [];

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
  }) async {
    try {
      await _supabase.from('leads').insert({
        'user_id': 1, // Sesuaikan dengan user ID aktif atau default Anda
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
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Refresh data setelah berhasil menambah
      await fetchLeads();
      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan lead: $e');
      return false;
    }
  }
}
