import 'package:ems/models/attendance_no_s.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';

class AttendancesInfoScreen extends StatefulWidget {
  final int id;

  AttendancesInfoScreen(this.id);
  @override
  _AttendancesInfoScreenState createState() => _AttendancesInfoScreenState();
}

class _AttendancesInfoScreenState extends State<AttendancesInfoScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  List<Attendance> attendanceDisplay = [];

  AttendanceByIdService _overtimeService = AttendanceByIdService.instance;
  List<AttendanceById> _attendanceDisplay = [];

  dynamic countPresent = '';
  dynamic countLate = '';
  dynamic countAbsent = '';
  dynamic countPermission = '';
  bool _isLoading = true;
  bool order = false;
  List<Appointment>? _appointment;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

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

  getPresent() async {
    var pc = await _attendanceService.countPresent(widget.id);
    if (mounted) {
      setState(() {
        countPresent = pc;
      });
    }
  }

  getLate() async {
    var pc = await _attendanceService.countLate(widget.id);
    if (mounted) {
      setState(() {
        countLate = pc;
      });
    }
  }

  getAbsent() async {
    var pc = await _attendanceService.countAbsent(widget.id);
    if (mounted) {
      setState(() {
        countAbsent = pc;
      });
    }
  }

  getPermission() async {
    var pc = await _attendanceService.countPermission(widget.id);
    if (mounted) {
      setState(() {
        countPermission = pc;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    try {
      getPresent();
      getLate();
      getAbsent();
      getPermission();
      fetchAttendance();
      _attendanceService
          .findManyByUserId(userId: widget.id)
          .then((usersFromServer) {
        setState(() {
          _isLoading = false;
          attendanceDisplay.addAll(usersFromServer);
        });
      });
    } catch (err) {
      //
    }
  }

  Color checkColor(AttendanceById attendance) {
    if (attendance.checkin1!.type == 'absent') {
      return Colors.red;
    }
    if (attendance.checkin1!.type == 'permission') {
      return Colors.blue;
    }
    if (attendance.checkin1!.type == 'checkout') {
      return Colors.lightGreen;
    }
    if (attendance.checkin1!.date!.hour >= 9 &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin1!.date!.hour <= 9 &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.green;
    } else {
      return Colors.green;
    }
  }

  Color checkColor2(AttendanceById attendance) {
    if (attendance.checkin2!.type == 'absent') {
      return Colors.red;
    }
    if (attendance.checkin2!.type == 'permission') {
      return Colors.blue;
    }
    if (attendance.checkin2!.type == 'checkout') {
      return Colors.lightGreen;
    }
    if (attendance.checkin2!.date!.hour >= 9 &&
        attendance.checkin2!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin2!.date!.hour <= 9 &&
        attendance.checkin2!.type == 'checkin') {
      return Colors.green;
    } else {
      return Colors.green;
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    _attendanceDisplay.asMap().forEach((key, value) {
      Appointment newAppointment = Appointment(
          startTime: value.checkin1!.date as DateTime,
          endTime: value.checkout1!.date as DateTime,
          color: checkColor(value));
      Appointment newAppointment1 = Appointment(
          startTime: value.checkin2!.date as DateTime,
          endTime: value.checkout2!.date as DateTime,
          color: checkColor2(value));
      meetings.add(newAppointment);
      meetings.add(newAppointment1);
    });
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: _isLoading
          ? Container(
              padding: EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Fetching Data'),
                    SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            )
          : attendanceDisplay.isEmpty
              ? Container(
                  padding: EdgeInsets.only(top: 200, left: 40),
                  child: Column(
                    children: [
                      Text(
                        'NO ATTENDANCE ADDED YET!!',
                        style: kHeadingThree.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'assets/images/attendanceicon.png',
                        width: 220,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 150,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kLightBlue,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 30),
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.white,
                                          )),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: Image.network(
                                          attendanceDisplay[0].users!.image!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 75,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.only(left: 25, top: 35),
                                    child: Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'ID: ',
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 45,
                                              ),
                                              Text(
                                                attendanceDisplay[0]
                                                    .users!
                                                    .id
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Name: ',
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                attendanceDisplay[0]
                                                    .users!
                                                    .name
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 550,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                color1,
                                color,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 45),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Present: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              countPresent.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Absent: ',
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                          Text(
                                            countAbsent.toString(),
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 45),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Permission: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              countPermission.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Late: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              countLate.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding:
                                  const EdgeInsets.only(top: 40, right: 10),
                              child: SfCalendar(
                                view: CalendarView.month,
                                dataSource:
                                    MeetingDataSource(getAppointments()),
                                todayHighlightColor: Colors.grey,
                                headerHeight: 25,
                                scheduleViewSettings: ScheduleViewSettings(
                                    appointmentTextStyle:
                                        TextStyle(color: Colors.black)),
                                cellBorderColor: Colors.grey,
                                allowedViews: [
                                  CalendarView.month,
                                  CalendarView.schedule,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
