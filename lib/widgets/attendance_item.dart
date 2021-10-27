import 'package:flutter/material.dart';

import '../models/attendance.dart';

class AttendanceItem extends StatelessWidget {
  final String name;
  final String id;
  final String status;

  AttendanceItem(
    this.name,
    this.id,
    this.status,
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Image.asset(
            'assets/images/profile-icon-png-910.png',
            width: 50,
          ),
          Text(name),
        ],
      ),
    );
  }
}
