class LeadModel {
  final int id;
  final String nama;
  final String email;
  final String noHp;
  final String lokasi;
  final String status;

  // Fields mapped from the Supabase table
  final String instansi;
  final String? sumberLeads;
  final String? tipeLead;
  final int? jumlahPax;
  final double? potensiNilai;
  final String? catatan;

  // 📅 New field untuk Jadwal Follow Up
  final DateTime? jadwalFollowUp;

  LeadModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.lokasi,
    required this.status,
    required this.instansi,
    this.sumberLeads,
    this.tipeLead,
    this.jumlahPax,
    this.potensiNilai,
    this.catatan,
    this.jadwalFollowUp,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      noHp: map['no_hp'] ?? '',
      lokasi: map['lokasi'] ?? '',
      status: map['status'] ?? 'baru',

      // Mapping snake_case DB columns to camelCase Dart variables
      instansi: map['instansi'],
      sumberLeads: map['sumber_leads'],
      tipeLead: map['tipe_lead'],

      // Safely parsing numbers in case they arrive as Strings or Ints from the DB
      jumlahPax: map['jumlah_pax'] != null
          ? int.tryParse(map['jumlah_pax'].toString())
          : null,
      potensiNilai: map['potensi_nilai'] != null
          ? double.tryParse(map['potensi_nilai'].toString())
          : null,

      catatan: map['catatan'],

      // 📅 Safely parsing DateTime dari kolom Supabase 'jadwal_follow_up'
      jadwalFollowUp: map['jadwal_follow_up'] != null
          ? DateTime.tryParse(map['jadwal_follow_up'].toString())
          : null,
    );
  }

  // Method toMap untuk kebutuhan serialisasi/insert ke Supabase jika diperlukan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      'lokasi': lokasi,
      'status': status,
      'instansi': instansi,
      'sumber_leads': sumberLeads,
      'tipe_lead': tipeLead,
      'jumlah_pax': jumlahPax,
      'potensi_nilai': potensiNilai,
      'catatan': catatan,
      'jadwal_follow_up': jadwalFollowUp?.toIso8601String(),
    };
  }
}
