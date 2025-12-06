import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Gunakan TextEditingController untuk mengelola input
  final _nameController = TextEditingController(text: 'Bayu Krisna');
  final _emailController = TextEditingController(text: 'bayukrisna@gmail.com');
  final _idController = TextEditingController(text: 'E41220691');
  final _genderController = TextEditingController(text: 'Laki-Laki');
  final _phoneController = TextEditingController(text: '123456789');
  final _passwordController = TextEditingController(text: '********');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Akun',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- Ilustrasi ---
              Image.asset(
                'assets/images/account.png', // Pastikan gambar ada di assets
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.account_circle, size: 120, color: Colors.grey);
                },
              ),
              const SizedBox(height: 30),

              // --- Form Input ---
              _buildTextField(controller: _nameController, hintText: 'Nama'),
              const SizedBox(height: 16),
              _buildTextField(controller: _emailController, hintText: 'Email'),
              const SizedBox(height: 16),
              _buildTextField(controller: _idController, hintText: 'ID Pengguna'),
              const SizedBox(height: 16),
              _buildTextField(controller: _genderController, hintText: 'Jenis Kelamin'),
              const SizedBox(height: 16),
              _buildTextField(controller: _phoneController, hintText: 'Nomor Telepon'),
              const SizedBox(height: 16),
              _buildTextField(controller: _passwordController, hintText: 'Password', obscureText: true),
              const SizedBox(height: 40),

              // --- Tombol Perbarui ---
              ElevatedButton(
                onPressed: () {
                  // TODO: Tambahkan logika untuk memperbarui data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63A4FF),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Perbarui',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        // Anda bisa menambahkan BottomNavBar di sini jika diperlukan,
        // namun biasanya halaman detail seperti ini tidak memilikinya.
    );
  }

  // Helper widget untuk membuat TextField
  Widget _buildTextField({required TextEditingController controller, required String hintText, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
