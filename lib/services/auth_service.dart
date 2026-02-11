import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vitamind_mobile/models/UserModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  static const String baseUrl = 'http://192.168.1.7:3000/api/auth';
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static const String PLAY_SERVICES_ERROR =
      'Google Play Services tidak tersedia atau perlu diperbarui';

  static Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['data'] != null && data['data']['user'] != null) {
        return UserModel.fromJson(data['data']['user']);
      }

      return null;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle({
    required String tokenId,
  }) async {
    final url = Uri.parse('$baseUrl/google-login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"tokenId": tokenId}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", result["data"]["token"]);

        return {
          "success": true,
          "user": result["data"]["user"],
          "token": result["data"]["token"],
        };
      }

      return {"success": false, "message": result["message"] ?? "Login gagal"};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<bool> checkGooglePlayServices() async {
    try {
      final available = await _googleSignIn.isSignedIn();
      return true;
    } catch (e) {
      print('Google Play Services check failed: $e');
      return false;
    }
  }

  static Future<GoogleSignInAuthentication?> signInWithGoogle() async {
    try {
      final isAvailable = await checkGooglePlayServices();
      if (!isAvailable) {
        throw Exception(AuthService.PLAY_SERVICES_ERROR);
      }

      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      return await account.authentication;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  static Future<UserModel?> register(UserModel user) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['code'] == 200 && data['data'] != null) {
        return UserModel.fromJson(data['data']);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    return;
  }
}
