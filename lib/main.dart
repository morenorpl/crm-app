import 'package:crm_app/screen/layout/main_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 👈 Tambahkan Provider
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/auth/forgot_password_screen.dart';
import 'screen/auth/otp_screen.dart';
import 'screen/auth/reset_password_screen.dart';
import 'screen/dashboard/dashboard_screen.dart';
import 'screen/CRM/kanban/kanban_screen.dart';
import 'screen/CRM/jadwal_screen.dart';
import 'screen/profile/profile_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/api_config.dart';

// 👈 Import CrmController Anda
import 'screen/CRM/kanban/controllers/crm_controller.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi koneksi remote Supabase
  await Supabase.initialize(
    url: ApiConfig.supabaseUrl,
    anonKey: ApiConfig.supabaseAnonKey,
  );

  // 👈 Bungkus runApp dengan MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CrmController()),
      ],
      child: const ProjectRetalioneApp(),
    ),
  );
}

class ProjectRetalioneApp extends StatelessWidget {
  const ProjectRetalioneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Projectretalione',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      initialRoute: '/splash',

      routes: {
        '/main': (context) => const MainLayoutScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/verify-otp': (context) => const VerifyOtpPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}