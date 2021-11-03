// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> usersFromJson(List<dynamic> list) {
  return List<User>.from(list.map((x) => User.fromJson(x)));
}

String usersToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.emailVerifiedAt,
    this.address,
    this.position,
    this.skill,
    this.salary,
    this.background,
    this.status,
    this.rate,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String phone;
  String? email;
  DateTime? emailVerifiedAt;
  String? address;
  String? position;
  String? skill;
  int? salary;
  String? background;
  String? status;
  String? rate;
  int roleId;
  DateTime createdAt;
  DateTime updatedAt;

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) {
    // json.forEach((key, value) {
    //   if (value.toString().isNotEmpty) {
    //     print("$key $value");
    //   }
    // });

    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      phone: json["phone"] as String,
      email: json["email"] as String?,
      emailVerifiedAt: json["email_verified_at"],
      address: json["address"] as String?,
      position: json["position"] as String?,
      skill: json["skill"] as String?,
      salary: json["salary"] as int?,
      background: json["background"] as String?,
      status: json["status"] as String?,
      rate: json["rate"] as String?,
      roleId: json["role_id"] as int,
      createdAt: DateTime.parse(json["created_at"] as String),
      updatedAt: DateTime.parse(json["updated_at"] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "email_verified_at": emailVerifiedAt!.toIso8601String(),
        "address": address,
        "position": position,
        "skill": skill,
        "salary": salary,
        "background": background,
        "status": status,
        "rate": rate,
        "role_id": roleId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
