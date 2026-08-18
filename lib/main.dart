import 'package:flutter/material.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/auth/forgot_password_screen.dart';
import 'screen/auth/otp_screen.dart';
import 'screen/auth/reset_password_screen.dart';
import 'screen/dashboard/dashboard_screen.dart';
import 'screen/CRM/kanban_screen.dart';
import 'screen/CRM/jadwal_screen.dart';
import 'screen/profile/profile_screen.dart';

void main() {
  runApp(const ProjectRetalioneApp());
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

      initialRoute: '/profile',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/verify-otp': (context) => const VerifyOtpPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/kanban':(context) => const CrmBoardScreen(),
        '/jadwal':(context) => const ScheduleScreen(),
        '/profile':(context) => const ProfileScreen(),
      },
    );
  }
}
