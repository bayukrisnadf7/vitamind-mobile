import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitamind_mobile/models/education_content_modal.dart';
import 'package:vitamind_mobile/models/education_menu_model.dart';
import 'package:vitamind_mobile/models/education_content_model.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  List<EducationMenuModel> getEduMenu() {
    return [
      EducationMenuModel(
        title: 'Mengenal HIV',
        icon_path: "assets/images/ic_1.png",
      ),
      EducationMenuModel(
        title: 'Perbedaan HIV & AIDS',
        icon_path: "assets/images/ic_2.png",
      ),
      EducationMenuModel(
        title: 'Cara Penularan HIV',
        icon_path: "assets/images/ic_3.png",
      ),
      EducationMenuModel(
        title: 'Prinsip Pencegahan ABCDE',
        icon_path: "assets/images/ic_4.png",
      ),
      EducationMenuModel(
        title: 'Pentingnya Tes HIV',
        icon_path: "assets/images/ic_5.png",
      ),
    ];
  }

  EducationContent getEduContent(String title) {
    switch (title) {
      case 'Mengenal HIV':
        return EducationContent(
          title: 'Mengenal HIV',
          imagePath: 'assets/images/mengenal_hiv_content.png',
          content:
              'HIV adalah singkatan dari Human Immunodeficiency Virus, yaitu virus yang menyerang sistem kekebalan tubuh manusia, khususnya sel CD4 yang berperan penting dalam melawan infeksi. Virus ini dapat melemahkan daya tahan tubuh sehingga membuat seseorang lebih rentan terhadap berbagai penyakit. Jika tidak ditangani dengan terapi antiretroviral (ART), HIV dapat berkembang menjadi AIDS (Acquired Immunodeficiency Syndrome), yaitu kondisi ketika sistem kekebalan tubuh sudah sangat lemah dan komplikasi penyakit mudah terjadi.',
        );
      case 'Perbedaan HIV & AIDS':
        return EducationContent(
          title: 'Perbedaan HIV & AIDS',
          imagePath: 'assets/images/perbedaan_hiv_aids_content.png',
          content:
              'HIV (Human Immunodeficiency Virus) adalah virus yang menyerang sistem kekebalan tubuh manusia, khususnya sel CD4. Infeksi HIV dapat berlangsung lama tanpa gejala yang berarti, tetapi virus tetap berkembang di dalam tubuh. AIDS (Acquired Immunodeficiency Syndrome) adalah kondisi atau tahap lanjut dari infeksi HIV, ketika sistem kekebalan tubuh sudah sangat lemah karena jumlah sel CD4 menurun drastis. Pada tahap ini, penderita rentan mengalami infeksi oportunistik dan komplikasi penyakit serius.',
        );
      case 'Cara Penularan HIV':
        return EducationContent(
          title: 'Cara Penularan HIV',
          imagePath: 'assets/images/cara_penularan_hiv_content.png',
          content:
              'HIV dapat menular melalui beberapa cara, yaitu hubungan seksual yang tidak aman tanpa kondom dengan orang yang terinfeksi, penggunaan jarum suntik secara bergantian baik pada pengguna narkoba suntik maupun prosedur medis, tato, atau tindik dengan alat yang tidak steril, transfusi darah atau produk darah yang terkontaminasi, serta dari ibu hamil yang positif HIV kepada bayinya selama kehamilan, persalinan, maupun menyusui. Penting untuk diketahui bahwa HIV tidak menular melalui kontak sehari-hari seperti bersalaman, berpelukan, berbagi makanan atau minuman, menggunakan toilet bersama, maupun gigitan nyamuk.',
        );
      case 'Prinsip Pencegahan ABCDE':
        return EducationContent(
          title: 'Prinsip Pencegahan ABCDE',
          imagePath: 'assets/images/prinsip_abcde_content.png',
          content:
              'Prinsip pencegahan ABCDE merupakan pedoman sederhana yang dapat membantu masyarakat mencegah penularan HIV/AIDS. Prinsip ini meliputi A (Abstinence) yaitu menunda atau tidak melakukan hubungan seksual berisiko sebelum menikah, B (Be faithful) yaitu menjaga kesetiaan dengan satu pasangan, C (Condom use) yaitu menggunakan kondom secara benar dan konsisten ketika melakukan hubungan seksual berisiko, D (Do not use drugs / Don\'t share needles) yaitu menghindari penggunaan narkoba suntik serta tidak berbagi jarum suntik dengan orang lain, dan E (Education/Early detection) yaitu pentingnya edukasi mengenai HIV/AIDS serta melakukan deteksi dini dengan tes HIV untuk mengetahui status sejak awal. Dengan menerapkan prinsip ini, risiko penularan HIV dapat ditekan sehingga kesehatan individu maupun masyarakat lebih terlindungi.',
        );
      case 'Pentingnya Tes HIV':
        return EducationContent(
          title: 'Pentingnya Tes HIV',
          imagePath: 'assets/images/pentingnya_tes_hiv_content.png',
          content:
              'Tes HIV sangat penting karena membantu seseorang mengetahui status kesehatannya sejak dini. Dengan melakukan tes, seseorang yang positif HIV dapat segera memulai terapi antiretroviral (ARV) sehingga jumlah virus dalam tubuh dapat ditekan, sistem kekebalan tetap terjaga, dan risiko penularan kepada orang lain berkurang. Tes HIV juga bermanfaat bagi mereka yang hasilnya negatif, karena dapat memberikan ketenangan sekaligus kesempatan untuk terus menjaga perilaku sehat dan aman. Selain itu, deteksi dini melalui tes HIV berperan besar dalam mengurangi stigma, meningkatkan kesadaran masyarakat, serta mendukung upaya pencegahan dan pengendalian HIV/AIDS secara lebih efektif.',
        );
      default:
        return EducationContent(
          title: 'Konten Tidak Ditemukan',
          content: 'Maaf, konten edukasi untuk topik ini belum tersedia.',
          imagePath: '',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = getEduMenu();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Edukasi Pencegahan',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/edukasi_doctor.png',
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medical_services_outlined,
                  size: 150,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 30),
              ...menuItems
                  .map((item) => _buildMenuItem(context, item))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, EducationMenuModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image.asset(
          item.icon_path,
          width: 24,
          height: 24,
          color: Colors.black,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.image_not_supported_outlined, color: Colors.black),
        ),
        title: Text(
          item.title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          final content = getEduContent(item.title);
          showDialog(
            context: context,
            builder: (context) => EducationContentModal(content: content),
          );
        },
      ),
    );
  }
}
