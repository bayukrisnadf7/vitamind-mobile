import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart'; // ✅ Tambahkan ini
import 'package:vitamind_mobile/pages/auth/login.dart';
import 'package:vitamind_mobile/pages/settings/about.dart';
import 'package:vitamind_mobile/pages/settings/account.dart';
import 'package:vitamind_mobile/pages/settings/faq.dart';
import 'package:vitamind_mobile/pages/settings/privacy.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int _selectedIndex = 0;
  String? nama = '';
  String? email = '';
  String? gender = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _getFirstTwoWords(String? fullName) {
    if (fullName == null || fullName.isEmpty) return '';
    final words = fullName.trim().split(' ');
    if (words.length <= 2) {
      return fullName;
    } else {
      return '${words[0]} ${words[1]}';
    }
  }

  String _getProfileImage() {
  if (gender == null || gender!.isEmpty) {
    return 'assets/images/default.png';
  }

  if (gender!.toLowerCase() == 'laki-laki') {
    return 'assets/images/male.jpg';
  }

  if (gender!.toLowerCase() == 'perempuan') {
    return 'assets/images/female.jpg';
  }

  return 'assets/images/default.png';
}

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? '';
      email = prefs.getString('email') ?? '';
      gender = prefs.getString('gender') ?? '';
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pop(context);
    }
  }

  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    await prefs.remove('nama');
    await prefs.remove('email');
    await prefs.remove('token');
    await prefs.remove('user_id');

    Get.offAll(() => const Login());
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: const Icon(Icons.logout, color: Color(0xFFE53935), size: 48),
          title: Text(
            'Konfirmasi Logout',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _logoutUser(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(_getProfileImage()),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_getFirstTwoWords(nama)}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$email',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Akun',
                      onTap: () {
                        Get.to(() => const Account());
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.shield_outlined,
                      title: 'Privasi & Kerahasiaan',
                      onTap: () {
                        Get.to(() => const Privacy());
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'FAQ',
                      onTap: () {
                        Get.to(() => const Faq());
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      title: 'Tentang',
                      onTap: () {
                        Get.to(() => const About());
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _showLogoutConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey[800]),
          title: Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
