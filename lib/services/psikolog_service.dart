import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vitamind_mobile/models/PsikologModel.dart';

class PsikologService {
  static const String baseUrl = 'http://192.168.1.7:3000/api/psikolog';

  static Future<List<PsikologModel>> getPendaftaranPsikolog(
    String userId,
  ) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        return jsonResponse.map((e) => PsikologModel.fromJson(e)).toList();
      }

      if (jsonResponse['data'] != null) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((e) => PsikologModel.fromJson(e)).toList();
      }

      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load psikolog: ${response.statusCode}');
    }
  }

  static Future<void> registerPsikolog(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      // kalau gagal, lempar error
      final body = jsonDecode(response.body);
      throw Exception('Gagal mendaftar: ${body['message'] ?? response.body}');
    }
  }
}
