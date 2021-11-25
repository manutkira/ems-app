import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/services/attendance_service.dart';

class AttendanceAllTimeScreen extends StatefulWidget {
  @override
  _AttendanceAllTimeScreenState createState() =>
      _AttendanceAllTimeScreenState();
}

class _AttendanceAllTimeScreenState extends State<AttendanceAllTimeScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  UserService _userService = UserService.instance;
  dynamic countPresent = '';

  List attendancedisplay = [];
  List userDisplay = [];
  List<User> users = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  @override
  void initState() {
    super.initState();

    try {
      _attendanceService.findMany().then((userFromServer) {
        setState(() {
          _isLoading = false;
          attendancedisplay.addAll(userFromServer);
          // attendancedisplay.sort((a, b) => a.id!.compareTo(b.id as int));
        });
      });
      _userService.findMany().then((value) {
        setState(() {
          _isLoading = false;
          users.addAll(value);
          userDisplay = users;
          var pc = _attendanceService
              .countPresent(int.parse(users.map((e) => e.id).toString()));
          //     .then((value) {
          //   setState(() {
          //     _isLoading = false;
          //     print(value);
          //     // countPresent = value;
          //   });
          // });
          if (mounted) {
            setState(() {
              countPresent = pc;
              print(countPresent);
            });
          }
        });
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Attendance'),
          actions: [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Color(0xff43c3c52),
                onSelected: (item) => onSelected(context, item as int),
                icon: Icon(Icons.filter_list),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          'By Day',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'By Month',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 0,
                      ),
                    ])
          ],
        ),
        body: Container(
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
          child: _isLoading
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
              : userDisplay.isEmpty
                  ? Column(
                      children: [
                        _searchBar(),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Text(
                                'Employee not found!!',
                                style: kHeadingThree.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Image.asset(
                                'assets/images/notfound.png',
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
                              // reverse: order,
                              itemCount: userDisplay.length,
                              itemBuilder: (context, index) {
                                return _listItem(index);
                              }),
                        ),
                      ],
                    ),
        ));
  }

  _listItem(index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: Container(
        width: double.infinity,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset(
                'assets/images/profile-icon-png-910.png',
                width: 65,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 260,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Name: '),
                          Text(
                            userDisplay[index].name.length >= 13
                                ? '${userDisplay[index].name.substring(0, 11).toString()}...'
                                : userDisplay[index]
                                    .name
                                    // .substring(
                                    //     userDisplay[index].name.length - 7)
                                    .toString(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('ID: '),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('P:'),
                              // Text(countPresent.toString())
                              Text(attendancedisplay
                                  .where((element) =>
                                      element.userId == userDisplay[index].id &&
                                      element.type == 'check in' &&
                                      element.date!.hour < 9)
                                  .length
                                  .toString()),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('A:'),
                              Text(attendancedisplay
                                  .where((element) =>
                                      element.userId == userDisplay[index].id &&
                                      element.type == 'absent')
                                  .length
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('L:'),
                              Text(attendancedisplay
                                  .where((element) =>
                                      element.userId == userDisplay[index].id &&
                                      element.type == 'check in' &&
                                      element.date!.hour > 8)
                                  .length
                                  .toString()),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('E:'),
                              Text(attendancedisplay
                                  .where((element) =>
                                      element.userId == userDisplay[index].id &&
                                      element.type == 'check out' &&
                                      element.date!.hour > 8 &&
                                      element.date!.hour < 17)
                                  .length
                                  .toString()),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('PM:'),
                              Text(attendancedisplay
                                  .where((element) =>
                                      element.userId == userDisplay[index].id &&
                                      element.type == 'permission')
                                  .length
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
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
            builder: (context) => AttendanceByDayScreen(),
          ),
        );
        break;
    }
  }
}
