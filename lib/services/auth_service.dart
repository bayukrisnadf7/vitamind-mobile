import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vitamind_mobile/models/UserModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.18.27:3000/api/auth';
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

      // format backend = data.user
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
    final payload = {
      "tokenId": tokenId,
    }; // adjust key if backend expects different name

    try {
      print('AuthService.loginWithGoogle -> POST $url');
      print('Request payload: $payload');

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 404) {
        return {
          "success": false,
          "message":
              "Endpoint not found (404). Verify server route '/api/auth/google-login' and HTTP method (POST).",
        };
      }

      if (response.statusCode != 200) {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode} - ${response.body}",
        };
      }

      if (response.body.isEmpty) {
        return {"success": false, "message": "Empty server response"};
      }

      final result = jsonDecode(response.body);
      if (result is! Map) {
        return {"success": false, "message": "Invalid server response format"};
      }

      if (result["status"] == true || result["code"] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", result["data"]["token"]);

        return {
          "success": true,
          "user": result["data"]["user"],
          "token": result["data"]["token"],
        };
      }

      return {
        "success": false,
        "message": result["message"] ?? "Unknown error",
      };
    } catch (e) {
      print('loginWithGoogle error: $e');
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<bool> checkGooglePlayServices() async {
    try {
      final available = await _googleSignIn.isSignedIn();
      return true; // If we get here, Play Services is working
    } catch (e) {
      print('Google Play Services check failed: $e');
      return false;
    }
  }

  // Add this helper method for cleaner sign-in
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
