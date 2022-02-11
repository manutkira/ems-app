import 'package:ems/models/attendance.dart';
import 'package:ems/models/attendances.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  List<AttendancesWithUser> attendancedisplay = [];
  List userDisplay = [];
  List<User> users = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  String dropDownValue = '';
  bool afternoon = false;
  bool total = false;

  var _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  fetchAttendances() async {
    List<AttendancesWithDateWithUser> atts = [];
    atts = await _attendanceService.findMany();
    List<AttendancesWithUser> att2 =
        attendancesWithUsesrFromAttendancesbyDay(atts);
    setState(() {
      attendancedisplay = att2;
      print(attendancedisplay);
      attendancedisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

  checkLateNoon(Attendance element) {
    if (element.code == 'cin2') {
      if (element.type == 'checkin') {
        if (element.date!.hour == 13) {
          if (element.date!.minute >= 16) {
            return true;
          } else {
            return false;
          }
        } else if (element.date!.hour > 13) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresent(Attendance element) {
    if (element.code == 'cin1') {
      if (element.type == 'checkin') {
        if (element.date!.hour <= 7) {
          if (element.date!.minute <= 15) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkAbsent(Attendance element) {
    if (element.code == 'cin1') {
      if (element.type == 'absent') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkAbsentNoon(Attendance element) {
    if (element.code == 'cin2') {
      if (element.type == 'absent') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPermission(Attendance element) {
    if (element.code == 'cin1') {
      if (element.type == 'permission') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPermissionNoon(Attendance element) {
    if (element.code == 'cin2') {
      if (element.type == 'permission') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresentNoon(Attendance element) {
    if (element.code == 'cin2') {
      if (element.type == 'checkin') {
        if (element.date!.hour <= 13) {
          if (element.date!.minute <= 15) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate(Attendance element) {
    if (element.code == 'cin1') {
      if (element.type == 'checkin') {
        if (element.date!.hour == 7) {
          if (element.date!.minute >= 16) {
            return true;
          } else {
            return false;
          }
        } else if (element.date!.hour > 7) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
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
        });
      });
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    setState(() {
      if (dropDownValue.isEmpty) {
        dropDownValue = local!.morning;
      }
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('${local?.byAllTime}'),
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
                          '${local?.byDay}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.byMonth}',
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
                        Text('${local?.fetchData}'),
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
                                '${local?.employeeNotFound}',
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
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
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
              width: 60,
              height: 60,
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
                        width: 60,
                      )
                    : Image.network(
                        userDisplay[index].image.toString(),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 70,
                      ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 270,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaselineRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                            child: Text('${local?.name}: '),
                          ),
                          Text(
                            userDisplay[index].name.length >= 13
                                ? '${userDisplay[index].name.substring(0, 8).toString()}...'
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
                      BaselineRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                            child: Text('${local?.id}: '),
                          ),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          //   BaselineRow(
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             EdgeInsets.only(top: isEnglish ? 0 : 3),
                          //         child: Text('${local?.shortPresent}: '),
                          //       ),
                          //       total
                          //           ? Text((attendancedisplay
                          //                       .where(
                          //                         (element) =>
                          //                             element.userId ==
                          //                                 userDisplay[index].id &&
                          //                             checkPresentNoon(element),
                          //                       )
                          //                       .length +
                          //                   attendancedisplay
                          //                       .where(
                          //                         (element) =>
                          //                             element.userId ==
                          //                                 userDisplay[index].id &&
                          //                             checkPresent(element),
                          //                       )
                          //                       .length)
                          //               .toString())
                          //           : afternoon
                          //               ? Text(attendancedisplay
                          //                   .where(
                          //                     (element) =>
                          //                         element.userId ==
                          //                             userDisplay[index].id &&
                          //                         checkPresentNoon(element),
                          //                   )
                          //                   .length
                          //                   .toString())
                          //               : Text(attendancedisplay
                          //                   .where(
                          //                     (element) =>
                          //                         element.userId ==
                          //                             userDisplay[index].id &&
                          //                         checkPresent(element),
                          //                   )
                          //                   .length
                          //                   .toString()),
                          //     ],
                          //   ),
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          //   BaselineRow(
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             EdgeInsets.only(top: isEnglish ? 0 : 3),
                          //         child: Text('${local?.shortAbsent}: '),
                          //       ),
                          //       total
                          //           ? Text((attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkAbsentNoon(element))
                          //                       .length +
                          //                   attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkAbsent(element))
                          //                       .length)
                          //               .toString())
                          //           : afternoon
                          //               ? Text(
                          //                   attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkAbsentNoon(element))
                          //                       .length
                          //                       .toString(),
                          //                 )
                          //               : Text(
                          //                   attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkAbsent(element))
                          //                       .length
                          //                       .toString(),
                          //                 ),
                          //     ],
                          //   ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //   BaselineRow(
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             EdgeInsets.only(top: isEnglish ? 0 : 3),
                          //         child: Text('${local?.shortLate}: '),
                          //       ),
                          //       total
                          //           ? Text((attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkLateNoon(element))
                          //                       .length +
                          //                   attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkLate(element))
                          //                       .length)
                          //               .toString())
                          //           : afternoon
                          //               ? Text(attendancedisplay
                          //                   .where((element) =>
                          //                       element.userId ==
                          //                           userDisplay[index].id &&
                          //                       checkLateNoon(element))
                          //                   .length
                          //                   .toString())
                          //               : Text(attendancedisplay
                          //                   .where((element) =>
                          //                       element.userId ==
                          //                           userDisplay[index].id &&
                          //                       checkLate(element))
                          //                   .length
                          //                   .toString()),
                          //     ],
                          //   ),
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          //   BaselineRow(
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             EdgeInsets.only(top: isEnglish ? 0 : 3),
                          //         child: Text('${local?.shortPermission}: '),
                          //       ),
                          //       total
                          //           ? Text((attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkPermissionNoon(element))
                          //                       .length +
                          //                   attendancedisplay
                          //                       .where((element) =>
                          //                           element.userId ==
                          //                               userDisplay[index].id &&
                          //                           checkPermission(element))
                          //                       .length)
                          //               .toString())
                          //           : afternoon
                          //               ? Text(attendancedisplay
                          //                   .where((element) =>
                          //                       element.userId ==
                          //                           userDisplay[index].id &&
                          //                       checkPermissionNoon(element))
                          //                   .length
                          //                   .toString())
                          //               : Text(attendancedisplay
                          //                   .where((element) =>
                          //                       element.userId ==
                          //                           userDisplay[index].id &&
                          //                       checkPermission(element))
                          //                   .length
                          //                   .toString()),
                          //     ],
                          //   ),
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
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
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
                              return userName.contains(_controller.text);
                            }).toList();
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                hintText: '${local?.search}...',
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
              vertical: 8,
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
                if (newValue == '${local?.afternoon}') {
                  setState(() {
                    afternoon = true;
                    total = false;
                    dropDownValue = newValue!;
                  });
                }
                if (newValue == '${local?.morning}') {
                  setState(() {
                    afternoon = false;
                    total = false;
                    dropDownValue = newValue!;
                  });
                }
                if (newValue == '${local?.total}') {
                  setState(() {
                    afternoon = false;
                    total = true;
                    dropDownValue = newValue!;
                  });
                }
              },
              items: <String>[
                '${local?.morning}',
                '${local?.afternoon}',
                '${local?.total}',
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
