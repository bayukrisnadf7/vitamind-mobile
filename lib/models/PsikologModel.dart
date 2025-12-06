class PsikologModel {
  final String pendaftaran_id;
  final String nama;
  final String email;
  final String alamat;
  final String provinsi;
  final String kabupaten;
  final String noTelepon;
  final String user_id;
  final DateTime createdAt;
  final DateTime updatedAt;

  PsikologModel({
    required this.pendaftaran_id,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.provinsi,
    required this.kabupaten,
    required this.noTelepon,
    required this.user_id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PsikologModel.fromJson(Map<String, dynamic> json) {
    return PsikologModel(
      pendaftaran_id: json['pendaftaran_id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      alamat: json['alamat'] ?? '',
      provinsi: json['provinsi'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      noTelepon: json['no_telepon'] ?? '',
      user_id: json['user_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendaftaran_id': pendaftaran_id,
      'nama': nama,
      'email': email,
      'alamat': alamat,
      'provinsi': provinsi,
      'kabupaten': kabupaten,
      'no_telepon': noTelepon,
      'user_id': user_id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
