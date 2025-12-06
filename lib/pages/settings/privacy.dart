import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
          'Privasi & Kerahasiaan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      // Mengganti 'childd' dengan layout yang sesuai
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/privacy.png',
                height: 150,
                // Sesuaikan ukuran gambar jika perlu
              ),
              const SizedBox(height: 20),
              // 2. Teks Kebijakan Privasi
              Text(
                'Kami berkomitmen penuh untuk melindungi privasi Anda. Semua data yang Anda masukkan dalam aplikasi ini bersifat rahasia dan hanya digunakan untuk keperluan skrining serta peningkatan layanan. Informasi pribadi Anda tidak akan disebarkan, dibagikan, ataupun dijual kepada pihak ketiga tanpa persetujuan Anda.\nUntuk menjamin keamanan, data tersimpan dengan sistem yang terenkripsi sehingga tidak dapat diakses oleh pihak yang tidak berwenang. Kami memastikan bahwa setiap proses skrining berlangsung dengan aman, terpercaya, dan menjaga kerahasiaan identitas Anda.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.6,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
