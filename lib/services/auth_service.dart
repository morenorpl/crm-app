import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // =========================
  // LOGIN
  // =========================
  static Future<AuthResponse> login(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return response;
  }

  // =========================
  // REGISTER VIA SUPABASE
  // =========================
  static Future<AuthResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    if (response.user == null) {
      throw Exception('Registrasi gagal, tidak dapat membuat user');
    }

    return response;
  }

  // =========================
  // FORGOT PASSWORD
  // =========================
  // Backend yang generate dan mengirim OTP.
  // Supabase TIDAK mengirim email.
  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal mengirim OTP');
    }
  }

  // =========================
  // VERIFY OTP
  // =========================
  static Future<String> verifyOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    final data = jsonDecode(response.body);

    print('=== BACKEND RESPONSE ===: $data');

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] != true) {
      throw Exception(data['message'] ?? 'OTP salah atau sudah kedaluwarsa');
    }

    // 1. Safely extract the resetId without crashing
    final resetId =
        data['reset_id'] ??
        data['resetId'] ??
        (data['data'] != null ? data['data']['reset_id'] : null);

    // 2. If the API didn't return a resetId at all, throw a readable error
    if (resetId == null) {
      throw Exception(
        'Server tidak mengembalikan reset_id. Silakan periksa backend API Anda.',
      );
    }

    return resetId.toString();
  }

  // =========================
  // RESET PASSWORD
  // =========================
  static Future<void> resetPassword(String resetId, String newPassword) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'resetId':
            resetId, // Ensure this key matches your backend's expected variable name
        'newPassword': newPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal mengubah password');
    }
  }
}
