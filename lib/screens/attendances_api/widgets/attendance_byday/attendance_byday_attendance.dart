import 'package:flutter/material.dart';

class AttendanceByDayAttendance extends StatelessWidget {
  final bool afternoon;
  List attendanceDisplay;
  List userDisplay;
  int index;
  DateTime selectMonth;
  String pickedYear;
  AttendanceByDayAttendance({
    Key? key,
    required this.afternoon,
    required this.attendanceDisplay,
    required this.userDisplay,
    required this.index,
    required this.selectMonth,
    required this.pickedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('L:'),
        afternoon
            ? Text(
                attendanceDisplay
                    .where((element) =>
                        (element.userId == userDisplay[index].id &&
                            element.date.month == selectMonth &&
                            element.code == 'cin2' &&
                            element.type == 'checkin' &&
                            element.date.hour == 13 &&
                            element.date.minute >= 16 &&
                            element.date.year == int.parse(pickedYear)))
                    .length
                    .toString(),
              )
            : Text(
                attendanceDisplay
                    .where((element) =>
                        (element.userId == userDisplay[index].id &&
                            element.date.month == selectMonth &&
                            element.code == 'cin1' &&
                            element.type == 'checkin' &&
                            element.date.hour >= 7 &&
                            element.date.minute >= 16 &&
                            element.date.year == int.parse(pickedYear)))
                    .length
                    .toString(),
              ),
      ],
    );
  }
}
