import 'package:intl/intl.dart';

import 'package:ems/widgets/attendance_item.dart';
import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/attendance_list.dart';
import '../constants.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final color = const Color(0xff05445E);

  final color1 = const Color(0xff3B9AAD);

  DateTime? _selectDate;

  void _byDayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        _selectDate = picked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance History'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            FlatButton(
              child: Container(
                child: Row(
                  children: [
                    Text(
                      _selectDate == null
                          ? 'Pick a Date'
                          : 'Date: ${DateFormat.yMd().format(_selectDate as DateTime)}',
                      style: kHeadingFour,
                    ),
                    FlatButton(
                        onPressed: () => _byDayDatePicker(),
                        child: Text(
                          'Choose Date',
                          style: kParagraph,
                        ))
                  ],
                ),
              ),
              // style: ButtonStyle(
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(18),
              //             side: BorderSide(color: Colors.red)))),
              onPressed: () {},
            ),
            Expanded(
              flex: 5,
              child: Container(
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
                child: AttendanceList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
