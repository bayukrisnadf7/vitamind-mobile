import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/models/UserModel.dart';
import 'package:vitamind_mobile/pages/forgot_password/index.dart';
import 'package:vitamind_mobile/pages/bottom_navigation.dart';
import 'package:vitamind_mobile/pages/auth/register.dart';
import 'package:vitamind_mobile/services/auth_service.dart';
import 'package:vitamind_mobile/themes/color.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String DUMMY_EMAIL = "angga@gmail.com";
  static const String DUMMY_PASSWORD = "password123";
  static const String DUMMY_USER_NAME = "Dania Angga";
  static const String DUMMY_USER_ID = "99999";

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Pengecekan hanya untuk data dummy
      if (email == DUMMY_EMAIL && password == DUMMY_PASSWORD) {
        // Login Dummy Berhasil
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nama', DUMMY_USER_NAME);
        await prefs.setString('email', DUMMY_EMAIL);
        await prefs.setString('user_id', DUMMY_USER_ID);

        Get.snackbar(
          'Login berhasil (Dummy)',
          'Selamat datang, $DUMMY_USER_NAME!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
        Get.offAll(() => const MainNavigation());
      } else {
        // Login Gagal karena bukan data dummy yang diminta
        Get.snackbar(
          'Login gagal',
          'Aplikasi ini sedang dalam mode pengujian. Hanya email "$DUMMY_EMAIL" dengan password "$DUMMY_PASSWORD" yang diperbolehkan.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      // Catch blok dipertahankan untuk keamanan, meskipun tidak ada panggilan API di sini
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat login: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fungsi Google Login tidak diubah dan tetap menggunakan API
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            "752964760317-tl19rniqhqkq7iafdfuhfdcqgehuq73g.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) throw Exception("ID Token is null");

      final data = await AuthService.loginWithGoogle(tokenId: idToken);

      if (data['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nama', data['user']['nama']);
        await prefs.setString('email', data['user']['email']);
        await prefs.setString('token', data['token']);
        await prefs.setString('user_id', data['user']['id'].toString());
        final user = Get.put(UserModel.fromJson(data['user']));
        Get.snackbar(
          'Login berhasil',
          'Selamat datang, ${user.nama}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
        Get.offAll(() => const MainNavigation());
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      String message = e.toString();

      if (e is PlatformException) {
        message = e.message ?? "Google login failed";
      }
      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFE0F7FA),
                        child: Icon(
                          Icons.psychology,
                          size: 50,
                          color: Color(0xFF00B8D4),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'VitaMind',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Silakan masuk untuk memulai skrining kesehatan Anda.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured = !_isPasswordObscured;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.off(() => const ForgotPassword());
                            },
                            child: const Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: Color(0xFF4A90E2),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.off(() => const Register());
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(0xFF4A90E2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Atau',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    onPressed: () {
                      _handleGoogleLogin();
                    },
                    icon: Image.asset(
                      'assets/images/google.png',
                      height: 20.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.android, color: Colors.black54);
                      },
                    ),
                    label: const Text(
                      'Masuk dengan google',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
