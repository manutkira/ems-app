import 'package:ems/services/models/user.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

List<OvertimesByDate> overtimesByDatesFromJson(Map<String, dynamic>? json) {
  if (json == null) return [];

  return json.entries.map((entry) => OvertimesByDate.fromJson(entry)).toList();
}

class OvertimesByDate {
  DateTime? date;
  List<Overtime>? overtimes;

  OvertimesByDate({
    this.date,
    this.overtimes,
  });

  factory OvertimesByDate.fromJson(MapEntry<String, dynamic>? entry) {
    return OvertimesByDate(
      date: convertStringToDateTime(entry?.key),
      overtimes: overtimesFromJson(entry?.value),
    );
  }

  OvertimesByDate copyWith({
    DateTime? date,
    List<Overtime>? overtimes,
  }) {
    return OvertimesByDate(
      date: date ?? this.date,
      overtimes: overtimes ?? this.overtimes,
    );
  }
}

List<Overtime> overtimesFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Overtime.fromJson(json)).toList();
}

class Overtime {
  int? id;
  int? userId;
  User? user;
  DateTime? date;
  TimeOfDay? overtime;
  AttendanceRecord? checkIn;
  AttendanceRecord? checkOut;

  Overtime({
    this.id,
    this.userId,
    this.user,
    this.date,
    this.overtime,
    this.checkIn,
    this.checkOut,
  });

  factory Overtime.fromJson(Map<String, dynamic>? json) {
    return Overtime(
      id: int.tryParse("${json?['id']}"),
      userId: int.tryParse("${json?['user_id']}"),
      user: User.fromJson(json?['users']),
      date: convertStringToDateTime(json?['date']),
      overtime: convertStringToTime(json?['overtime']),
      checkIn: AttendanceRecord.fromJson(json?['get_t5']),
      checkOut: AttendanceRecord.fromJson(json?['get_t6']),
    );
  }

  Overtime copyWith({
    int? id,
    int? userId,
    User? user,
    DateTime? date,
    TimeOfDay? overtime,
    AttendanceRecord? checkIn,
    AttendanceRecord? checkOut,
  }) {
    return Overtime(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      date: date ?? this.date,
      overtime: overtime ?? this.overtime,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }
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

  factory AttendanceRecord.fromJson(Map<String, dynamic>? json) {
    return AttendanceRecord(
      id: json?['id'],
      time: convertStringToTime(json?['time']),
      note: json?['note'],
    );
  }
}
