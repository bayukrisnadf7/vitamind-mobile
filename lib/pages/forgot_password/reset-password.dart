// pages/forgot_password/reset_password.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

// IMPORT SERVICE DAN HALAMAN LOGIN ANDA
import 'package:vitamind_mobile/services/reset_password_service.dart'; // Sesuaikan path
import 'package:vitamind_mobile/pages/auth/login.dart'; // Sesuaikan path

class ResetPassword extends StatefulWidget {
  final String email;
  // Token Dihapus dari sini

  const ResetPassword({
    super.key,
    required this.email,
    // required this.token, <-- Dihapus
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- FUNGSI DIPERBARUI (TANPA TOKEN) ---
  Future<void> _handleResetPassword() async {
    // Validasi input (tetap sama)
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      Get.snackbar('Input Kosong', 'Harap isi kedua kolom password.',
          backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('Password Tidak Cocok', 'Password baru dan konfirmasi password tidak sama.',
          backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return;
    }
    if (_passwordController.text.length < 6) {
      Get.snackbar('Password Lemah', 'Password harus memiliki minimal 6 karakter.',
          backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil service HANYA dengan email dan password baru
      await ResetPasswordService.resetPassword(
        widget.email,
        _passwordController.text,
      );

      // JIKA BERHASIL
      if (mounted) {
        Get.snackbar(
          'Berhasil!',
          'Password Anda telah berhasil diubah.', // Sesuai permintaan
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        
        // Arahkan ke Login
        Get.offAll(() => const Login()); 
      }
    } catch (e) {
      // JIKA GAGAL
      if (mounted) {
        Get.snackbar(
          'Gagal',
          e.toString().replaceFirst('Exception: ', ''), 
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
      print('Error reset password: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF5C9DFF); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // --- Logo VitaMind ---
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
              const SizedBox(height: 40),

              // --- Kartu Atur Kata Sandi Baru ---
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Atur kata sandi baru',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- Input Password Baru ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, 
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                        hintText: 'Password baru',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Input Ulangi Password Baru ---
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible, 
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                        hintText: 'Ulangi Password baru',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- Tombol Perbarui Password ---
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleResetPassword, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Perbarui Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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