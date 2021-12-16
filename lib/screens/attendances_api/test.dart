import 'package:ems/constants.dart';
import 'package:ems/models/attendance_no_s.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:flutter/material.dart';

class Testscreen extends StatefulWidget {
  @override
  _TestscreenState createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
  // OvertimeAttendance overtimes = new OvertimeAttendance();
  // UserService _userService = UserService.instance;
  List<OvertimeAttendance> _overtimeDisplay = [];
  List<User> users = [];
  OvertimeService _overtimeAttendance = OvertimeService.instance;
  AttendanceByIdService _overtimeService = AttendanceByIdService.instance;
  List<AttendanceById> _attendanceDisplay = [];

  // getOvertime() async {
  //   var url =
  //       'http://rest-api-laravel-flutter.herokuapp.com/api/users/1/attendances/';
  //   var response = await get(Uri.parse(url), headers: {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   });
  //   var jsonData = jsonDecode(response.body);
  //
  //   // var overtime = OvertimeAttendances.fromMap(jsonData["data"]);
  //   var attendences = jsonData['data']['attendances'];
  //
  //   attendences.forEach((key, value) {
  //     OvertimeAttendance overtimeModel = new OvertimeAttendance();
  //     overtimes = OvertimeAttendance(
  //       checkin: OvertimeCheckin.fromMap(
  //         value[0],
  //       ),
  //       checkout: OvertimeCheckout.fromMap(
  //         value[1],
  //       ),
  //     );
  //     _overtimeDisplay.add(overtimes);
  //   });
  //
  //   setState(() {});
  // }

  fetchOvertime() async {
    try {
      List<OvertimeAttendance> overtimeDisplay = [];
      // await _overtimeAttendance.findManyByUserId(userId: 1);
      setState(() {
        _overtimeDisplay = overtimeDisplay;
      });
      print('from $_overtimeDisplay');
    } catch (e) {
      print('hihi $e');
    }
  }

  fetchAttendance() async {
    try {
      List<AttendanceById> attendanceDisplay =
          await _overtimeService.findByUserId(userId: 1);
      // print('abc $attendanceDisplay');
      setState(() {
        _attendanceDisplay = attendanceDisplay;
      });
      // print('froms $_attendanceDisplay');
      print(_attendanceDisplay.map((e) => e.checkin1!.type));
    } catch (e) {
      print('hehe $e');
    }
  }

  @override
  void initState() {
    // getOvertime();
    super.initState();
    fetchOvertime();
    fetchAttendance();
  }
  //
  // TimeOfDay _startTime = ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Overtime fetch test',
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            ..._overtimeDisplay.map(
              (e) {
                TimeOfDay _time = TimeOfDay(
                  hour: int.parse(e.checkout!.overtime!.split(":")[0]),
                  minute: int.parse(e.checkout!.overtime!.split(":")[1]),
                );

                return Card(
                  color: kDarkestBlue,
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text("${e.user!.name}"),
                        Text("${e.checkin!.date}"),
                        Text("${e.checkout!.date}"),
                        Text("${e.checkout!.overtime}"),
                        Text("${_time.hour}h ${_time.minute}mn"),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(

  //       body: users.isEmpty
  //           ? Container(
  //               padding: EdgeInsets.only(top: 300),
  //               child: Center(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'fetching data',
  //                       style: TextStyle(fontSize: 30),
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     CircularProgressIndicator(
  //                       backgroundColor: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       'Name: ',
  //                       style: TextStyle(fontSize: 20),
  //                     ),
  //                     Text(
  //                       users[0].name!,
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //                 Container(
  //                   height: 120,
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 24,
  //                     ),
  //                     itemBuilder: (ctx, index) {
  //                       return Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             'Overtime: ',
  //                             style: TextStyle(fontSize: 20),
  //                           ),
  //                           Text(_overtimeDisplay[index].checkout!.overtime!),
  //                         ],
  //                       );
  //                     },
  //                     itemCount: _overtimeDisplay.length,
  //                   ),
  //                 ),
  //               ],
  //             ));
  // }
}
