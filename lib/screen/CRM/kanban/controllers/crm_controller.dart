import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/lead_model.dart';
import '/config/api_config.dart';
import '/helpers/local_storage.dart';

class CrmController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool isLoading = false;
  List<LeadModel> leads = [];

  // ==========================================
  // USER, PROFILE & TEAM FILTER
  // ==========================================

  int? currentUserId;
  String? currentUserRole;
  String selectedTeamFilter = 'Kinerja Ku Saja';

  bool isAddingLead = false;

  // ==========================================
  // SYNC LOCK
  // ==========================================

  static bool _isSyncing = false;

  // ==========================================
  // CONSTRUCTOR
  // ==========================================

  CrmController() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        debugPrint('Koneksi kembali! Memulai sinkronisasi data tertunda...');

        syncPendingLeads();
      }
    });
  }

  // ==========================================
  // USER PROFILE
  // ==========================================

  Future<void> fetchUserProfile() async {
    final user = _supabase.auth.currentUser;

    if (user != null && user.email != null) {
      try {
        final response = await _supabase
            .from('users')
            .select('id, role')
            .eq('email', user.email!)
            .single();

        currentUserId = response['id'];
        currentUserRole = response['role'];

        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching user profile: $e');
      }
    }
  }

  void onTeamFilterChanged(String filter) {
    selectedTeamFilter = filter;
    notifyListeners();
  }

  // ==========================================
  // GET ACCESS TOKEN
  // ==========================================

  Future<String?> _getAccessToken() async {
    var session = _supabase.auth.currentSession;

    if (session == null) {
      debugPrint('Token tidak ditemukan: session null');
      return null;
    }

    // Coba refresh kalau token sudah expired
    if (session.isExpired) {
      try {
        debugPrint('Access token expired. Refreshing session...');

        final response = await _supabase.auth.refreshSession();

        session = response.session;

        if (session == null) {
          debugPrint('Gagal refresh session.');
          return null;
        }

        debugPrint('Session berhasil di-refresh.');
      } catch (e) {
        debugPrint('Gagal refresh session: $e');
        return null;
      }
    }

    return session.accessToken;
  }

  // ==========================================
  // HTTP POST LEAD
  // ==========================================

  Future<http.Response?> _postLead(Map<String, dynamic> data) async {
    String? accessToken = await _getAccessToken();

    if (accessToken == null) {
      debugPrint('Tidak ada access token.');
      return null;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/api/leads');

    try {
      debugPrint('POST LEAD → $uri');

      http.Response response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      // ==========================================
      // TOKEN EXPIRED / INVALID
      // ==========================================

      if (response.statusCode == 401) {
        debugPrint('Token ditolak server. Mencoba refresh session...');

        try {
          final refreshResponse = await _supabase.auth.refreshSession();

          final newSession = refreshResponse.session;

          if (newSession == null) {
            debugPrint('Session baru tidak tersedia.');
            return response;
          }

          final newToken = newSession.accessToken;

          response = await http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $newToken',
                },
                body: jsonEncode(data),
              )
              .timeout(const Duration(seconds: 15));

          debugPrint('Retry POST LEAD status: ${response.statusCode}');
        } catch (e) {
          debugPrint('Gagal refresh token: $e');
        }
      }

      return response;
    } catch (e) {
      debugPrint('HTTP POST LEAD ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // SYNC PENDING LEADS
  // ==========================================

  Future<void> syncPendingLeads() async {
    if (_isSyncing) {
      debugPrint('Sinkronisasi sudah berjalan, mengabaikan panggilan ganda.');
      return;
    }
    _isSyncing = true;

    try {
      final pendingLeads = await DatabaseHelper.instance.getPendingLeads();
      if (pendingLeads.isEmpty) {
        _isSyncing = false;
        return;
      }

      final session = _supabase.auth.currentSession;
      if (session == null) {
        _isSyncing = false;
        return;
      }

      final accessToken = session.accessToken;
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/leads');

      // Kirim data satu per satu ke server
      for (var leadMap in pendingLeads) {
        final Map<String, dynamic> dataToSend = Map.from(leadMap);

        // 1. Ambil dan hapus 'local_id' dari payload agar tidak dikirim ke server backend
        final localId = dataToSend.remove('local_id');

        // (Opsional) Hapus juga 'tanggal' jika backend Express Anda tidak membutuhkannya
        // dataToSend.remove('tanggal');

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint('Berhasil sync lead offline: ${leadMap['nama']}');

          // 2. HAPUS DARI SQLITE HANYA JIKA SUKSES TERKIRIM
          if (localId != null) {
            await DatabaseHelper.instance.deletePendingLead(localId as int);
            debugPrint('Data ${leadMap['nama']} berhasil dihapus dari SQLite.');
          }
        } else {
          debugPrint('Gagal sync lead ${leadMap['nama']}: ${response.body}');
          // Karena gagal, data biarkan saja di SQLite untuk dicoba lagi nanti
        }
      }

      // Refresh ulang data setelah selesai sync
      await fetchLeads();
    } catch (e) {
      debugPrint('Error saat sinkronisasi: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // ==========================================
  // SEARCH & FILTER
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

  // ==========================================
  // LEADS STREAM
  // ==========================================

  Stream<List<LeadModel>> getLeadsStream() {
    return _supabase
        .from('leads')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          var filteredData = data;

          if (selectedTeamFilter == 'Kinerja Ku Saja' ||
              currentUserRole != 'admin') {
            filteredData = filteredData
                .where((json) => json['user_id'] == currentUserId)
                .toList();
          }

          return filteredData.map((json) => LeadModel.fromMap(json)).toList();
        });
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
  // FETCH LEADS
  // ==========================================

  Future<void> fetchLeads() async {
    isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _getAccessToken();

      if (accessToken == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/leads');

      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('STATUS FETCH LEADS: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        final List<dynamic> leadsJson = data['data'] ?? [];

        leads = leadsJson.map((json) => LeadModel.fromMap(json)).toList();

        debugPrint('Berhasil fetch ${leads.length} leads dari server.');
      } else {
        await _fetchLeadsFromSQLite();
      }
    } catch (e) {
      debugPrint('Gagal fetch ke server, menggunakan SQLite: $e');

      await _fetchLeadsFromSQLite();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchLeadsFromSQLite() async {
    final pendingLeads = await DatabaseHelper.instance.getPendingLeads();

    leads = pendingLeads.map((map) => LeadModel.fromMap(map)).toList();

    debugPrint('Memuat ${leads.length} leads dari SQLite lokal.');
  }

  // ==========================================
  // ADD LEAD
  // ==========================================

  Future<String> addLead({
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
    if (isAddingLead) {
      return 'loading';
    }

    isAddingLead = true;

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

    try {
      // ==========================================
      // CEK DUPLIKAT
      // ==========================================

      final pending = await DatabaseHelper.instance.getPendingLeads();

      final isDuplicate = pending.any(
        (l) => l['nama'] == nama && l['no_hp'] == noHp,
      );

      if (isDuplicate) {
        debugPrint('Data duplikat ditemukan di SQLite.');

        return 'duplicate';
      }

      // ==========================================
      // CEK INTERNET
      // ==========================================

      final connectivityResult = await Connectivity().checkConnectivity();

      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        debugPrint('OFFLINE → menyimpan lead ke SQLite.');

        await DatabaseHelper.instance.insertPendingLead(body);

        await fetchLeads();

        return 'offline';
      }

      // ==========================================
      // ONLINE → EXPRESS
      // ==========================================

      debugPrint('MENCOBA MENYIMPAN KE SERVER...');

      final response = await _postLead(body);

      // ==========================================
      // SERVER BERHASIL
      // ==========================================

      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        debugPrint('LEAD BERHASIL DISIMPAN KE SERVER.');

        await fetchLeads();

        return 'success';
      }

      // ==========================================
      // SERVER MENOLAK REQUEST
      // ==========================================

      if (response != null) {
        debugPrint(
          'SERVER MENOLAK REQUEST: '
          '${response.statusCode}',
        );

        debugPrint('SERVER RESPONSE: ${response.body}');

        // Kalau 401, jangan langsung dianggap offline.
        if (response.statusCode == 401) {
          debugPrint('Token tidak valid / session expired.');

          return 'unauthorized';
        }
      }

      // ==========================================
      // FALLBACK SQLITE
      // ==========================================

      debugPrint('Server gagal → menyimpan lead ke SQLite.');

      await DatabaseHelper.instance.insertPendingLead(body);

      await fetchLeads();

      return 'offline';
    } catch (e) {
      debugPrint('Gagal ke Server, fallback menyimpan ke SQLite: $e');

      // ==========================================
      // FALLBACK SQLITE
      // ==========================================

      try {
        await DatabaseHelper.instance.insertPendingLead(body);

        await fetchLeads();
      } catch (dbError) {
        debugPrint('Gagal menyimpan ke SQLite: $dbError');

        return 'error';
      }

      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('TimeoutException')) {
        return 'server_down';
      }

      return 'offline';
    } finally {
      isAddingLead = false;
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
  // UPDATE FOLLOW UP
  // ==========================================

  Future<void> updateLeadSchedule(int id, DateTime newDate) async {
    try {
      final formattedDate = newDate.toIso8601String();

      await _supabase
          .from('leads')
          .update({'jadwal_follow_up': formattedDate})
          .eq('id', id);

      debugPrint(
        'Schedule updated to $formattedDate '
        'for lead ID: $id',
      );

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

      debugPrint(
        'Successfully updated lead ID: $id '
        'with data: $updates',
      );

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

  // ==========================================
  // PRODUCTIVITY STREAM
  // ==========================================

  Stream<List<Map<String, dynamic>>> getProductivityLeadsStream() {
    return _supabase.from('leads').stream(primaryKey: ['id']).map((data) {
      var filteredData = data;

      if (selectedTeamFilter == 'Kinerja Ku Saja' ||
          currentUserRole != 'admin') {
        filteredData = filteredData
            .where((json) => json['user_id'] == currentUserId)
            .toList();
      }

      return filteredData
          .map((json) => Map<String, dynamic>.from(json))
          .toList();
    });
  }
}
