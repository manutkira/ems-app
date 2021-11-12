import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../constants.dart';

class AttendancesInfoScreen extends StatefulWidget {
  final int id;

  AttendancesInfoScreen(this.id);
  @override
  _AttendancesInfoScreenState createState() => _AttendancesInfoScreenState();
}

class _AttendancesInfoScreenState extends State<AttendancesInfoScreen> {
  AttendanceService _attendanceService = AttendanceService().instance;
  List<Attendance> attendanceDisplay = [];
  bool _isLoading = true;
  bool order = false;

  @override
  void initState() {
    // _dataCollection = getAppointments();

    super.initState();

    try {
      _attendanceService
          .findManyByUserId(userId: widget.id)
          .then((usersFromServer) {
        setState(() {
          _isLoading = false;
          attendanceDisplay.addAll(usersFromServer);
          print(attendanceDisplay.map((e) => e.date));
        });
      });
    } catch (err) {
      //
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    final isAbsent = attendanceDisplay[0].date;
    final DateTime aStartTime =
        DateTime(isAbsent!.year, isAbsent.month, isAbsent.day, 8, 0, 0);
    final DateTime aEndTime = aStartTime.add(const Duration(hours: 8));
    final isPermission = attendanceDisplay[0].updatedAt;
    final DateTime pStartTime = DateTime(
        isPermission!.year, isPermission.month, isPermission.day, 8, 0, 0);
    final DateTime pEndTime = pStartTime.add(const Duration(hours: 5));
    meetings.add(Appointment(
      startTime: aStartTime,
      endTime: aEndTime,
      color: Colors.red,
    ));
    meetings.add(Appointment(
      startTime: pStartTime,
      endTime: pEndTime,
      color: Color(0xffAAFDA8),
    ));
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
                                      attendanceDisplay[0].users!.id.toString(),
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
                  height: MediaQuery.of(context).size.height * .57,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     color1,
                    //     color,
                    //   ],
                    // ),
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Present: ',
                                        style: kHeadingFour,
                                      ),
                                      Text(
                                        attendanceDisplay
                                            .where((element) =>
                                                element.userId == widget.id)
                                            .toList()
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                      attendanceDisplay
                                          .where((element) =>
                                              element.userId == widget.id)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Permission: ',
                                        style: kHeadingFour,
                                      ),
                                      Text(
                                        attendanceDisplay
                                            .where((element) =>
                                                element.userId == widget.id)
                                            .toList()
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Late: ',
                                      style: kHeadingFour,
                                    ),
                                    Text(
                                      attendanceDisplay
                                          .where((element) =>
                                              element.userId == widget.id)
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, right: 10),
                        child: SfCalendar(
                          view: CalendarView.month,
                          dataSource: MeetingDataSource(getAppointments()),
                          // loadMoreWidgetBuilder: (BuildContext context,
                          //     LoadMoreCallback loadMoreAppointments) {
                          //   return FutureBuilder(
                          //     future: loadMoreAppointments(),
                          //     builder: (context, snapshot) {
                          //       return Container(
                          //         alignment: Alignment.center,
                          //         child: CircularProgressIndicator(
                          //           valueColor:
                          //               AlwaysStoppedAnimation(Colors.blue),
                          //         ),
                          //       );
                          //     },
                          //   );
                          // },
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

  // @override
  // Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
  //   await Future.delayed(Duration(seconds: 1));
  //   final List<Appointment> meetings = <Appointment>[];
  //   DateTime appStartDate = startDate;
  //   DateTime appEndDate = endDate;

  //   while (appStartDate.isBefore(appEndDate)) {
  //     final List<Appointment>? data = _dataCollection[appStartDate];
  //     if (data == null) {
  //       appStartDate = appStartDate.add(Duration(days: 1));
  //       continue;
  //     }
  //     for (final Appointment meeting in data) {
  //       if (appointments!.contains(meeting)) {
  //         continue;
  //       }
  //       meetings.add(meeting);
  //     }
  //     appStartDate = appStartDate.add(Duration(days: 1));
  //   }
  //   appointments!.addAll(meetings);
  //   notifyListeners(CalendarDataSourceAction.add, meetings);
  // }
}
