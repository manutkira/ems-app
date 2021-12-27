import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/screens/attendances_api/tap_screen.dart';
import 'package:ems/screens/attendances_api/tap_screen_month.dart';
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
  String dropDownValue = 'Morning';
  bool afternoon = false;

  var _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  fetchAttendances() async {
    List<AttendanceWithDate> atts = [];
    atts = await _attendanceService.findMany();
    List<Attendance> att2 = attendancesFromAttendancesByDay(atts);
    setState(() {
      attendancedisplay = att2;
      print(attendancedisplay);
      attendancedisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

  @override
  void initState() {
    super.initState();

    try {
      fetchAttendances();
      _userService.findMany().then((value) {
        setState(() {
          _isLoading = false;
          users.addAll(value);
          userDisplay = users;
          userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
          var pc = _attendanceService
              .countPresent(int.parse(users.map((e) => e.id).toString()));
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
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: userDisplay[index].image == null
                    ? Image.asset(
                        'assets/images/profile-icon-png-910.png',
                        width: 75,
                      )
                    : Image.network(
                        userDisplay[index].image.toString(),
                        fit: BoxFit.cover,
                        width: 65,
                        height: 75,
                      ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 240,
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
                              afternoon
                                  ? Text(attendancedisplay
                                      .where(
                                        (element) =>
                                            element.userId ==
                                                userDisplay[index].id &&
                                            element.type == 'checkin' &&
                                            element.code == 'cin2' &&
                                            element.date!.hour == 13 &&
                                            element.date!.minute <= 15,
                                      )
                                      .length
                                      .toString())
                                  : Text(attendancedisplay
                                      .where(
                                        (element) =>
                                            element.userId ==
                                                userDisplay[index].id &&
                                            element.type == 'checkin' &&
                                            element.code == 'cin1' &&
                                            element.date!.hour == 7 &&
                                            element.date!.minute <= 15,
                                      )
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
                              afternoon
                                  ? Text(
                                      attendancedisplay
                                          .where((element) =>
                                              element.userId ==
                                                  userDisplay[index].id &&
                                              element.code == 'cin2' &&
                                              element.type == 'absent')
                                          .length
                                          .toString(),
                                    )
                                  : Text(
                                      attendancedisplay
                                          .where((element) =>
                                              element.userId ==
                                                  userDisplay[index].id &&
                                              element.code == 'cin1' &&
                                              element.type == 'absent')
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('L:'),
                              afternoon
                                  ? Text(attendancedisplay
                                      .where((element) =>
                                          element.userId ==
                                              userDisplay[index].id &&
                                          element.code == 'cin2' &&
                                          element.type == 'checkin' &&
                                          element.date!.hour == 13 &&
                                          element.date!.minute <= 15)
                                      .length
                                      .toString())
                                  : Text(attendancedisplay
                                      .where((element) =>
                                          element.userId ==
                                              userDisplay[index].id &&
                                          element.code == 'cin1' &&
                                          element.type == 'checkin' &&
                                          element.date!.hour == 7 &&
                                          element.date!.minute <= 15)
                                      .length
                                      .toString()),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Text('E:'),
                          //     Text(attendancedisplay
                          //         .where((element) =>
                          //             element.userId == userDisplay[index].id &&
                          //             element.type == 'checkout' &&
                          //             element.code == 'cin1' &&
                          //             element.date!.hour > 8 &&
                          //             element.date!.hour < 17)
                          //         .length
                          //         .toString()),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            children: [
                              Text('PM:'),
                              afternoon
                                  ? Text(attendancedisplay
                                      .where((element) =>
                                          element.userId ==
                                              userDisplay[index].id &&
                                          element.code == 'cin2' &&
                                          element.type == 'permission')
                                      .length
                                      .toString())
                                  : Text(attendancedisplay
                                      .where((element) =>
                                          element.userId ==
                                              userDisplay[index].id &&
                                          element.code == 'cin1' &&
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
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: _controller.text.isEmpty
                    ? Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            clearText();
                            userDisplay = users.where((user) {
                              var userName = user.name!.toLowerCase();
                              print(userName);
                              return userName.contains(_controller.text);
                            }).toList();
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
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
          SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: kDarkestBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              underline: Container(),
              style: kParagraph.copyWith(fontWeight: FontWeight.bold),
              isDense: true,
              borderRadius: const BorderRadius.all(kBorderRadius),
              dropdownColor: kDarkestBlue,
              icon: const Icon(Icons.expand_more),
              value: dropDownValue,
              onChanged: (String? newValue) {
                if (newValue == 'Afternoon') {
                  setState(() {
                    afternoon = true;
                    dropDownValue = newValue!;
                  });
                }
                if (newValue == 'Morning') {
                  setState(() {
                    afternoon = false;
                    dropDownValue = newValue!;
                  });
                }
              },
              items: <String>[
                'Morning',
                'Afternoon',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
            builder: (context) => AttendanceByDayScreen(),
          ),
        );
        break;
    }
  }
}
