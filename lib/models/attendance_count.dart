import 'package:flutter/material.dart';

import 'package:ems/models/user.dart';

class AttendanceCount {
  MAT morning;
  MAT afternoon;
  MAT total;
  User? user;
  AttendanceCount({
    required this.morning,
    required this.afternoon,
    required this.total,
    this.user,
  });

  factory AttendanceCount.fromJson(Map<String, dynamic> json) =>
      AttendanceCount(
        morning: MAT.fromJson(json["morning"]),
        afternoon: MAT.fromJson(json["afternoon"]),
        total: MAT.fromJson(json["total"]),
      );

  AttendanceCount copyWith({
    MAT? morning,
    MAT? afternoon,
    MAT? total,
    User? user,
  }) {
    return AttendanceCount(
      morning: morning ?? this.morning,
      afternoon: afternoon ?? this.afternoon,
      total: total ?? this.total,
      user: user == null ? this.user : user.copyWith(),
    );
  }
}

class MAT {
  int present;
  int late;
  MAT({
    required this.present,
    required this.late,
  });

  factory MAT.fromJson(Map<String, dynamic> json) => MAT(
        present: json["present"],
        late: json["late"],
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "present": present,
      "late": late,
    };
  }
}
