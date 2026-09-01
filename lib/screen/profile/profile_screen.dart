import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String avatarLetter;

  const ProfileScreen({super.key, required this.avatarLetter});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'User';
  String _email = '-';
  String _phone = '-';
  bool _isLoading = true;

  // Track expanded state for FAQ items
  final List<bool> _faqExpanded = List.generate(6, (_) => false);

  // FAQ Data Source
  final List<Map<String, String>> _faqList = const [
    {
      'question': 'Bagaimana cara menambahkan prospek baru?',
      'answer':
          'Anda dapat pergi ke halaman Dashboard atau Pipeline, lalu klik tombol hijau bertuliskan "Tambah Prospek Baru". Isi form yang muncul lalu simpan.',
    },
    {
      'question': 'Bagaimana cara mengubah tahapan status CRM?',
      'answer':
          'Di halaman Pipeline Kanban, Anda bisa menggeser kartu prospek atau mengubah statusnya langsung melalui opsi edit/status change pada kartu prospek.',
    },
    {
      'question': 'Apa fungsi dari fitur Jadwal Follow Up?',
      'answer':
          'Fitur ini membantu Anda melacak tanggal penting kapan harus menghubungi kembali calon jamaah agar tidak terlewat.',
    },
    {
      'question': 'Bagaimana cara melihat laporan harian?',
      'answer':
          'Laporan harian terperinci dan grafik produktifitas dapat dipantau secara langsung melalui widget ringkasan di halaman utama Dashboard.',
    },
    {
      'question': 'Apakah data prospek tersinkronisasi otomatis?',
      'answer':
          'Ya, semua perubahan data baik penambahan, perubahan status, maupun penghapusan terhubung secara real-time dengan database Supabase.',
    },
    {
      'question': 'Bagaimana jika lupa atau ingin mengubah nomor HP?',
      'answer':
          'Informasi profil akun diambil langsung dari data registrasi sistem. Silakan hubungi administrator tim IT jika ada data profil yang perlu diperbarui.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final authUser = Supabase.instance.client.auth.currentUser;

      if (authUser != null) {
        debugPrint('🔍 [PROFILE] User Auth ID: ${authUser.id}');

        final response = await Supabase.instance.client
            .from('users')
            .select()
            .or('auth_id.eq.${authUser.id},email.eq.${authUser.email}')
            .maybeSingle();

        debugPrint('📦 [PROFILE] Data dari tabel users: $response');

        if (response != null) {
          final String fetchedName = (response['name'] ?? '').toString();
          final String fetchedEmail =
              (response['email'] ?? authUser.email ?? '-').toString();
          final String fetchedPhone = (response['no_tlp'] ?? '-').toString();

          setState(() {
            _username = fetchedName.trim().isNotEmpty
                ? fetchedName
                : (authUser.email?.split('@').first ?? 'User');
            _email = fetchedEmail.trim().isNotEmpty ? fetchedEmail : '-';
            _phone = (fetchedPhone.trim().isNotEmpty && fetchedPhone != 'null')
                ? fetchedPhone
                : '-';
            _isLoading = false;
          });
          return;
        }
      }

      if (authUser != null) {
        setState(() {
          _email = authUser.email ?? '-';
          _username = authUser.email?.contains('@') == true
              ? authUser.email!.split('@').first
              : 'User';
          _phone = '-';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('💥 [PROFILE ERROR] Gagal membaca tabel users: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initialLetter =
        _username.isNotEmpty ? _username[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  // Memberikan bottom padding 40dp agar berjarak aman dari bottom navigation bar
                  padding: const EdgeInsets.fromLTRB(19, 21, 19, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderBar(
                        title: 'Profile - Hi, $_username',
                        subtitle: 'Siap membuat konten berkah hari ini?',
                        avatarText: initialLetter,
                      ),
                      const SizedBox(height: 28),

                      // Profile Picture & Name Card
                      Center(
                        child: Column(
                          children: [
                            _buildProfilePhoto(initialLetter),
                            const SizedBox(height: 14),
                            Text(
                              _username.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Contact Details Clean Section
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Column(
                            children: [
                              _buildContact(
                                icon: Icons.phone_rounded,
                                text: _phone,
                              ),
                              const SizedBox(height: 12),
                              _buildContact(
                                icon: Icons.email_rounded,
                                text: _email,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ==================== FAQ SECTION ====================
                      const Text(
                        'FAQ (Pertanyaan Umum)',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Panduan cepat seputar penggunaan aplikasi CRM.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Loop FAQ Items
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _faqList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildFaqItem(
                            index: index,
                            question: _faqList[index]['question']!,
                            answer: _faqList[index]['answer']!,
                          );
                        },
                      ),

                      // Jarak tambahan khusus dari FAQ terakhir ke Bottom Bar
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfilePhoto(String initialLetter) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: Center(
        child: Text(
          initialLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Clean Contact Tile (Tanpa Kotak Abu-abu Pada Icon)
  Widget _buildContact({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Icon langsung tanpa wrapper Container kotak
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.85),
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // FAQ Dropdown Tile
  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final bool isExpanded = _faqExpanded[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: isExpanded ? 0.08 : 0.04,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: isExpanded ? 0.18 : 0.06,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _faqExpanded[index] = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: isExpanded
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withValues(
                          alpha: isExpanded ? 0.9 : 0.5,
                        ),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    answer,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}