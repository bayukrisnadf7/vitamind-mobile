import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/pages/settings/index.dart';
import 'package:vitamind_mobile/pages/skrinning/data_diri_form_lanjutan.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';

class DataDiriForm extends StatefulWidget {
  const DataDiriForm({super.key});

  @override
  State<DataDiriForm> createState() => _DataDiriFormState();
}

class _DataDiriFormState extends State<DataDiriForm> {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5.0),
              _HeaderSection(nama: _getFirstTwoWords(nama)),
              const SizedBox(height: 50),
              Text(
                'Skrining HIV',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Langkah kecil hari ini bisa jadi perlindungan besar untuk esok.\nYuk, deteksi dini dengan nyaman dan aman!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Divider(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Obx(() {
                  if (skriningController.dataDiriStep.value == 0) {
                    return _DataDiriFormAwal(
                      nama: nama,
                      onNext: skriningController.nextDataDiriStep,
                      onBack: skriningController.previousStep,
                      selectDate: _selectDate,
                      tanggalLahirController: _tanggalLahirController,
                      namaController: _namaController,
                      nimNipController: _nimNipController,
                      alamatController: _alamatController,
                      kabupatenKotaController: _kabupatenKotaController,
                      provinsiController: _provinsiController,
                      jenisKelaminController: _jenisKelaminController,
                      noTeleponController: _noTeleponController,
                    );
                  } else {
                    return const DataDiriFormLanjutan();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimNipController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kabupatenKotaController =
      TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
}

class _DataDiriFormAwal extends StatelessWidget {
  final String? nama;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Function(BuildContext) selectDate;
  final TextEditingController tanggalLahirController;
  final TextEditingController namaController;
  final TextEditingController nimNipController;
  final TextEditingController alamatController;
  final TextEditingController kabupatenKotaController;
  final TextEditingController provinsiController;
  final TextEditingController jenisKelaminController;
  final TextEditingController noTeleponController;

  const _DataDiriFormAwal({
    required this.nama,
    required this.onNext,
    required this.onBack,
    required this.selectDate,
    required this.tanggalLahirController,
    required this.namaController,
    required this.nimNipController,
    required this.alamatController,
    required this.kabupatenKotaController,
    required this.provinsiController,
    required this.jenisKelaminController,
    required this.noTeleponController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Isi Data Diri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Silakan isi data diri anda dengan lengkap dan jujur',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildTextField('Nama', nama ?? 'Bayu Krisna', namaController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'NIP/NIM',
                'E41220691',
                nimNipController,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                'Tanggal Lahir',
                tanggalLahirController,
                context,
                selectDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Alamat', 'Jalan Contoh No 123', alamatController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Kabupaten/Kota',
                '',
                kabupatenKotaController,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Provinsi',
                '',
                provinsiController,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Jenis Kelamin',
                'Laki-Laki',
                jenisKelaminController,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'No Telepon',
                '123456789',
                noTeleponController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3D3D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide.none,
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: onNext,
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    TextEditingController controller,
    BuildContext context,
    Function(BuildContext) selectDate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => selectDate(context),
          child: IgnorePointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Tanggal Lahir',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String nama;

  const _HeaderSection({required this.nama});

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
