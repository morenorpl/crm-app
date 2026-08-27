// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crm_app/constants/app_assets.dart';
import '../../services/auth_service.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final otpController = TextEditingController();

  // 6 individual controllers & focus nodes for the PIN box UI
  final List<TextEditingController> _pinControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool loading = false;

  @override
  void dispose() {
    otpController.dispose();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Helper to sync 6-box inputs into the main otpController
  void _syncOtpController() {
    otpController.text = _pinControllers.map((c) => c.text).join();
  }

  Future<void> verifyOTP() async {
    _syncOtpController();

    // 1. Get the email passed from the Forgot Password screen
    final args = ModalRoute.of(context)?.settings.arguments;
    final email = args is String ? args : '';

    if (otpController.text.isEmpty || otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP wajib diisi dengan lengkap"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // 2. Call AuthService and capture the returned resetId
      final resetId = await AuthService.verifyOTP(
        email,
        otpController.text.trim(),
      );

      if (!mounted) return;

      // 3. Navigate to Reset Password and pass the resetId
      Navigator.pushNamed(context, '/reset-password', arguments: resetId);
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
    // Retrieve email passed as arguments for display
    final args = ModalRoute.of(context)?.settings.arguments;
    final displayEmail = (args is String && args.isNotEmpty)
        ? args
        : 'mitra@gmail.com';

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
              horizontal: 16.0,
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
                    'Input OTP Code',
                    style: TextStyle(
                      color: Color(0xFFAC6BFF),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // --- EMAIL DISPLAY FIELD ---
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

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF61547D).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF7B6C9B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF948AAB),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          displayEmail,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // --- OTP Instructions ---
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
                    'masukkan 6 Angka yang\ntelah di kirim oleh gmail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA197B4),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- 6-DIGIT PIN INPUT BOXES ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 44,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _pinControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(
                            0xFF61547D,
                          ).withValues(alpha: 0.5),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF7B6C9B),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF32C770),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _syncOtpController();

                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (otpController.text.length == 6) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // --- Resend Text ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Tidak Mendapatkan Code, ',
                      style: TextStyle(color: Color(0xFFA197B4), fontSize: 12),
                    ),
                    Text(
                      'Resend',
                      style: TextStyle(
                        color: Color(0xFFAC6BFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // --- VERIFICATION BUTTON ---
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
                  onPressed: loading ? null : verifyOTP,
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
                          'Verifikasi OTP',
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
