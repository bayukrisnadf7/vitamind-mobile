import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitamind_mobile/pages/bottom_navigation.dart';
import 'package:vitamind_mobile/pages/edukasi/edukasi_page.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';

class SkriningResultPage extends StatelessWidget {
  const SkriningResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SkriningController controller = Get.find<SkriningController>();
    final result = controller.getResult();

    // Logic untuk menyorot kata kunci (disimpan dari jawaban sebelumnya)
    final String message = result.message;
    final String title = result.title;
    final int titleIndex = message.indexOf(title);

    String part1 = message;
    String part2 = "";

    if (titleIndex != -1) {
      part1 = message.substring(0, titleIndex);
      part2 = message.substring(titleIndex + title.length);
    }
    // Akhir Logic String Highlighting

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          controller.resetSkrining();
          Get.offAll(() => const MainNavigation());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Hasil Skrining',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    result.imageAsset,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.warning, size: 150, color: Colors.red),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: part1),
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            color: result.titleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: part2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tombol Edukasi
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const EdukasiPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      result.buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TOMBOL DAFTAR KONSULTASI PSIKOLOG
                  ElevatedButton(
                    onPressed: () {
                      controller.resetSkrining();
                      Get.offAll(() => const MainNavigation(), arguments: 2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Daftar Konsultasi Psikolog',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tombol Selesai
                  OutlinedButton(
                    onPressed: () {
                      controller.resetSkrining();
                      Get.offAll(() => const MainNavigation());
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.redAccent, height: 1),
                  const SizedBox(height: 10),
                  const Text(
                    'Perhatian',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Skrining ini membantu mengenali risiko, tetapi diagnosis tetap memerlukan tes medis.\n2. Privasi Anda adalah prioritas kami. Semua data tersimpan dengan aman dan tidak akan disebarluaskan.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
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
