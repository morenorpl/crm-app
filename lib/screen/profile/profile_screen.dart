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

  // Track expanded state for the 6 FAQ items
  final List<bool> _faqExpanded = [false, false, false, false, false, false];

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
    final String initialLetter = _username.isNotEmpty
        ? _username[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(19, 21, 19, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderBar(
                        title: 'Profile - Hi, $_username',
                        subtitle: 'Siap membuat konten berkah hari ini?',
                        avatarText: initialLetter,
                      ),
                      const SizedBox(height: 25),
                      Center(child: _buildProfilePhoto(initialLetter)),
                      const SizedBox(height: 14),
                      Center(
                        child: Text(
                          _username.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Contact details centered
                      Center(
                        child: Column(
                          children: [
                            _buildContact(icon: Icons.phone, text: _phone),
                            const SizedBox(height: 10),
                            _buildContact(
                              icon: Icons.email_outlined,
                              text: _email,
                              google: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),

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
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFaqItem(
                        index: 0,
                        question: 'Bagaimana cara menambahkan prospek baru?',
                        answer:
                            'Anda dapat pergi ke halaman Dashboard atau Pipeline, lalu klik tombol hijau bertuliskan "Tambah Prospek Baru". Isi form yang muncul lalu simpan.',
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        index: 1,
                        question: 'Bagaimana cara mengubah tahapan status CRM?',
                        answer:
                            'Di halaman Pipeline Kanban, Anda bisa menggeser kartu prospek atau mengubah statusnya langsung melalui opsi edit/status change pada kartu prospek.',
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        index: 2,
                        question: 'Apa fungsi dari fitur Jadwal Follow Up?',
                        answer:
                            'Fitur ini membantu Anda melacak tanggal penting kapan harus menghubungi kembali calon jamaah agar tidak terlewat.',
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        index: 3,
                        question: 'Bagaimana cara melihat laporan harian?',
                        answer:
                            'Laporan harian terperinci dan grafik produktifitas dapat dipantau secara langsung melalui widget ringkasan di halaman utama Dashboard.',
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        index: 4,
                        question:
                            'Apakah data prospek tersinkronisasi otomatis?',
                        answer:
                            'Ya, semua perubahan data baik penambahan, perubahan status, maupun penghapusan terhubung secara real-time dengan database Supabase.',
                      ),
                      const SizedBox(height: 8),
                      _buildFaqItem(
                        index: 5,
                        question:
                            'Bagaimana jika lupa atau ingin mengubah nomor HP?',
                        answer:
                            'Informasi profil akun diambil langsung dari data registrasi sistem. Silakan hubungi administrator tim IT jika ada data profil yang perlu diperbarui.',
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfilePhoto(String initialLetter) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          initialLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContact({
    required IconData icon,
    required String text,
    bool google = false,
  }) {
    return Container(
      width: 322,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(11),
            ),
            child: google
                ? const Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(icon, color: const Color(0xFF20152F), size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.muted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // FAQ Dropdown Row Widget
  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final bool isExpanded = _faqExpanded[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _faqExpanded[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isExpanded ? 0.09 : 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: isExpanded ? 0.2 : 0.08),
          ),
        ),
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
                      fontSize: 12,
                      fontWeight: isExpanded
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0, // Rotates arrow 180 degrees
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 10),
              Text(
                answer,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
