import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../constants.dart';
import '../../screens/attendances_api/attendance_by_day_screen.dart';
import '../../screens/attendances_api/attendance_all_time.dart';

class AttendancesByMonthScreen extends StatefulWidget {
  @override
  _AttendancesByMonthScreenState createState() =>
      _AttendancesByMonthScreenState();
}

class _AttendancesByMonthScreenState extends State<AttendancesByMonthScreen> {
  AttendanceService _attendanceService = AttendanceService().instance;
  UserService _userService = UserService().instance;

  List userDisplay = [];
  List attendanceDisplay = [];
  List<User> users = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
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
      users.addAll(value);
      userDisplay = users;
    });
  }

  DateTime? _selectDate;
  var _selectMonth;
  TextEditingController yearController = TextEditingController();
  var pickedYear = '2021';

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
                  ])
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 10),
              child: OutlineButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      title: Text('Pick a month'),
                      content: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Enter year'),
                                  controller: yearController,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 1;
                                          pickedYear = yearController.text;
                                          pickedYear =
                                              yearController.toString();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Jan'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 2;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Feb'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectMonth = 3;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Mar'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 4;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Apr'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 5;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('May'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectMonth = 6;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Jun'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 7;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Jul'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 8;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Aug'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectMonth = 9;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sep'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 10;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Oct'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectMonth = 11;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Nov'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectMonth = 12;
                                          pickedYear = yearController.text;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Dec'),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Text('Pick A Month'),
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            yearController.text.isEmpty
                ? Container(
                    padding: EdgeInsets.only(top: 150, left: 70),
                    child: Column(
                      children: [
                        Text(
                          'NO MONTH PiCKED YET!!',
                          style: kHeadingThree.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          'assets/images/no-data.jpeg',
                          width: 220,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    flex: 3,
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
                      child: userDisplay.isEmpty
                          ? Column(
                              children: [
                                _searchBar(),
                                Container(
                                  padding: EdgeInsets.only(top: 200),
                                  child: Column(
                                    children: [
                                      Text(
                                        'NO EMPLOYEE ADDED YET!!',
                                        style: kHeadingThree.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Image.asset(
                                        'assets/images/no-data.jpeg',
                                        width: 220,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _searchBar(),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: userDisplay.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 20),
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 2))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/profile-icon-png-910.png',
                                                  width: 65,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Name: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          userDisplay[index]
                                                                      .name
                                                                      .length >=
                                                                  13
                                                              ? '${userDisplay[index].name.substring(0, 11).toString()}...'
                                                              : userDisplay[
                                                                      index]
                                                                  .name
                                                                  // .substring(
                                                                  //     userDisplay[index].name.length - 7)
                                                                  .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'ID: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(userDisplay[index]
                                                            .id
                                                            .toString()),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                                child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('P:'),
                                                        Text(
                                                          attendanceDisplay
                                                              .where((element) {
                                                                return element
                                                                            .userId ==
                                                                        userDisplay[index]
                                                                            .id &&
                                                                    element.date
                                                                            .month ==
                                                                        _selectMonth &&
                                                                    element.type ==
                                                                        'check in' &&
                                                                    element.date
                                                                            .hour <
                                                                        9 &&
                                                                    element.date
                                                                            .year ==
                                                                        int.parse(
                                                                            pickedYear);
                                                              })
                                                              .length
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('A:'),
                                                        Text(
                                                          attendanceDisplay
                                                              .where((element) => (element
                                                                          .userId ==
                                                                      userDisplay[
                                                                              index]
                                                                          .id &&
                                                                  element.date.month ==
                                                                      _selectMonth &&
                                                                  element.type ==
                                                                      'absent' &&
                                                                  element.date
                                                                          .year ==
                                                                      int.parse(
                                                                          pickedYear)))
                                                              .length
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('L:'),
                                                        Text(
                                                          attendanceDisplay
                                                              .where((element) => (element
                                                                          .userId ==
                                                                      userDisplay[
                                                                              index]
                                                                          .id &&
                                                                  element.date.month ==
                                                                      _selectMonth &&
                                                                  element.type ==
                                                                      'check in' &&
                                                                  element.date
                                                                          .hour >
                                                                      8 &&
                                                                  element.date
                                                                          .year ==
                                                                      int.parse(
                                                                          pickedYear)))
                                                              .length
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('PM:'),
                                                        Text(
                                                          attendanceDisplay
                                                              .where((element) => (element
                                                                          .userId ==
                                                                      userDisplay[
                                                                              index]
                                                                          .id &&
                                                                  element.date.month ==
                                                                      _selectMonth &&
                                                                  element.type ==
                                                                      'permission' &&
                                                                  element.date
                                                                          .year ==
                                                                      int.parse(
                                                                          pickedYear)))
                                                              .length
                                                              .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search...',
                errorStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  userDisplay = users.where((user) {
                    var userName = user.name!.toLowerCase();
                    print(userName);
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AttendanceByDayScreen(),
        ),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AttendanceAllTimeScreen(),
        ),
      );
      break;
  }
}
