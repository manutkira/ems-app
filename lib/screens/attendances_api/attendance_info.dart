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
  dynamic countPresent = '';
  dynamic countLate = '';
  dynamic countAbsent = '';
  dynamic countPermission = '';
  bool _isLoading = true;
  bool order = false;
  List<Appointment>? _appointment;

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

  Color checkColor(Attendance attendance) {
    if (attendance.type == 'absent') {
      return Colors.red;
    }
    if (attendance.type == 'permission') {
      return Colors.blue;
    }
    if (attendance.type == 'check out') {
      return Colors.lightGreen;
    }
    if (attendance.date!.hour >= 9 && attendance.type == 'check in') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    attendanceDisplay.asMap().forEach((key, value) {
      if (value.type != 'check out') {
        Appointment newAppointment = Appointment(
            startTime: value.date as DateTime,
            endTime: value.date as DateTime,
            color: checkColor(value));
        meetings.add(newAppointment);
      }
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
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 139,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kLightBlue,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Expanded(
                                flex: 3,
                                child: Image.asset(
                                  'assets/images/profile-icon-png-910.png',
                                  width: 80,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 25),
                              child: Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'ID: ',
                                          style: kParagraph.copyWith(
                                              color: Colors.black),
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
                                              color: Colors.black),
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
                                              color: Colors.black),
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
                                              color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: kPaddingAll,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Present: ',
                                            style: kHeadingFour,
                                          ),
                                          Text(
                                            countPresent.toString(),
                                            style: kHeadingFour,
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Absent: ',
                                          style: kHeadingFour,
                                        ),
                                        Text(
                                          countAbsent.toString(),
                                          style: kHeadingFour,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Permission: ',
                                            style: kHeadingFour,
                                          ),
                                          Text(
                                            countPermission.toString(),
                                            style: kHeadingFour,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Late: ',
                                            style: kHeadingFour,
                                          ),
                                          Text(
                                            countLate.toString(),
                                            style: kHeadingFour,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Left Early: ',
                                          style: kHeadingFour,
                                        ),
                                        Text(
                                          attendanceDisplay
                                              .where((element) =>
                                                  // element.date!.hour < 8 &&
                                                  element.date!.hour < 16 &&
                                                  element.type == 'check out')
                                              .toList()
                                              .length
                                              .toString(),
                                          style: kHeadingFour,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 34, right: 10),
                            child: SfCalendar(
                              view: CalendarView.month,
                              dataSource: MeetingDataSource(getAppointments()),
                              todayHighlightColor: Colors.grey,
                              headerHeight: 22,
                              cellBorderColor: Colors.grey,
                              allowedViews: [
                                CalendarView.week,
                                CalendarView.month,
                              ],
                            ),
                          ),
                        ],
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
