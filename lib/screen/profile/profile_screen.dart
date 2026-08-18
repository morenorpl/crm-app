import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color background = Color(0xFF261943);
  static const Color white = Color(0xFFF7F3FA);
  static const Color muted = Color(0xFFAAA0B5);
  static const Color border = Color(0xFF8A7B94);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(19, 21, 19, 30),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildProfilePhoto(),
                const SizedBox(height: 14),
                const Text(
                  'OWO GANTENG',
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 63),
                _buildContact(
                  icon: Icons.phone,
                  text: '+62 81345678910',
                ),
                const SizedBox(height: 10),
                _buildContact(
                  icon: Icons.email_outlined,
                  text: 'Wowi@gmail.com',
                  google: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.chevron_left,
            color: white,
            size: 22,
          ),
          const SizedBox(width: 3),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile - Hi, Woo',
                style: TextStyle(
                  color: white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Siap membuat konten berkah hari ini?',
                style: TextStyle(
                  color: muted,
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 24,
            width: 77,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B3B),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.person_outline,
        color: Colors.white24,
        size: 85,
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
        border: Border.all(
          color: border,
          width: 0.8,
        ),
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
                : Icon(
                    icon,
                    color: const Color(0xFF20152F),
                    size: 21,
                  ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: muted,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: muted,
            ),
          ),
        ],
      ),
    );
  }
}