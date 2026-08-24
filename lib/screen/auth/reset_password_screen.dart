// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_assets.dart';
import '../../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final resetId = args is String ? args : '';

    final password = passwordController.text;
    final confirm = confirmController.text;

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password wajib diisi"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password minimal 6 karakter"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password tidak sama"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await AuthService.resetPassword(resetId, password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password berhasil diubah"),
          backgroundColor: Color(0xFF32C770),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
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

                // --- Top Logo Graphic ---
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
                const SizedBox(height: 12),

                // --- Header Title ---
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
                const SizedBox(height: 8),

                // --- Subtitle ---
                const Center(
                  child: Text(
                    'Buat Password Baru',
                    style: TextStyle(
                      color: Color(0xFFAC6BFF),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- NEW PASSWORD INPUT ---
                const Text(
                  'PASSWORD BARU',
                  style: TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF61547D).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF7B6C9B)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF948AAB),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan password baru',
                            hintStyle: TextStyle(color: Color(0xFF948AAB)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF948AAB),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- CONFIRM PASSWORD INPUT ---
                const Text(
                  'KONFIRMASI PASSWORD',
                  style: TextStyle(
                    color: Color(0xFFA197B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF61547D).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF7B6C9B)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.lock_reset_rounded,
                        color: Color(0xFF948AAB),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: confirmController,
                          obscureText: obscureConfirm,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Ulangi password baru',
                            hintStyle: TextStyle(color: Color(0xFF948AAB)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF948AAB),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- PRIMARY SUBMIT BUTTON ---
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
                  onPressed: loading ? null : resetPassword,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Ubah Password',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 32),

                // --- Divider ---
                const Divider(color: Color(0xFF4A3E63), thickness: 1),
                const SizedBox(height: 24),

                // --- Footer Text ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Platform Retali mempermudahkan leads, pembuatan konten, dan pelanggan anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA197B4),
                      fontSize: 11,
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
