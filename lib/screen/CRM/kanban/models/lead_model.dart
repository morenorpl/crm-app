class LeadModel {
  final int id;
  final String nama;
  final String? email;
  final String? noHp;
  final String? lokasi;
  final String status;

  // New fields mapped from the Supabase table
  final String? instansi;
  final String? sumberLeads;
  final String? tipeLead;
  final int? jumlahPax;
  final double? potensiNilai;
  final String? catatan;

  LeadModel({
    required this.id,
    required this.nama,
    this.email,
    this.noHp,
    this.lokasi,
    required this.status,
    this.instansi,
    this.sumberLeads,
    this.tipeLead,
    this.jumlahPax,
    this.potensiNilai,
    this.catatan,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'],
      noHp: map['no_hp'],
      lokasi: map['lokasi'],
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
    );
  }
}
