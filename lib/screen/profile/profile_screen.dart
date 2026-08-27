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

        // Query persis ke tabel 'users' berdasarkan kolom 'auth_id' atau 'email'
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .or('auth_id.eq.${authUser.id},email.eq.${authUser.email}')
            .maybeSingle();

        debugPrint('📦 [PROFILE] Data dari tabel users: $response');

        if (response != null) {
          // Mengambil field persis sesuai gambar tabel Supabase
          final String fetchedName = (response['name'] ?? '').toString();
          final String fetchedEmail = (response['email'] ?? authUser.email ?? '-').toString();
          final String fetchedPhone = (response['no_tlp'] ?? '-').toString();

          setState(() {
            _username = fetchedName.trim().isNotEmpty ? fetchedName : (authUser.email?.split('@').first ?? 'User');
            _email = fetchedEmail.trim().isNotEmpty ? fetchedEmail : '-';
            _phone = (fetchedPhone.trim().isNotEmpty && fetchedPhone != 'null') ? fetchedPhone : '-';
            _isLoading = false;
          });
          return;
        }
      }

      // Fallback jika tidak ditemukan data di tabel 'users'
      if (authUser != null) {
        setState(() {
          _email = authUser.email ?? '-';
          _username = authUser.email?.contains('@') == true ? authUser.email!.split('@').first : 'User';
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
    final String initialLetter = _username.isNotEmpty ? _username[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(19, 21, 19, 30),
                  child: Column(
                    children: [
                      HeaderBar(
                        title: 'Profile - Hi, $_username',
                        subtitle: 'Siap membuat konten berkah hari ini?',
                        avatarText: initialLetter,
                      ),
                      const SizedBox(height: 25),
                      _buildProfilePhoto(initialLetter),
                      const SizedBox(height: 14),
                      Text(
                        _username.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 63),
                      
                      // Menampilkan Nomor Telepon (kolom no_tlp)
                      _buildContact(icon: Icons.phone, text: _phone),
                      const SizedBox(height: 10),
                      
                      // Menampilkan Email (kolom email)
                      _buildContact(
                        icon: Icons.email_outlined,
                        text: _email,
                        google: true,
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
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.20), width: 1),
      ),
      child: Center(
        child: Text(
          initialLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
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
        color: Colors.white.withOpacity(0.12),
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
              color: Colors.white.withOpacity(0.75),
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
}