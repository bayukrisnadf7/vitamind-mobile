import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tentang Aplikasi',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/about.png',
                height: 150,
                // Sesuaikan ukuran gambar jika perlu
              ),
              const SizedBox(height: 20),
              // 2. Teks Kebijakan Privasi
              Text(
                'Aplikasi ini dibuat untuk membantu masyarakat melakukan skrining kesehatan secara mandiri, mudah.\nDengan menjawab beberapa pertanyaan sederhana, Anda dapat mengetahui tingkat risiko kesehatan dan mendapatkan rekomendasi langkah selanjutnya.\nKami berkomitmen menjaga privasi dan kerahasiaan data Anda. Semua informasi yang Anda masukkan hanya digunakan untuk keperluan skrining, bukan untuk diagnosis medis, dan tidak dibagikan kepada pihak ketiga tanpa izin Anda. Aplikasi ini dirancang sebagai alat bantu awal, bukan pengganti konsultasi dengan tenaga kesehatan. Untuk hasil lebih akurat, silakan lakukan pemeriksaan langsung di fasilitas layanan kesehatan.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
