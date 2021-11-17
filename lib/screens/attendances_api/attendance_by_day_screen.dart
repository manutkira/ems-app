import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
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
  List<Attendance> attendanceDisplay = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);
  DateTime testdate = DateTime(10, 11, 2021);
  bool noData = true;
  List<Attendance> checkedDate = [];
  List<Attendance> users = [];

  @override
  void initState() {
    super.initState();
    _attendanceService.findMany().then((value) {
      setState(() {
        attendanceDisplay.addAll(value);
      });
    });
    _userService.findMany().then((value) {
      userDisplay.addAll(value);
    });
  }

  void checkDate(DateTime pick) {
    var checkingDate = attendanceDisplay.where((element) =>
        element.date!.day == pick.day &&
        element.date!.month == pick.month &&
        element.date!.year == pick.year);
    setState(() {
      users = checkingDate.toList();
      checkedDate = users;
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
    ).then((picked) {
      if (picked == null) {
        return;
      }
      checkDate(picked);
      setState(() {
        _selectDate = picked;

        noData = false;
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
                          'By Month',
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
        body: attendanceDisplay.isEmpty
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
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
                  Expanded(
                    child: noData
                        ? Container(
                            padding: EdgeInsets.only(top: 120),
                            child: Column(
                              children: [
                                Text(
                                  'NO DATE PICKED YET!!',
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
                        : Container(
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
                            child: checkedDate.isEmpty
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
                                          itemBuilder: (ctx, index) {
                                            return _listItem(index);
                                          },
                                          itemCount: checkedDate.length,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                  ),
                ],
              ));
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
                  checkedDate = users.where((user) {
                    var userName = user.users!.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          // PopupMenuButton(
          //   color: kDarkestBlue,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(10))),
          //   onSelected: (int selectedValue) {
          //     if (selectedValue == 0) {
          //       setState(() {
          //         userDisplay.sort((a, b) =>
          //             a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
          //       });
          //     }
          //     if (selectedValue == 1) {
          //       setState(() {
          //         userDisplay.sort((b, a) =>
          //             a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
          //       });
          //     }
          //     if (selectedValue == 2) {
          //       setState(() {
          //         userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
          //       });
          //     }
          //   },
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('From A-Z'),
          //       value: 0,
          //     ),
          //     PopupMenuItem(
          //       child: Text('From Z-A'),
          //       value: 1,
          //     ),
          //     PopupMenuItem(
          //       child: Text('by ID'),
          //       value: 2,
          //     ),
          //   ],
          //   icon: Icon(Icons.filter_list),
          // ),
        ],
      ),
    );
  }

  _listItem(index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
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
                      Text('Name: '),
                      Text(checkedDate[index].users!.name.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Text('ID: '),
                      Text(checkedDate[index].userId.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              padding: EdgeInsets.all(3),
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: checkedDate[index].type == 'check in' &&
                          checkedDate[index].date!.hour < 9
                      ? Color(0xff9CE29B)
                      : checkedDate[index].type == 'check in' &&
                              checkedDate[index].date!.hour > 8
                          ? Color(0xffF3FDB6)
                          : checkedDate[index].type == 'absent'
                              ? Color(0xffFFCBCE)
                              : Color(0xff77B1C9),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                checkedDate[index].type == 'check in' &&
                        checkedDate[index].date!.hour < 9
                    ? 'Present'
                    : checkedDate[index].type == 'check in' &&
                            checkedDate[index].date!.hour > 8
                        ? 'Late'
                        : checkedDate[index].type == 'absent'
                            ? 'Absent'
                            : 'Permission',
                style: TextStyle(
                  color: checkedDate[index].type == 'check in' &&
                          checkedDate[index].date!.hour < 9
                      ? Color(0xff334732)
                      : checkedDate[index].type == 'check in' &&
                              checkedDate[index].date!.hour > 8
                          ? Color(0xff5A5E45)
                          : checkedDate[index].type == 'absent'
                              ? Color(0xffA03E3E)
                              : Color(0xff313B3F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AttendancesByMonthScreen(),
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
}
