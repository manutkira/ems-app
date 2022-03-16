import 'package:ems/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/attendance.dart';
import '../../services/models/attendance.dart';

class AttendanceCalendar extends StatefulWidget {
  final int id;
  const AttendanceCalendar({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  bool _isLoadingById = true;

  // fetch attendance
  final AttendanceService _attendanceService = AttendanceService.instance;
  List<AttendancesByDate> attendancesByIdDisplay = [];
  fetchAttedancesById() async {
    _isLoadingById = true;
    try {
      _isLoadingById = true;
      List<AttendancesByDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(
        widget.id,
      );
      setState(() {
        attendancesByIdDisplay = attendanceDisplay;

        _isLoadingById = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  // check attendance status
  checkPresent(AttendancesByDate element) {
    if (element.attendances![0].t1?.note != 'absent' &&
        element.attendances![0].t1?.note != 'permission') {
      if (element.attendances![0].t1!.time!.hour == 7) {
        if (element.attendances![0].t1!.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t1!.time!.hour < 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesByDate element) {
    if (element.attendances![0].t3?.note != 'absent' &&
        element.attendances![0].t3?.note != 'permission') {
      if (element.attendances![0].t3!.time!.hour == 13) {
        if (element.attendances![0].t3!.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t3!.time!.hour < 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesByDate element) {
    if (element.attendances![0].t1?.note != 'absent' &&
        element.attendances![0].t1?.note != 'permission') {
      if (element.attendances![0].t1!.time!.hour == 7) {
        if (element.attendances![0].t1!.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t1!.time!.hour > 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate2(AttendancesByDate element) {
    if (element.attendances![0].t3?.note != 'absent' &&
        element.attendances![0].t3?.note != 'permission') {
      if (element.attendances![0].t3!.time!.hour == 13) {
        if (element.attendances![0].t3!.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t3!.time!.hour > 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // attendance event list
  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    List<AttendancesByDate> attendancesDisplay = attendancesByIdDisplay
        .where((element) => element.attendances![0].t1 != null)
        .toList();

    attendancesDisplay.forEach((element) {
      final DateTime date = element.date!;
      final DateTime startTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t1?.time!.hour as int,
        element.attendances![0].t1?.time!.minute as int,
      );
      final DateTime endTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t2?.time!.hour == null
            ? element.attendances![0].t1?.time!.hour as int
            : element.attendances![0].t2?.time!.hour as int,
        element.attendances![0].t2?.time!.minute == null
            ? element.attendances![0].t1?.time!.minute as int
            : element.attendances![0].t2?.time!.minute as int,
      );
      meetings.add(
        Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: 'Morning',
            color: checkPresent(element)
                ? kGreenBackground
                : checkLate1(element)
                    ? kYellowBackground
                    : Colors.lightBlue),
      );
    });

    List<AttendancesByDate> attendancesDisplay2 = attendancesByIdDisplay
        .where((element) => element.attendances![0].t3 != null)
        .toList();

    attendancesDisplay2.forEach((element) {
      final DateTime date = element.date!;
      final DateTime startTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t3?.time!.hour as int,
        element.attendances![0].t3?.time!.minute as int,
      );
      final DateTime endTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t4?.time!.hour == null
            ? element.attendances![0].t3?.time!.hour as int
            : element.attendances![0].t4?.time!.hour as int,
        element.attendances![0].t4?.time!.minute == null
            ? element.attendances![0].t3?.time!.minute as int
            : element.attendances![0].t4?.time!.minute as int,
      );

      meetings.add(
        Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: 'Afternoon',
            color: checkPresengetT2(element)
                ? kGreenBackground
                : checkLate2(element)
                    ? kYellowBackground
                    : Colors.red),
      );
    });

    List<AttendancesByDate> attendancesDisplay3 = attendancesByIdDisplay
        .where((element) => element.attendances![0].t5 != null)
        .toList();
    attendancesDisplay3.forEach((element) {
      final DateTime date = element.date!;
      final DateTime startTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t5?.time!.hour as int,
        element.attendances![0].t5?.time!.minute as int,
      );
      final DateTime endTime = DateTime(
        date.year,
        date.month,
        date.day,
        element.attendances![0].t6?.time!.hour == null
            ? element.attendances![0].t5?.time!.hour as int
            : element.attendances![0].t6?.time!.hour as int,
        element.attendances![0].t6?.time!.minute == null
            ? element.attendances![0].t5?.time!.minute as int
            : element.attendances![0].t6?.time!.minute as int,
      );

      meetings.add(
        Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: 'Overtime',
            color: kBlueBackground),
      );
    });

    return meetings;
  }

  @override
  void initState() {
    super.initState();
    fetchAttedancesById();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('${local?.calendarAttendance}'),
        ),
        body: _isLoadingById
            ? Container(
                padding: const EdgeInsets.only(top: 320),
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('loading'),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/images/Gear-0.5s-200px.gif',
                        width: 60,
                      )
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    SfCalendar(
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(getAppointments()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SfCalendar(
                      scheduleViewSettings: const ScheduleViewSettings(
                        monthHeaderSettings: MonthHeaderSettings(
                          monthFormat: 'MMMM yyyy',
                          height: 100,
                          textAlign: TextAlign.start,
                        ),
                        hideEmptyScheduleWeek: true,
                        appointmentItemHeight: 60,
                        appointmentTextStyle: TextStyle(
                          color: kGreenText,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      headerHeight: 1,
                      view: CalendarView.schedule,
                      dataSource: MeetingDataSource(getAppointments()),
                    ),
                  ],
                ),
              ));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
