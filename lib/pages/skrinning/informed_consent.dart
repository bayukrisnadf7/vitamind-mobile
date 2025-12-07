import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/pages/settings/index.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';

class InformedConsent extends StatefulWidget {
  const InformedConsent({super.key});

  @override
  State<InformedConsent> createState() => _InformedConsentState();
}

class _InformedConsentState extends State<InformedConsent> {
  String? nama = "";
  final SkriningController skriningController = Get.find<SkriningController>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
    });
  }

  String _getFirstTwoWords(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "";
    final words = fullName.trim().split(" ");
    return words.take(2).join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 5.0),
              HeaderSection(nama: _getFirstTwoWords(nama)),
              const SizedBox(height: 20),
              MainSection(skriningController: skriningController),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final String nama;

  const HeaderSection({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $nama",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "bagaimana kabarnya?",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "hari ini?",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.redAccent),
          onPressed: () => Get.to(() => const Setting()),
        ),
      ],
    );
  }
}

class MainSection extends StatelessWidget {
  final SkriningController skriningController;

  const MainSection({super.key, required this.skriningController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/informed_consent.png',
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            'Data Tepat, Skrining Lebih Akurat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Yuk isi data dengan benar dan jujur saat menjawab skrining 😉\n'
            'Dengan begitu, hasilnya akan lebih tepat dan bermanfaat buat kamu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                skriningController.nextStep(); // Pindah ke DataDiriForm
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Selanjutnya',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.undo, color: Colors.black54),
              label: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFD3D3D3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
