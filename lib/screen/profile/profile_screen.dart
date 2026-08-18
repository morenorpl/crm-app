import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'User';
  String _email = 'email@example.com';
  String _phone = '+62 81345678910';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _email = prefs.getString('email') ?? 'email@example.com';
      _phone = prefs.getString('phone') ?? '+62 81345678910';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(19, 21, 19, 30),
            child: Column(
              children: [
                HeaderBar(
                  title: 'Profile - Hi, $_username',
                  subtitle: 'Siap membuat konten berkah hari ini?',
                  avatarText: _username.isNotEmpty
                      ? _username[0].toUpperCase()
                      : 'U',
                ),
                const SizedBox(height: 25),
                _buildProfilePhoto(),
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
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.20), width: 1),
      ),
      child: const Icon(Icons.person_outline, color: Colors.white24, size: 85),
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
