import 'dart:convert';
import 'package:http/http.dart' as http;

class Regency {
  final String code;
  final String name;

  Regency({required this.code, required this.name});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      code: json['code'],
      name: json['name'],
    );
  }
}

class RegencyApi {
  static const String baseUrl = 'https://wilayah.id/api/regencies';

  static Future<List<Regency>> getRegencies(String provinceCode) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$provinceCode.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ambil list dari key "data"
        final List<dynamic> regencyList = responseData['data'];

        // Mapping ke model Regency
        return regencyList.map((json) => Regency.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil kabupaten: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
