class LeadModel {
  final int id;
  final String nama;
  final String email;
  final String noHp;
  final String lokasi;
  final String status;

  final String instansi;
  final String? sumberLeads;
  final String? tipeLead;
  final int? jumlahPax;
  final double? potensiNilai;
  final String? catatan;

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
    // ID SQLite / Supabase
    //
    // Kalau data berasal dari pending SQLite dan belum punya ID,
    // gunakan -1 sebagai ID lokal sementara.
    final dynamic rawId = map['id'];

    final int parsedId = rawId == null
        ? -1
        : int.tryParse(rawId.toString()) ?? -1;

    return LeadModel(
      id: parsedId,

      nama: map['nama']?.toString() ?? '',

      email: map['email']?.toString() ?? '',

      noHp: map['no_hp']?.toString() ?? '',

      lokasi: map['lokasi']?.toString() ?? '',

      status: map['status']?.toString() ?? 'baru',

      instansi: map['instansi']?.toString() ?? '',

      sumberLeads: map['sumber_leads']?.toString(),

      tipeLead: map['tipe_lead']?.toString(),

      jumlahPax: map['jumlah_pax'] != null
          ? int.tryParse(map['jumlah_pax'].toString())
          : null,

      potensiNilai: map['potensi_nilai'] != null
          ? double.tryParse(map['potensi_nilai'].toString())
          : null,

      catatan: map['catatan']?.toString(),

      jadwalFollowUp: map['jadwal_follow_up'] != null
          ? DateTime.tryParse(map['jadwal_follow_up'].toString())
          : null,
    );
  }

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
