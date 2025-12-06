import 'dart:convert';
import 'package:http/http.dart' as http;

class Province {
  final String code;
  final String name;

  Province({required this.code, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'],
      name: json['name'],
    );
  }
}

class ProvinceApi {
  static const String baseUrl = 'https://wilayah.id/api/provinces.json';

  static Future<List<Province>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ambil list dari key "data"
        final List<dynamic> provinceList = responseData['data'];

        // Mapping ke model Province
        return provinceList.map((json) => Province.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil provinsi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
