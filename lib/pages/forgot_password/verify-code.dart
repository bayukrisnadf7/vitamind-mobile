import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/pages/forgot_password/index.dart';
import 'package:vitamind_mobile/pages/forgot_password/reset-password.dart';
import 'package:vitamind_mobile/services/reset_password_service.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  String _email = '';
  bool _isLoading = false;

  
  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ambil email, jika tidak ada, gunakan string kosong
      _email = prefs.getString('email') ?? '';
    });
  }

  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Future<void> _handleVerifyCode() async {
    // Gabungkan kode dari 4 kotak
    final String code = _controllers.map((c) => c.text).join();

    // Validasi sederhana
    if (code.length < 4) {
      Get.snackbar(
        'Kode Tidak Lengkap',
        'Harap masukkan 4 digit kode verifikasi.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (_email.isEmpty) {
      Get.snackbar(
        'Email Hilang',
        'Gagal mendapatkan email. Silakan coba lagi dari awal.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final resetData = await ResetPasswordService.verifyCode(_email, code);
      // JIKA BERHASIL:
      if (mounted) {
        Get.snackbar(
          'Berhasil',
          'Kode verifikasi benar.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.off(() => ResetPassword(
          email: _email,
        ));
      }
    } catch (e) {
      // JIKA GAGAL (service melempar exception):
      if (mounted) {
        final String message = e.toString().replaceFirst('Exception: ', '');
        Get.snackbar(
          'Gagal',
          message.isNotEmpty ? message : 'Kode verifikasi salah atau telah kedaluwarsa.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
      print('Error verify code: $e');
    } finally {
      // Selalu set loading ke false di akhir
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // Bersihkan controllers dan focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Helper widget untuk membangun satu kotak OTP
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 60, // Lebar setiap kotak
      height: 60, // Tinggi setiap kotak
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Hanya satu digit per kotak
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '', // Sembunyikan penghitung maxLength
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5C9DFF), width: 2),
          ),
        ),
        onChanged: (value) {
          // Otomatis pindah ke kotak berikutnya
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          // Otomatis pindah ke kotak sebelumnya saat menghapus
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ini adalah warna biru utama dari UI Anda
    const Color primaryBlue = Color(0xFF5C9DFF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Agar bisa di-scroll di layar kecil
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
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
              const SizedBox(height: 16),

              // 2. Nama Aplikasi
              Text(
                'VitaMind',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Kartu Verifikasi
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 3.1. Judul
                    const Text(
                      'Periksa Email Anda',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3.2. Subjudul
                    // Catatan: Teks di gambar Anda menyebut "5 digit",
                    // tapi UI-nya menunjukkan 4 kotak. Kode ini mengikuti UI (4 kotak).
                    // DENGAN BLOK INI:
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        // Style default-nya, samakan dengan style Text Anda
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                          // Jika Anda menggunakan font kustom, tambahkan `fontFamily` di sini
                        ),
                        children: [
                          const TextSpan(
                            text: 'Kami telah mengirimkan kode ke ',
                          ),
                          TextSpan(
                            text: _email, // Variabel email Anda
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold, // Ini untuk membuatnya bold
                              // Anda mungkin ingin warna emailnya sedikit lebih gelap agar jelas
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(
                            text:
                                '. Masukkan 4 kode yang tercantum dalam email.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // Ini tetap sama
                    // 3.3. Kotak OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOtpBox(0),
                        _buildOtpBox(1),
                        _buildOtpBox(2),
                        _buildOtpBox(3),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3.4. Tombol Verifikasi
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleVerifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                                'Verifikasi Kode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3.5. Link Kirim Ulang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum menerima email? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.off(() => const ForgotPassword());
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Kirim ulang email',
                            style: TextStyle(
                              color: primaryBlue,
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
            ],
          ),
        ),
      ),
    );
  }
}
