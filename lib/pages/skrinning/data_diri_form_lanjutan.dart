import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitamind_mobile/pages/chat_bot/question_page.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';

class DataDiriFormLanjutan extends StatefulWidget {
  const DataDiriFormLanjutan({super.key});

  @override
  State<DataDiriFormLanjutan> createState() => _DataDiriFormLanjutanState();
}

class _DataDiriFormLanjutanState extends State<DataDiriFormLanjutan> {
  final SkriningController controller = Get.find<SkriningController>();

  String? _menikahValue;
  String? _hamilValue;
  String? _pendidikanValue;
  String? _pekerjaanValue;
  String? _menggambarkanValue;
  String? _skriningSebelumnyaValue;

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
        _buildTextField('Siapa nama ibu kandung anda ?'),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Apakah anda sudah menikah?',
          value: _menikahValue,
          onChanged: (newValue) => setState(() => _menikahValue = newValue),
          items: const ['Ya', 'Tidak'],
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Apakah anda hamil saat ini ?',
          value: _hamilValue,
          onChanged: (newValue) => setState(() => _hamilValue = newValue),
          items: const ['Ya', 'Tidak'],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Berapa usia anak terakhir Anda saat ini?',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField('Berapa jumlah anak kandung anda?'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Apa pendidikan terakhir anda?',
          value: _pendidikanValue,
          onChanged: (newValue) => setState(() => _pendidikanValue = newValue),
          items: const [
            'SD',
            'SMP',
            'SMA/SMK',
            'Diploma',
            'Sarjana',
            'Magister',
            'Doktor',
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Apa pekerjaan anda saat ini ?',
          value: _pekerjaanValue,
          onChanged: (newValue) => setState(() => _pekerjaanValue = newValue),
          items: const [
            'Pelajar/Mahasiswa',
            'PNS/TNI/Polri',
            'Pegawai Swasta',
            'Wiraswasta',
            'Lainnya',
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Berikut ini mana yang paling menggambarkan diri Anda ?',
          value: _menggambarkanValue,
          onChanged: (newValue) =>
              setState(() => _menggambarkanValue = newValue),
          items: const [
            'Laki-laki (Cisgender)',
            'Perempuan (Cisgender)',
            'Transgender Pria',
            'Transgender Wanita',
            'Non-Biner',
            'Lainnya',
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Apakah anda pernah melakukan skrining hiv sebelumnya ?',
          value: _skriningSebelumnyaValue,
          onChanged: (newValue) =>
              setState(() => _skriningSebelumnyaValue = newValue),
          items: const ['Ya', 'Tidak'],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () => controller.previousDataDiriStep(),
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
                  onPressed: () {
                    Get.to(() => const QuestionPage());
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: const Text('Pilih salah satu'),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String itemValue) {
                return DropdownMenuItem<String>(
                  value: itemValue,
                  child: Text(itemValue),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
