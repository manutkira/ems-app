import 'package:flutter/material.dart';

class Attendance {
  final String name;
  final String id;
  final String status;
  final Color textColor;
  final Color bgColor;

  const Attendance(
      {required this.name,
      required this.id,
      required this.status,
      required this.textColor,
      required this.bgColor});
}
