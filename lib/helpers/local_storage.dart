import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pending_leads.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Naikkan versi database ke 3 agar tabel lama didrop dan diganti dengan struktur baru
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS pending_leads');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE pending_leads (
      local_id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT,
      instansi TEXT,
      email TEXT,
      no_hp TEXT,
      lokasi TEXT,
      sumber_leads TEXT,
      tipe_lead TEXT,
      status TEXT,
      jumlah_pax INTEGER,
      potensi_nilai REAL,
      catatan TEXT,
      jadwal_follow_up TEXT,
      tanggal TEXT
    )
    ''');
  }

  Future<int> insertPendingLead(Map<String, dynamic> lead) async {
    final db = await instance.database;

    // Mapping data agar aman dari error tipe data SQLite
    final safeData = {
      'nama': lead['nama']?.toString(),
      'instansi': lead['instansi']?.toString(),
      'email': lead['email']?.toString(),
      'no_hp': lead['no_hp']?.toString(),
      'lokasi': lead['lokasi']?.toString(),
      'sumber_leads': lead['sumber_leads']?.toString(),
      'tipe_lead': lead['tipe_lead']?.toString(),
      'status': lead['status']?.toString(),
      'jumlah_pax': int.tryParse(lead['jumlah_pax']?.toString() ?? '0') ?? 0,
      'potensi_nilai':
          double.tryParse(lead['potensi_nilai']?.toString() ?? '0.0') ?? 0.0,
      'catatan': lead['catatan']?.toString(),
      'jadwal_follow_up': lead['jadwal_follow_up']?.toString(),
      'tanggal': lead['tanggal']?.toString(),
    };

    return await db.insert('pending_leads', safeData);
  }

  Future<List<Map<String, dynamic>>> getPendingLeads() async {
    final db = await instance.database;
    return await db.query('pending_leads');
  }

  Future<int> deletePendingLead(int id) async {
    final db = await instance.database;
    return await db.delete(
      'pending_leads',
      where: 'local_id = ?',
      whereArgs: [id],
    );
  }
}
