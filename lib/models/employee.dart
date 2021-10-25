import 'package:flutter/material.dart';

class Employee {
  final String name;
  final String id;
  final DateTime date;
  final String skill;
  final double salary;
  final String workRate;
  final int contact;
  final String background;

  Employee({
    required this.name,
    required this.id,
    required this.date,
    required this.skill,
    required this.salary,
    required this.workRate,
    required this.contact,
    required this.background,
  });
}
