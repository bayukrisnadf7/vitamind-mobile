import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model sederhana untuk menyimpan data Q&A
class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  // Daftar pertanyaan dan jawaban
  final List<FaqItem> _faqData = [
    FaqItem(
      question: 'Apakah hasil skrining ini merupakan diagnosis medis?',
      answer:
          'Tidak. Hasil skrining hanya sebagai deteksi awal, bukan diagnosis final. Untuk kepastian, silakan lakukan pemeriksaan di fasilitas kesehatan.',
    ),
    FaqItem(
      question: 'Apakah data saya aman dan terjaga kerahasiaannya?',
      answer:
          'Tentu. Kami berkomitmen penuh untuk melindungi privasi Anda. Semua data yang Anda masukkan bersifat rahasia dan tersimpan dengan sistem yang terenkripsi sehingga tidak dapat diakses oleh pihak yang tidak berwenang.',
    ),
    FaqItem(
      question:
          'Apa yang harus saya lakukan jika hasil skrining menunjukkan risiko tinggi?',
      answer:
          'Jika hasil skrining menunjukkan risiko tinggi, kami sangat menyarankan Anda untuk berkonsultasi dengan profesional kesehatan mental seperti psikolog atau psikiater untuk mendapatkan evaluasi dan penanganan lebih lanjut.',
    ),
    FaqItem(
      question: 'Berapa kali saya boleh melakukan skrining?',
      answer:
          'Anda dapat melakukan skrining sesuai kebutuhan Anda. Namun, jika Anda merasa cemas atau khawatir secara berkelanjutan, sebaiknya segera cari bantuan profesional.',
    ),
    FaqItem(
      question:
          'Apakah saya bisa mendaftar untuk konseling atau bertemu psikolog melalui aplikasi ini?',
      answer:
          'Ya. Aplikasi menyediakan fitur pendaftaran untuk layanan konseling atau psikolog, agar Anda bisa mendapatkan bantuan profesional sesuai kebutuhan.',
    ),
  ];

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
          'FAQ',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        children: [
          // 1. Gambar Ilustrasi
          // CATATAN: Ganti 'assets/faq_image.png' dengan path gambar Anda
          Image.asset('assets/images/faq.png', height: 150),
          const SizedBox(height: 30),
          ..._faqData.map((item) => _buildFaqItem(item)).toList(),
        ],
      ),
    );
  }

  // Widget untuk membuat satu item FAQ
  Widget _buildFaqItem(FaqItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.grey.shade600,
          collapsedIconColor: Colors.grey.shade600,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          childrenPadding: const EdgeInsets.only(bottom: 12.0),
          title: Text(
            item.question,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
              child: Text(
                item.answer,
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
