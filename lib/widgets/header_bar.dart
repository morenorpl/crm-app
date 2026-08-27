import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_app/constants/app_colors.dart';

class HeaderBar extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? avatarText;
  final String assetLogoPath; // Optional path for logo asset

  const HeaderBar({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarText,
    this.assetLogoPath = 'assets/images/Logo-sejadah.png',
  });

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  String _avatarLetter = 'U'; // Default fallback letter for "User"

  @override
  void initState() {
    super.initState();
    _loadUserAvatarData();
  }

  Future<void> _loadUserAvatarData() async {
    final prefs = await SharedPreferences.getInstance();
    // Get stored username, fallback to 'User' if it doesn't exist
    final username = prefs.getString('username') ?? 'User';

    if (username.isNotEmpty) {
      setState(() {
        // Take the first letter of the username and make it uppercase
        _avatarLetter = username[0].toUpperCase();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          // 1. Logo Asset on the left
          Image.asset(widget.assetLogoPath, height: 32, fit: BoxFit.contain),
          const SizedBox(width: 10),

          // 2. Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 3. Avatar with PopupMenuButton & Custom Logout Button
          PopupMenuButton<String>(
            offset: const Offset(0, 35),
            color: const Color(0xFF2C2245),
            constraints: const BoxConstraints(minWidth: 160),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                await Supabase.instance.client.auth.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Wipes cached credentials/username
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.purpleAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                _avatarLetter, // Uses the dynamically loaded letter
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
