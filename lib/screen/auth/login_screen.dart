import 'package:crm_app/screen/auth/forgot_password_screen.dart';
import 'package:crm_app/screen/auth/otp_screen.dart';
import 'package:crm_app/screen/auth/register_screen.dart';
import 'package:crm_app/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan isi email dan password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      print(result);

      final user = result['user'];

      print('Nama: ${user['name']}');
      print('Role: ${user['role']}');
      print('Token: ${result['token']}');

      // Check if widget is still in the tree before using context across async boundary
      if (!mounted) return;

      // Navigate to DashboardScreen & clear login page from stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const DashboardScreen(), // Pass user/role if needed: DashboardScreen(user: user)
        ),
      );
    } catch (error) {
      print(error);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF53456F), // Purple gradient top
              Color(0xFF221A3B), // Deep dark purple bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // --- App Logo ---
                Center(
                  child: Image.asset(
                    'assets/retali_logo.png', // Ensure asset is added in pubspec.yaml
                    height: 110,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.stars_rounded,
                      size: 90,
                      color: Color(0xFFD355A3),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // --- Title ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Retali Platform',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF34D399),
                      size: 22,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- EMAIL INPUT ---
                const Text(
                  'EMAIL AKUN',
                  style: TextStyle(
                    color: Color(0xFF9E92B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'mitra@gmail.com',
                    hintStyle: const TextStyle(color: Color(0xFF887D9F)),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF887D9F),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF4C3F69).withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF6B5C8A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF6B5C8A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF34D399)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- PASSWORD INPUT ---
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    color: Color(0xFF9E92B4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: _isPasswordObscured,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: const TextStyle(color: Color(0xFF887D9F)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF887D9F),
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF887D9F),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF4C3F69).withOpacity(0.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF6B5C8A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF6B5C8A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF34D399)),
                    ),
                  ),
                ),

                // --- Lupa Password ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Lupa password?',
                      style: TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // --- LOGIN BUTTON ---
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34D399),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Masuk ke Platfrom',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- REGISTER LINK ---
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      }
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Ingin mendaftar ',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'sebagai Pengguna baru? Klik disini',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- DIVIDER WITH "ATAU" ---
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: Color(0xFF4C3F69), thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ATAU',
                        style: TextStyle(
                          color: Color(0xFF887D9F),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Color(0xFF4C3F69), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- GOOGLE SIGN IN BUTTON ---
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Google Login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google 'G' icon or image placeholder
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                          height: 20,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.g_mobiledata,
                                color: Colors.blue,
                                size: 28,
                              ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Masuk dengan Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // --- FOOTER DESCRIPTION ---
                const Text(
                  'Platform Retali mempermudahkan leads, pembuatan konten, dan pelanggan anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF887D9F),
                    fontSize: 12,
                    height: 1.4,
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
