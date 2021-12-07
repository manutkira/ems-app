import 'dart:convert';

import 'package:ems/utils/services/exceptions/user.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

List<User> usersFromJson(List<dynamic> list) {
  return List<User>.from(list.map((x) => User.fromJson(x)));
}

String usersToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserImageType {
  static String get profile => "image";
  static String get id => "image_id";
}

@HiveType(typeId: 0)
class User {
  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.address,
    this.password,
    this.position,
    this.skill,
    this.salary,
    this.role,
    this.background,
    this.status,
    this.rate,
    this.image,
    this.imageId,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? email;
  @HiveField(4)
  DateTime? emailVerifiedAt;
  @HiveField(5)
  String? address;
  @HiveField(6)
  String? password;
  @HiveField(7)
  String? position;
  @HiveField(8)
  String? skill;
  @HiveField(9)
  String? salary;
  @HiveField(10)
  String? role;
  @HiveField(11)
  String? background;
  @HiveField(12)
  String? status;
  @HiveField(13)
  String? rate;
  @HiveField(14)
  DateTime? createdAt;
  @HiveField(15)
  DateTime? updatedAt;
  @HiveField(16)
  String? image;
  @HiveField(17)
  String? imageId;

  bool get isEmpty {
    return id == null ||
        id == 0 ||
        id!.isNaN ||
        id!.isNegative ||
        name!.isEmpty ||
        phone!.isEmpty;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) {
    User? user;

    try {
      user = User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        address: json["address"],
        image: json["image"],
        imageId: json["image_id"],
        position: json["position"],
        skill: json["skill"],
        salary: json["salary"],
        role: json["role"],
        background: json["background"],
        status: json["status"],
        rate: json["rate"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
      return user;
    } catch (e) {
      throw UserException(code: 1);
    }
  }

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    DateTime? emailVerifiedAt,
    String? address,
    String? position,
    String? skill,
    String? salary,
    String? role,
    String? background,
    String? status,
    String? rate,
    String? image,
    String? imageId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        address: address ?? this.address,
        position: position ?? this.position,
        skill: skill ?? this.skill,
        salary: salary ?? this.salary,
        role: role ?? this.role,
        background: background ?? this.background,
        status: status ?? this.status,
        rate: rate ?? this.rate,
        image: image ?? this.image,
        imageId: imageId ?? this.imageId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> buildCleanJson() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }

  Map<String, dynamic> toJson() {
    if (name == null || name!.isEmpty || phone == null) {
      throw UserException(code: 2);
    }

    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "email_verified_at": emailVerifiedAt?.toIso8601String(),
      "password": password,
      "address": address,
      "position": position,
      "skill": skill,
      "salary": salary,
      "role": role,
      "background": background,
      "status": status,
      "rate": rate,
      "image": image,
      "image_id": imageId,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
