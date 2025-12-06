import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitamind_mobile/pages/auth/login.dart'; // Pastikan path ini benar

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  super.initState();
  Timer(const Duration(seconds: 3), () {
    Get.off(() => const Login());
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Logo ---
            // Ganti dengan Image.asset jika Anda sudah punya logonya
            Image.asset(
              'assets/images/logo.png', // Pastikan path ini benar
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder jika gambar gagal dimuat
                return const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFE0F7FA),
                  child: Icon(
                    Icons.psychology,
                    size: 60,
                    color: Color(0xFF00B8D4),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // --- Teks di bawah logo ---
            Text(
              'Selamat Datang di Aplikasi\nSkrining HIV',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
