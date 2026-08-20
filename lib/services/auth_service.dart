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
    // Kode ini akan menembak langsung ke server cloud Supabase
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name, // Menyimpan nama di metadata
      },
    );

    if (response.user == null) {
      throw Exception('Registrasi gagal, tidak dapat membuat user');
    }

    return response;
  }

  // =========================
  // FORGOT PASSWORD
  // =========================
  static Future<void> forgotPassword(String email) async {
    // This triggers Supabase to send a recovery email containing an OTP
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }

  // =========================
  // VERIFY OTP
  // =========================
  static Future<void> verifyOTP(String email, String otp) async {
    // Verifies the OTP. If correct, Supabase creates a temporary authenticated session.
    final response = await Supabase.instance.client.auth.verifyOTP(
      type: OtpType.recovery,
      token: otp,
      email: email,
    );

    if (response.session == null) {
      throw Exception('OTP salah atau sudah kedaluwarsa');
    }
  }

  // =========================
  // RESET PASSWORD
  // =========================
  static Future<void> resetPassword(String email, String newPassword) async {
    // Because verifyOTP creates a session, we can now safely update the user's password.
    // Note: Supabase doesn't actually need the 'email' parameter here because it
    // updates the currently authenticated user, but we leave it to keep your function signature the same.
    final response = await Supabase.instance.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (response.user == null) {
      throw Exception('Gagal mengubah password');
    }
  }
}
