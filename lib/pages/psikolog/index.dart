import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/api/regency.dart';
import 'package:vitamind_mobile/components/modal/confirmation_modal.dart';
import 'package:vitamind_mobile/components/modal/success_modal.dart';
import 'package:vitamind_mobile/models/PsikologModel.dart';
import 'package:vitamind_mobile/pages/settings/index.dart';
import 'package:vitamind_mobile/services/psikolog_service.dart';
import 'package:vitamind_mobile/themes/color.dart';
import 'package:vitamind_mobile/api/province.dart';

class PsikologPage extends StatefulWidget {
  const PsikologPage({super.key});

  @override
  State<PsikologPage> createState() => _PsikologPageState();
}

class _PsikologPageState extends State<PsikologPage> {
  int _selectedTabIndex = 0;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _userIdController = TextEditingController();

  List<Province> _provinces = [];
  List<Regency> _regencies = [];
  List<PsikologModel> _riwayat = [];
  String? _selectedProvinsi;
  String? _selectedKabupaten;
  String? nama = '';
  String user_id = '';
  bool _isLoadingProvinsi = false;
  bool _isLoadingKabupaten = false;
  bool _isLoadingRiwayat = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProvinces();
    _loadUserData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id') ?? '';
      nama = prefs.getString('nama') ?? 'User';
      _namaController.text = prefs.getString('nama') ?? 'Bayu Krisna';
      _emailController.text =
          prefs.getString('email') ?? 'bayukrisna@gmail.com';
      _teleponController.text = '123456789';
      _userIdController.text = prefs.getString('user_id') ?? '';
    });

    if (user_id != null) {
      _fetchRiwayat(user_id);
    }
  }

  Future<void> _fetchRiwayat(String userId) async {
    setState(() => _isLoadingRiwayat = true);
    try {
      final data = await PsikologService.getPendaftaranPsikolog(userId);
      setState(() => _riwayat = data);
    } catch (e) {
      print('Gagal ambil riwayat: $e');
    } finally {
      setState(() => _isLoadingRiwayat = false);
    }
  }

  Future<void> _fetchProvinces() async {
    try {
      final provinces = await ProvinceApi.getProvinces();
      setState(() {
        _provinces = provinces;
      });
    } catch (e) {
      print('Gagal ambil provinsi: $e');
    }
  }

  Future<void> _submitPendaftaran() async {
    final data = {
      "nama": _namaController.text,
      "email": _emailController.text,
      "alamat": _alamatController.text,
      "provinsi": _selectedProvinsi ?? '',
      "kabupaten": _selectedKabupaten ?? '',
      "no_telepon": _teleponController.text,
      "user_id": _userIdController.text,
    };

    try {
      await PsikologService.registerPsikolog(data);

      // tampilkan popup sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessModal(
          onClose: () {
            Navigator.pop(context);
            _fetchRiwayat(_userIdController.text);
            setState(() => _selectedTabIndex = 1);
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal daftar: $e")));
    }
  }

  Future<void> _fetchRegencies(String provinceCode) async {
    setState(() {
      _isLoadingKabupaten = true;
      _regencies = [];
      _selectedKabupaten = null;
    });

    try {
      final regencies = await RegencyApi.getRegencies(provinceCode);
      setState(() {
        _regencies = regencies;
      });
    } catch (e) {
      print('Gagal ambil kabupaten: $e');
    } finally {
      setState(() => _isLoadingKabupaten = false);
    }
  }

  String _getFirstTwoWords(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    final words = fullName.trim().split(' ');
    return words.take(2).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildTitleSection(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildToggleButtons(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _selectedTabIndex == 0
                      ? _buildRegistrationForm()
                      : _buildHistoryView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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
                    'Hi, ${_getFirstTwoWords(nama)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'bagaimana kabarnya?',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'hari ini?',
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
            onPressed: () {
              Get.to(() => const Setting());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Pendaftaran Konsultasi Psikologi HIV',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Silahkan lakukan pendaftaran untuk melakukan konsultasi mengenai psikologi anda terkait dengan penyakit HIV',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ===== TOGGLE BUTTONS (Pendaftaran / Riwayat) =====
  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(child: _buildToggleButton('Pendaftaran', 0)),
        const SizedBox(width: 16),
        Expanded(child: _buildToggleButton('Riwayat', 1)),
      ],
    );
  }

  Widget _buildToggleButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return isSelected
        ? ElevatedButton(
            onPressed: () => setState(() => _selectedTabIndex = index),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        : OutlinedButton(
            onPressed: () => setState(() => _selectedTabIndex = index),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          );
  }

  // ===== FORM PENDAFTARAN =====
  Widget _buildRegistrationForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('Nama'),
          _buildTextField(_namaController),
          const SizedBox(height: 4),

          _buildFormLabel('Email'),
          _buildTextField(_emailController),
          const SizedBox(height: 4),

          _buildFormLabel('Alamat'),
          _buildTextField(_alamatController, hint: 'Masukkan alamat lengkap'),
          const SizedBox(height: 4),

          Wrap(
            spacing: 16,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width > 600
                    ? (MediaQuery.of(context).size.width - 72) / 2
                    : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('Provinsi'),
                    _isLoadingProvinsi
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _buildDropdownField(
                            hint: 'Pilih Provinsi',
                            value: _selectedProvinsi,
                            items: _provinces.map((p) => p.name).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProvinsi = value;
                                final selected = _provinces.firstWhere(
                                  (p) => p.name == value,
                                );
                                _fetchRegencies(selected.code);
                              });
                            },
                          ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 600
                    ? (MediaQuery.of(context).size.width - 72) / 2
                    : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('Kabupaten/Kota'),
                    _isLoadingKabupaten
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _buildDropdownField(
                            hint: _regencies.isEmpty
                                ? 'Pilih Provinsi terlebih dahulu'
                                : 'Pilih Kabupaten/Kota',
                            value: _selectedKabupaten,
                            items: _regencies.map((r) => r.name).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedKabupaten = value),
                          ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          _buildFormLabel('No Telepon'),
          _buildTextField(_teleponController),

          const SizedBox(height: 40),
          _buildSubmitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.poppins()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ConfirmationModal(
              onCancel: () {
                Navigator.pop(context);
              },
              onConfirm: () {
                Navigator.pop(context);
                _submitPendaftaran();
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Daftar',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ===== VIEW RIWAYAT KOSONG =====
  Widget _buildHistoryView() {
    if (_isLoadingRiwayat) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_riwayat.isEmpty) {
      return SizedBox(
        height:
            MediaQuery.of(context).size.height *
            0.45, // menggeser lebih ke tengah
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_data.png', height: 130),
              const SizedBox(height: 16),
              Text(
                'Belum ada riwayat konsultasi',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _riwayat.length,
      itemBuilder: (context, index) {
        final item = _riwayat[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.date_range,
              color: Colors.blueAccent,
              size: 32,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tgl. Konsultasi: 0241',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Klinik Pratama Polije',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            visualDensity: const VisualDensity(vertical: 0),
            minLeadingWidth: 40,
            minVerticalPadding: 0,
          ),
        );
      },
    );
  }
}
