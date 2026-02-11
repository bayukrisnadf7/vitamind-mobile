import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vitamind_mobile/models/ResetPasswordModel.dart';

class ResetPasswordService {
  static const String baseUrl = 'http://192.168.1.7:3000/api';

  static Future<ResetPasswordModel> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResetPasswordModel.fromJson(data);
    } else {
      try {
        final decoded = jsonDecode(response.body);
        final message =
            decoded['message'] ??
            decoded['error'] ??
            'Gagal mengirim email reset password';
        throw Exception(message);
      } catch (_) {
        throw Exception('Gagal mengirim email reset password');
      }
    }
  }

  static Future<ResetPasswordModel> verifyCode(
    String email,
    String code,
  ) async {
    final url = Uri.parse('$baseUrl/verify-code');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResetPasswordModel.fromJson(data);
    } else {
      try {
        final decoded = jsonDecode(response.body);
        final message =
            decoded['message'] ??
            decoded['error'] ??
            'Kode verifikasi salah atau telah kedaluwarsa';
        throw Exception(message);
      } catch (_) {
        throw Exception('Kode verifikasi salah atau telah kedaluwarsa');
      }
    }
  }

  static Future<ResetPasswordModel> resetPassword(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/reset-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResetPasswordModel.fromJson(data);
    } else {
      try {
        final decoded = jsonDecode(response.body);
        final message =
            decoded['message'] ?? decoded['error'] ?? 'Gagal mereset password';
        throw Exception(message);
      } catch (_) {
        throw Exception('Gagal mereset password');
      }
    }
  }
}
