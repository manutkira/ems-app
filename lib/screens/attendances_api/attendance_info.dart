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
  String dropDownValue = 'Morning';
  bool afternoon = false;
  dynamic countPresent = '';
  dynamic countPresentNoon = '';
  dynamic countLate = '';
  dynamic countLateNoon = '';
  dynamic countAbsent = '';
  dynamic countAbsentNoon = '';
  dynamic countPermission = '';
  dynamic countPermissionNoon = '';
  bool _isLoading = true;
  bool order = false;
  List<Appointment>? _appointment;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  fetchAttendance() async {
    try {
      List<AttendanceById> attendanceDisplay =
          await _overtimeService.findByUserId(userId: widget.id);
      // print('abc $attendanceDisplay');
      setState(() {
        _attendanceDisplay = attendanceDisplay;
      });
      // print('froms $_attendanceDisplay');
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

  getPresentNoon() async {
    var pc = await _attendanceService.countPresentNoon(widget.id);
    if (mounted) {
      setState(() {
        countPresentNoon = pc;
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

  getLateNoon() async {
    var pc = await _attendanceService.countLateNoon(widget.id);
    if (mounted) {
      setState(() {
        countLateNoon = pc;
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

  getAbsentNoon() async {
    var pc = await _attendanceService.countAbsentNoon(widget.id);
    if (mounted) {
      setState(() {
        countAbsentNoon = pc;
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

  getPermissionNoon() async {
    var pc = await _attendanceService.countPermissionNoon(widget.id);
    if (mounted) {
      setState(() {
        countPermissionNoon = pc;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    try {
      getPresent();
      getPresentNoon();
      getLate();
      getLateNoon();
      getAbsent();
      getAbsentNoon();
      getPermission();
      getPermissionNoon();
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
    if (attendance.checkin1!.date!.hour >= 7 &&
        attendance.checkin1!.date!.minute >= 16 &&
        attendance.checkin1!.code == 'cin1' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin1!.date!.hour >= 13 &&
        attendance.checkin1!.date!.minute >= 16 &&
        attendance.checkin1!.code == 'cin2' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin1!.date!.hour == 7 &&
        attendance.checkin1!.date!.minute <= 15 &&
        attendance.checkin1!.code == 'cin1' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.green;
    }
    if (attendance.checkin1!.code == 'cin3') {
      return Color(0xffd4d2bc);
    }
    if (attendance.checkin1!.date!.hour == 13 &&
        attendance.checkin1!.date!.minute <= 15 &&
        attendance.checkin1!.code == 'cin2' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    DateTime? startTime;
    DateTime? endTime;
    _attendanceDisplay.asMap().forEach((key, value) {
      Appointment newAppointment = Appointment(
        startTime: value.checkin1?.date as DateTime,
        endTime: value.checkout1?.date as DateTime,
        color: checkColor(value),
      );
      meetings.add(newAppointment);
    });
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: _isLoading
          ? Container(
              padding: const EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Fetching Data'),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            )
          : attendanceDisplay.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 200, left: 40),
                  child: Column(
                    children: [
                      Text(
                        'NO ATTENDANCE ADDED YET!!',
                        style: kHeadingThree.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
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
                                          borderRadius: const BorderRadius.all(
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
                                    margin: const EdgeInsets.only(
                                        left: 25, top: 35),
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
                                              const SizedBox(
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
                                          const SizedBox(
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
                                              const SizedBox(
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
                            borderRadius: const BorderRadius.only(
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
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kDarkestBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton(
                                underline: Container(),
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.bold),
                                isDense: true,
                                borderRadius:
                                    const BorderRadius.all(kBorderRadius),
                                dropdownColor: kDarkestBlue,
                                icon: const Icon(Icons.expand_more),
                                value: dropDownValue,
                                onChanged: (String? newValue) {
                                  if (newValue == 'Afternoon') {
                                    setState(() {
                                      afternoon = true;
                                      dropDownValue = newValue!;
                                    });
                                  }
                                  if (newValue == 'Morning') {
                                    setState(() {
                                      afternoon = false;
                                      dropDownValue = newValue!;
                                    });
                                  }
                                },
                                items: <String>[
                                  'Morning',
                                  'Afternoon',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 30),
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
                                              afternoon
                                                  ? countPresentNoon.toString()
                                                  : countPresent.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Permission: ',
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                          Text(
                                            afternoon
                                                ? countPermissionNoon.toString()
                                                : countPermission.toString(),
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 30),
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
                                              'Late: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              afternoon
                                                  ? countLateNoon.toString()
                                                  : countLate.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
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
                                            afternoon
                                                ? countAbsentNoon.toString()
                                                : countAbsent.toString(),
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              padding:
                                  const EdgeInsets.only(top: 40, right: 10),
                              child: SfCalendar(
                                view: CalendarView.month,
                                dataSource:
                                    MeetingDataSource(getAppointments()),
                                todayHighlightColor: Colors.grey,
                                headerHeight: 25,
                                scheduleViewSettings:
                                    const ScheduleViewSettings(
                                        appointmentTextStyle:
                                            TextStyle(color: Colors.black)),
                                cellBorderColor: Colors.grey,
                                allowedViews: const [
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
