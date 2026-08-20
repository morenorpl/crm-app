// ignore_for_file: deprecated_member_use

import 'package:crm_app/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/screen/dashboard/dashboard_screen.dart';
import 'package:crm_app/constants/app_assets.dart';
import 'package:crm_app/services/auth_service.dart'; // Import your AuthService
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan isi semua bidang form')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call Supabase register function
      final AuthResponse result = await AuthService.register(
        name,
        email,
        password,
      );

      print('Register Result User ID: ${result.user?.id}');

      // --- Save user details to SharedPreferences ---
      // Note: Supabase automatically caches the session securely,
      // but you can keep this if you use SharedPreferences for local UI state.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', name);
      await prefs.setString('email', email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil!'),
          backgroundColor: Color(0xFF32C770),
        ),
      );

      // Navigate to Dashboard after successful registration
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    } on AuthException catch (e) {
      // Specifically catch Supabase authentication errors (e.g., email already exists)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;

      // General error catch
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF564C6E), Color(0xFF1E1735)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // --- Top Logo Section ---
                Center(
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset(
                      AppAssets.sejadahLogo,
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // App Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Retali Platform',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF32C770),
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // --- Nama Lengkap Input ---
                const Text(
                  'NAMA LENGKAP',
                  style: TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Abdullah',
                    hintStyle: const TextStyle(color: Color(0xFF948AAB)),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF948AAB),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF61547D).withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7B6C9B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF32C770),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Email Input ---
                const Text(
                  'EMAIL AKUN',
                  style: TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'mitra@gmail.com',
                    hintStyle: const TextStyle(color: Color(0xFF948AAB)),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF948AAB),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF61547D).withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7B6C9B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF32C770),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Password Input ---
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: const TextStyle(color: Color(0xFF948AAB)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF948AAB),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF61547D).withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7B6C9B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF32C770),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- Register Button ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32C770),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 24),

                // --- Login Link ---
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Sudah punya akun? Masuk disini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF32C770),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Divider with "ATAU" ---
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: Color(0xFF4A3E63), thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'ATAU',
                        style: TextStyle(
                          color: Color(0xFFA197B4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Color(0xFF4A3E63), thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Google Sign-In Button ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: const Text(
                          'G',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // --- Footer Text ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Platform Retali mempermudahkan leads, pembuatan konten, dan pelanggan anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA197B4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
