class ResetPasswordModel {
  String? id;
  String? email;
  String? codeHash;
  String? createdAt;
  String? expiredAt;

  ResetPasswordModel({
    this.id,
    this.email,
    this.codeHash,
    this.createdAt,
    this.expiredAt,
  });

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    codeHash = json['codeHash'];
    createdAt = json['createdAt'];
    expiredAt = json['expiredAt'];
  }
}
