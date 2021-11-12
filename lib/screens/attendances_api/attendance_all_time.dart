import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../constants.dart';

class AttendanceAllTimeScreen extends StatefulWidget {
  @override
  _AttendanceAllTimeScreenState createState() =>
      _AttendanceAllTimeScreenState();
}

class _AttendanceAllTimeScreenState extends State<AttendanceAllTimeScreen> {
  AttendanceService _attendanceService = AttendanceService().instance;
  UserService _userService = UserService().instance;

  List<Attendance> attendancedisplay = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // try {
    //   _attendanceService.findAll().then((userFromServer) {
    // setState(() {
    //   _isLoading = false;
    //   attendancedisplay.addAll(userFromServer);
    //   // attendancedisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    // });
    //   });
    // } catch (err) {
    //   print(err);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return Center(
            child: Text('attendancedisplay[index].users!.name.toString()'),
          );
        },
        itemCount: attendancedisplay.length,
      ),
    );
  }
}
