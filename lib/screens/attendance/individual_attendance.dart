import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../dummy_data.dart';
import '../../constants.dart';

class IndividualAttendanceScreen extends StatelessWidget {
  static const routeName = '/individual-attendance';

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xff05445E);

    const color1 = const Color(0xff3B9AAD);
    final routeAgrs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final attendanceId = routeAgrs['id'] as String;
    final individualAtt =
        individualAttendance.where((att) => att.id == attendanceId).toList();

    List<Appointment> getAppointments() {
      List<Appointment> meetings = <Appointment>[];
      final isAbsent = individualAtt[0].isAbsent;
      final DateTime aStartTime =
          DateTime(isAbsent.year, isAbsent.month, isAbsent.day, 8, 0, 0);
      final DateTime aEndTime = aStartTime.add(const Duration(hours: 8));
      final isPermission = individualAtt[0].isPermission;
      final DateTime pStartTime = DateTime(
          isPermission.year, isPermission.month, isPermission.day, 8, 0, 0);
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Attendance'),
      ),
      body: Column(
        children: [
          Container(
            padding: kPaddingAll.copyWith(top: 30, bottom: 30),
            margin: kPaddingAll,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.all(kBorderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/profile-icon-png-910.png',
                  width: 85,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ',
                          style: kParagraph.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Name: ',
                          style: kParagraph.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          individualAtt[0].id,
                          style: kParagraph.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          individualAtt[0].name,
                          style: kParagraph.copyWith(color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: kPaddingAll,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .57,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color1,
                  color,
                ],
              ),
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
                                  individualAtt[0].totalPresent,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                individualAtt[0].totalAbsent,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                  individualAtt[0].totalPermission,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                individualAtt[0].totalLate,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
