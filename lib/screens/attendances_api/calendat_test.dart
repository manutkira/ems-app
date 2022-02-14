import 'package:ems/constants.dart';
import 'package:ems/models/attendances.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  // calendar
  List<Appointment>? _appointments;
  CalendarDataSource? _dataSource;

  // fetch attendance
  final AttendanceService _attendanceService = AttendanceService.instance;
  List<AttendancesWithDate> attendancesByIdDisplay = [];
  fetchAttedancesById() async {
    _isLoadingById = true;
    try {
      _isLoadingById = true;
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(
        userId: widget.id,
      );
      setState(() {
        attendancesByIdDisplay = attendanceDisplay;

        _isLoadingById = false;
      });
    } catch (err) {}
  }

  checkPresent(AttendancesWithDate element) {
    if (element.list[0].getT1?.note != 'absent' &&
        element.list[0].getT1?.note != 'permission') {
      if (element.list[0].getT1!.time.hour == 7) {
        if (element.list[0].getT1!.time.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT1!.time.hour < 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesWithDate element) {
    if (element.list[0].getT3?.note != 'absent' &&
        element.list[0].getT3?.note != 'permission') {
      if (element.list[0].getT3!.time.hour == 13) {
        if (element.list[0].getT3!.time.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT3!.time.hour < 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesWithDate element) {
    if (element.list[0].getT1?.note != 'absent' &&
        element.list[0].getT1?.note != 'permission') {
      if (element.list[0].getT1!.time.hour == 7) {
        if (element.list[0].getT1!.time.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT1!.time.hour > 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate2(AttendancesWithDate element) {
    if (element.list[0].getT3?.note != 'absent' &&
        element.list[0].getT3?.note != 'permission') {
      if (element.list[0].getT3!.time.hour == 13) {
        if (element.list[0].getT3!.time.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT3!.time.hour > 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    List<AttendancesWithDate> attendancesDisplay = attendancesByIdDisplay
        .where((element) => element.list[0].getT1 != null)
        .toList();
    attendancesDisplay.forEach((element) {
      final DateTime testDate = element.date;
      final DateTime startTime = DateTime(
        testDate.year,
        testDate.month,
        testDate.day,
        element.list[0].getT1?.time.hour as int,
        element.list[0].getT1?.time.minute as int,
      );
      final DateTime endTime = DateTime(
        testDate.year,
        testDate.month,
        testDate.day,
        element.list[0].getT2?.time.hour == null
            ? element.list[0].getT1?.time.hour as int
            : element.list[0].getT2?.time.hour as int,
        element.list[0].getT2?.time.minute == null
            ? element.list[0].getT1?.time.minute as int
            : element.list[0].getT2?.time.minute as int,
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

    List<AttendancesWithDate> attendancesDisplay2 = attendancesByIdDisplay
        .where((element) => element.list[0].getT3 != null)
        .toList();

    attendancesDisplay2.forEach((element) {
      final DateTime testDate = element.date;
      final DateTime startTime = DateTime(
        testDate.year,
        testDate.month,
        testDate.day,
        element.list[0].getT3?.time.hour as int,
        element.list[0].getT3?.time.minute as int,
      );
      final DateTime endTime = DateTime(
        testDate.year,
        testDate.month,
        testDate.day,
        element.list[0].getT4?.time.hour == null
            ? element.list[0].getT3?.time.hour as int
            : element.list[0].getT4?.time.hour as int,
        element.list[0].getT4?.time.minute == null
            ? element.list[0].getT3?.time.minute as int
            : element.list[0].getT4?.time.minute as int,
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
                    : Colors.lightBlue),
      );
    });
    return meetings;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAttedancesById();
  }

  @override
  Widget build(BuildContext context) {
    List<AttendancesWithDate> attendancesDisplay = attendancesByIdDisplay
        .where((element) => element.list[0].getT1 != null)
        .toList();
    List<AttendancesWithDate> attendancesDisplay2 = attendancesByIdDisplay
        .where((element) => element.list[0].getT3 != null)
        .toList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
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
                      scheduleViewSettings: ScheduleViewSettings(
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
