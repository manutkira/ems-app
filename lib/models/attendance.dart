import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/screens/overtime/delete_overtime.dart';

List<Attendance> attendancesFromJson(List<dynamic> list) {
  return List<Attendance>.from(list.map((x) => Attendance.fromJson(x)));
}

String attendancesToJson(List<Attendance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceType {
  static String get typeCheckIn => "check in";
  static String get typeCheckOut => "check out";
}

class Attendance {
  Attendance({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.note,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? note;
  String? code;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? users;

  Attendance copyWith({
    int? id,
    int? userId,
    DateTime? date,
    String? type,
    String? note,
    String? code,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? users,
  }) =>
      Attendance(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        type: type ?? this.type,
        note: note ?? this.note,
        code: code ?? this.code,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        users: users == null ? this.users : users.copyWith(),
      );

  factory Attendance.fromRawJson(String str) =>
      Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        userId: json["user_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        type: json["type"],
        note: json["note"],
        code: json["code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        users: json["users"] == null ? null : User.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "id": id,
      "user_id": userId,
      "date": date?.toIso8601String(),
      "type": type,
      "note": note,
      "code": code,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
