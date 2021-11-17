import 'package:flutter/material.dart';

import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../constants.dart';

class AttendanceByDayScreen extends StatefulWidget {
  @override
  _AttendanceByDayScreenState createState() => _AttendanceByDayScreenState();
}

class _AttendanceByDayScreenState extends State<AttendanceByDayScreen> {
  AttendanceService _attendanceService = AttendanceService().instance;
  List attendanceDisplay = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _attendanceService.findMany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Text('data'),
    );
  }
}
