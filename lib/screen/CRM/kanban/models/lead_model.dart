class LeadModel {
  final int id;
  final String nama;
  final String? email;
  final String? noHp;
  final String? lokasi;
  final String status;
  // ... add other fields like instansi, jumlahPax, etc.

  LeadModel({
    required this.id,
    required this.nama,
    this.email,
    this.noHp,
    this.lokasi,
    required this.status,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'],
      noHp: map['no_hp'],
      lokasi: map['lokasi'],
      status: map['status'] ?? 'baru',
    );
  }
}
