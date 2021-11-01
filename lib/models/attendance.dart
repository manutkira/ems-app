import 'package:flutter/material.dart';

class Attendance {
  final String name;
  final String id;
  final String status;
  final Color textColor;
  final Color bgColor;
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final int totalPermission;

  const Attendance({
    required this.name,
    required this.id,
    required this.status,
    required this.textColor,
    required this.bgColor,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalPermission,
  });
}
