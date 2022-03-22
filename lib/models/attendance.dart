import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';

import 'user.dart';

List<AttendancesByDate> attendancesByDatesFromJson(Map<String, dynamic>? json) {
  if (json == null) return [];
  return json.entries
      .map((entry) => AttendancesByDate.fromJson(entry))
      .toList();
}

class AttendancesByDate {
  DateTime? date;
  List<Attendance>? attendances;

  AttendancesByDate({
    this.date,
    this.attendances,
  });

  factory AttendancesByDate.fromJson(MapEntry<String, dynamic>? entry) {
    return AttendancesByDate(
      date: convertStringToDateTime(entry?.key),
      attendances: attendancesFromJson(entry?.value),
    );
  }

  AttendancesByDate copyWith({
    DateTime? date,
    List<Attendance>? attendances,
  }) =>
      AttendancesByDate(
        date: date ?? this.date,
        attendances: attendances ?? this.attendances,
      );
}

List<Attendance> attendancesFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Attendance.fromJson(json)).toList();
}

class Attendance {
  int? id;
  int? userId;
  DateTime? date;
  double? total;
  Duration? overtime;
  User? user;
  AttendanceRecord? t1;
  AttendanceRecord? t2;
  AttendanceRecord? t3;
  AttendanceRecord? t4;
  AttendanceRecord? t5;
  AttendanceRecord? t6;

  Attendance({
    this.id,
    this.userId,
    this.overtime,
    this.user,
    this.date,
    this.total,
    this.t1,
    this.t2,
    this.t3,
    this.t4,
    this.t5,
    this.t6,
  });

  factory Attendance.fromJson(Map<String, dynamic>? json) => Attendance(
        id: intParse(json?['id']),
        userId: intParse(json?['user_id']),
        date: convertStringToDateTime(json?['date']),
        overtime: convertStringToDuration(json?['overtime']),
        total: doubleParse(json?['t']),
        user: User.fromJson(json?['users']),
        t1: json?['get_t1'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t1']),
        t2: json?['get_t2'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t2']),
        t3: json?['get_t3'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t3']),
        t4: json?['get_t4'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t4']),
        t5: json?['get_t5'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t5']),
        t6: json?['get_t6'] == null
            ? null
            : AttendanceRecord.fromJson(json?['get_t6']),
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "date": convertDateTimeToString(date),
      "overtime": convertDurationToString(overtime),
      "total": total,
      "t1": t1?.id,
      "t2": t2?.id,
      "t3": t3?.id,
      "t4": t4?.id,
      "t5": t5?.id,
      "t6": t6?.id,
    };
  }

  Attendance copyWith({
    int? id,
    int? userId,
    DateTime? date,
    double? total,
    Duration? overtime,
    User? user,
    AttendanceRecord? t1,
    AttendanceRecord? t2,
    AttendanceRecord? t3,
    AttendanceRecord? t4,
    AttendanceRecord? t5,
    AttendanceRecord? t6,
  }) =>
      Attendance(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        overtime: overtime ?? this.overtime,
        user: user ?? this.user,
        date: date ?? this.date,
        total: total ?? this.total,
        t1: t1 ?? this.t1,
        t2: t2 ?? this.t2,
        t3: t3 ?? this.t3,
        t4: t4 ?? this.t4,
        t5: t5 ?? this.t5,
        t6: t6 ?? this.t6,
      );
}

class AttendanceRecord {
  int? id;
  TimeOfDay? time;
  String? note;

  AttendanceRecord({
    this.id,
    this.time,
    this.note,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic>? json) =>
      AttendanceRecord(
        id: intParse(json?['id']),
        time: convertStringToTime(json?['time']),
        note: json?['note'],
      );

  AttendanceRecord copyWith({
    int? id,
    TimeOfDay? time,
    String? note,
  }) =>
      AttendanceRecord(
        id: id ?? this.id,
        time: time ?? this.time,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "time": convertTimeToString(time),
      "note": note,
    };
  }
}
