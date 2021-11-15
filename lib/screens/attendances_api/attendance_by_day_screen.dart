import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../constants.dart';

class AttendanceByDayScreen extends StatefulWidget {
  @override
  _AttendanceByDayScreenState createState() => _AttendanceByDayScreenState();
}

class _AttendanceByDayScreenState extends State<AttendanceByDayScreen> {
  AttendanceService _attendanceService = AttendanceService().instance;
  UserService _userService = UserService().instance;

  List userDisplay = [];
  List attendanceDisplay = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);
  DateTime testdate = DateTime(10, 11, 2021);

  @override
  void initState() {
    super.initState();
    _attendanceService.findMany().then((value) {
      attendanceDisplay.addAll(value);
      // print(attendanceDisplay.where((element) => (element.date.month == 11 &&
      //     element.type == 'check in' &&
      //     element.date.hour >= 9)));
    });
    _userService.findMany().then((value) {
      userDisplay.addAll(value);
    });
  }

  DateTime? _selectDate;

  void _byDayDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now(),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.year)
        .then((picked) {
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
        title: Text('Attendance'),
        actions: [
          PopupMenuButton(
              onSelected: (item) => onSelected(context, item as int),
              color: Colors.white,
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text(
                        'By Day',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'By All-Time',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'By Month',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: 2,
                    ),
                  ])
        ],
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
                        onPressed: () {
                          setState(() {
                            _byDayDatePicker();
                          });
                        },
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userDisplay.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 2))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/profile-icon-png-910.png',
                                width: 75,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Name: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        userDisplay[index].name.toString(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ID: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(userDisplay[index].id.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                                attendanceDisplay
                                    .where((element) {
                                      return element.userId ==
                                              userDisplay[index].id &&
                                          element.type == 'check in' &&
                                          element.date.day ==
                                              _selectDate?.day &&
                                          element.date.month ==
                                              _selectDate?.month &&
                                          element.date.year ==
                                              _selectDate?.year;
                                    })
                                    .map((e) => e.type)
                                    .toString(),
                                style: kParagraph),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      break;
    case 1:
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => AttendanceScreenByAllTime(),
      //   ),
      // );
      break;
    case 2:
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => AttendanceByMonthScreen(),
      //   ),
      // );
      break;
  }
}
