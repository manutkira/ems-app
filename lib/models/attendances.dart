import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:flutter/material.dart';

List<Attendances> attendancessFromJson(List<dynamic> list) {
  return List<Attendances>.from(list.map((x) => Attendances.fromJson(x)));
}

List<AttendancesWithDate> attendancesbyDayFromJson(Map<String, dynamic> list) {
  List<AttendancesWithDate> awdlist = [];

  list.forEach((key, value) {
    var awd = AttendancesWithDate(
        date: DateTime.parse(key), list: attendancessFromJson(value));
    awdlist.add(awd);
  });

  /// lists here to send back to service.
  return awdlist;
}

List<Attendance> attendancesFromAttendancesbyDay(
  List<AttendanceWithDate> awds,
) {
  List<Attendance> attendances = [];
  try {
    // flatten the list to get the attendances
    attendances = awds.expand((element) => element.list).toList();
  } catch (e) {
    return [];
  }
  return attendances;
}

class AttendancesWithDate {
  DateTime date;
  List<Attendances> list;

  AttendancesWithDate({required this.date, required this.list});

  AttendancesWithDate copyWith({
    DateTime? date,
    List<Attendances>? list,
  }) =>
      AttendancesWithDate(date: date ?? this.date, list: list ?? this.list);
}

class Attendances {
  int id;
  int userId;
  DateTime date;
  T? getT1;
  T? getT2;
  T? getT3;
  T? getT4;
  T? getT5;
  T? getT6;
  String t;
  String overtime;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Attendances({
    required this.id,
    required this.userId,
    required this.date,
    this.getT1,
    this.getT2,
    this.getT3,
    this.getT4,
    this.getT5,
    this.getT6,
    required this.t,
    required this.overtime,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Attendances copyWith({
    int? id,
    int? userId,
    DateTime? date,
    T? getT1,
    T? getT2,
    T? getT3,
    T? getT4,
    T? getT5,
    T? getT6,
    String? t,
    String? overtime,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) =>
      Attendances(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          date: date ?? this.date,
          getT1: getT1 ?? this.getT1,
          getT2: getT2 ?? this.getT2,
          getT3: getT3 ?? this.getT3,
          getT4: getT4 ?? this.getT4,
          getT5: getT5 ?? this.getT5,
          getT6: getT6 ?? this.getT6,
          t: t ?? this.t,
          overtime: overtime ?? this.overtime,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          user: user == null ? this.user : user.copyWith());

  factory Attendances.fromJson(Map<String, dynamic> json) => Attendances(
      date: DateTime.parse(json["date"]),
      getT1: json["get_t1"] == null ? null : T.tfromJson(json["get_t1"]),
      getT2: json["get_t2"] == null ? null : T.tfromJson(json["get_t2"]),
      getT3: json["get_t3"] == null ? null : T.tfromJson(json["get_t3"]),
      getT4: json["get_t4"] == null ? null : T.tfromJson(json["get_t4"]),
      getT5: json["get_t5"] == null ? null : T.tfromJson(json["get_t5"]),
      getT6: json["get_t6"] == null ? null : T.tfromJson(json["get_t6"]),
      t: json["t"],
      id: json["id"],
      overtime: json["overtime"],
      userId: json["user_id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]));

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "date": date,
      "t1": getT1,
      "t2": getT2,
      "t3": getT3,
      "t4": getT4,
      "t5": getT5,
      "t6": getT6,
      "t": t,
      "overtime": overtime,
      "id": id,
      "user_id": userId,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class T {
  int id;
  TimeOfDay time;
  String? note;
  DateTime? createdAt;
  DateTime? updatedAt;
  T({
    required this.id,
    required this.time,
    required this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory T.tfromJson(Map<String, dynamic> json) => T(
        id: json["id"],
        time: TimeOfDay(
            hour: int.parse(json["time"].split(':')[0]),
            minute: int.parse(json["time"].split(':')[1])),
        note: json["note"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "time": time,
      "note": note,
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
