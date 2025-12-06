import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/pages/auth/login.dart';
import 'package:vitamind_mobile/pages/forgot_password/verify-code.dart';
import 'package:vitamind_mobile/services/reset_password_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Email Kosong',
        'Silakan masukkan email Anda terlebih dahulu.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Panggil service
      await ResetPasswordService.forgotPassword(_emailController.text.trim());

      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        Get.snackbar(
          'Berhasil',
          'Email instruksi reset password telah terkirim. Silakan cek inbox Anda.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.off(() => const VerifyCode());
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Gagal',
          'Email tidak ditemukan.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
      print('Error forgot password: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold sebagai kerangka utama halaman
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan SingleChildScrollView agar halaman bisa di-scroll
      // jika kontennya melebihi ukuran layar (misal saat keyboard muncul)
      body: SingleChildScrollView(
        child: Container(
          // Memberi padding di sekeliling konten utama
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          // Mengatur tinggi minimum agar konten bisa di tengah secara vertikal
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const Text(
                'VitaMind',
                style: TextStyle(
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
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // Posisi bayangan
                    ),
                  ],
                ),
                child: Column(
                  // Membuat semua anak widget di dalam kolom ini
                  // merentang selebar mungkin (full-width)
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 4. JUDUL FORM
                    const Text(
                      'Halaman Lupa Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    Text(
                      'Masukkan email anda yang terdaftar untuk mendapatkan kode.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 5. INPUT FIELD EMAIL
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none, // Tanpa border
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. TOMBOL RESET PASSWORD
                    SizedBox(
                      height: 50, // Memberi tinggi yang pas untuk tombol
                      child: ElevatedButton(
                        onPressed: () {
                          _isLoading ? null : _handleForgotPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          // Warna biru tombol
                          backgroundColor: const Color(0xFF42A5F5),
                          // Warna teks tombol
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 7. LINK KEMBALI KE LOGIN
                    TextButton(
                      onPressed: () {
                        Get.off(() => const Login());
                      },
                      child: Text(
                        'Kembali ke Login',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
