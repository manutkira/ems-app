import 'package:ems/models/attendance.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:flutter/material.dart';

class TestService extends StatefulWidget {
  const TestService({Key? key}) : super(key: key);

  @override
  State<TestService> createState() => _TestServiceState();
}

class _TestServiceState extends State<TestService> {
  final AttendanceService attendanceService = AttendanceService.instance;
  List<AttendanceWithDate> att = [];

  fetchAttendances() async {
    List<AttendanceWithDate> atts = [];
    atts = await attendanceService.findManyNew();
    List<Attendance> att2 = attendancesFromAttendancesByDay(atts);
    print(att2);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: fetchAttendances,
            child: Text('what'),
          ),
        ),
      ),
    );
  }
}
