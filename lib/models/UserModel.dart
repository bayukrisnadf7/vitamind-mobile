class UserModel {
  final String user_id;
  final String nama;
  final String email;
  final String password;

  UserModel({
    required this.user_id,
    required this.nama,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'nama': nama,
      'email': email,
      'password': password,
    };
  }
}
