// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email wajib diisi")));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await AuthService.forgotPassword(emailController.text.trim());

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        '/verify-otp',
        arguments: emailController.text.trim(),
      );
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
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(
                      Icons.blur_on_rounded,
                      size: 80,
                      color: Color(0xFFE056FD),
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
                    'Mail Address Here',
                    style: TextStyle(
                      color: Color(0xFFAC6BFF),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // --- EMAIL INPUT LABEL ---
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

                // --- Custom Email Field with Embedded Action Button ---
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
                        Icons.email_outlined,
                        color: Color(0xFF948AAB),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'mitra@gmail.com',
                            hintStyle: TextStyle(color: Color(0xFF948AAB)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      // Arrow button embedded on right side
                      GestureDetector(
                        onTap: loading ? null : sendOTP,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF32C770),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(11),
                              bottomRight: Radius.circular(11),
                            ),
                          ),
                          child: loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // --- Instructions ---
                const Center(
                  child: Text(
                    'Get Your Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'masukkan 4 Angka yang\ntelah di kirim oleh gmail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA197B4),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // --- Primary Action Button ---
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
                  onPressed: loading ? null : sendOTP,
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
                          'Kirim OTP',
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
