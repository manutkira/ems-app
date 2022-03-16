import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../services/attendance.dart';
import '../../services/models/attendance.dart';

class AttendanceAllTimeScreen extends StatefulWidget {
  @override
  _AttendanceAllTimeScreenState createState() =>
      _AttendanceAllTimeScreenState();
}

class _AttendanceAllTimeScreenState extends State<AttendanceAllTimeScreen> {
  // services
  final AttendanceService _attendanceService = AttendanceService.instance;
  final UserService _userService = UserService.instance;

  // list attendances with user
  List<AttendancesByDate> attendancedisplay = [];
  List userDisplay = [];
  List<User> users = [];
  List<Attendance> attsList = [];

  // boolean
  bool _isLoading = true;
  bool afternoon = false;
  bool total = false;

  // variables
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  String dropDownValue = '';
  var _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  // fetch attendance from api
  fetchAttendances() async {
    List<AttendancesByDate> atts = [];
    atts = await _attendanceService.findMany();

    setState(() {
      List<Attendance> att = [];
      attendancedisplay = atts;
      attendancedisplay.sort((a, b) =>
          a.attendances![0].id!.compareTo(b.attendances![0].id as int));
      attendancedisplay
          .map((e) => e.attendances?.map((e) => att.add(e)).toList())
          .toList();
      attsList = att;
    });
  }

  // check attendance status
  checkPresent(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note != 'absent' && element.note != 'permission') {
      if (element.time!.hour == 7) {
        if (element.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.time!.hour < 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note != 'absent' && element.note != 'permission') {
      if (element.time!.hour == 13) {
        if (element.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.time!.hour < 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note != 'absent' && element.note != 'permission') {
      if (element.time!.hour == 7) {
        if (element.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.time!.hour > 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate2(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note != 'absent' && element.note != 'permission') {
      if (element.time!.hour == 13) {
        if (element.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.time!.hour > 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkAbsengetT1(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkAbsengetT2(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT1(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note == 'permission') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT2(AttendanceRecord? element) {
    if (element == null) {
      return false;
    }
    if (element.note == 'permission') {
      return true;
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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: const Color(0xff43c3c52),
                onSelected: (item) => onSelected(context, item as int),
                icon: const Icon(Icons.filter_list),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          '${local?.byDay}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.byMonth}',
                          style: const TextStyle(
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
              borderRadius: const BorderRadius.only(
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
                  padding: const EdgeInsets.only(top: 320),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local?.fetchData}'),
                        const SizedBox(
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
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Text(
                                '${local?.employeeNotFound}',
                                style: kHeadingThree.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
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
      padding: const EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
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
            const SizedBox(
              width: 10,
            ),
            SizedBox(
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
                      const SizedBox(
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
                          BaselineRow(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: isEnglish ? 0 : 3),
                                child: Text('${local?.shortPresent}: '),
                              ),
                              total
                                  ? Text((attsList
                                              .where(
                                                (element) =>
                                                    element.userId ==
                                                        userDisplay[index].id &&
                                                    element.t3 != null &&
                                                    checkPresengetT2(
                                                        element.t3),
                                              )
                                              .length +
                                          attsList
                                              .where(
                                                (element) =>
                                                    element.userId ==
                                                        userDisplay[index].id &&
                                                    element.t1 != null &&
                                                    checkPresent(element.t1),
                                              )
                                              .length)
                                      .toString())
                                  : afternoon
                                      ? Text(attsList
                                          .where(
                                            (element) =>
                                                element.userId ==
                                                    userDisplay[index].id &&
                                                element.t3 != null &&
                                                checkPresengetT2(element.t3),
                                          )
                                          .length
                                          .toString())
                                      : Text(attsList
                                          .where(
                                            (element) =>
                                                element.userId ==
                                                    userDisplay[index].id &&
                                                element.t1 != null &&
                                                checkPresent(element.t1),
                                          )
                                          .length
                                          .toString()),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BaselineRow(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: isEnglish ? 0 : 3),
                                child: Text('${local?.shortAbsent}: '),
                              ),
                              total
                                  ? Text((attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t3 != null &&
                                                  checkAbsengetT2(element.t3))
                                              .length +
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t1 != null &&
                                                  checkAbsengetT1(element.t1))
                                              .length)
                                      .toString())
                                  : afternoon
                                      ? Text(
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t3 != null &&
                                                  checkAbsengetT2(element.t3))
                                              .length
                                              .toString(),
                                        )
                                      : Text(
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t1 != null &&
                                                  checkAbsengetT1(element.t1))
                                              .length
                                              .toString(),
                                        ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaselineRow(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: isEnglish ? 0 : 3),
                                child: Text('${local?.shortLate}: '),
                              ),
                              total
                                  ? Text((attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t3 != null &&
                                                  checkLate2(element.t3))
                                              .length +
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t1 != null &&
                                                  checkLate1(element.t1))
                                              .length)
                                      .toString())
                                  : afternoon
                                      ? Text(attsList
                                          .where((element) =>
                                              element.userId ==
                                                  userDisplay[index].id &&
                                              element.t3 != null &&
                                              checkLate2(element.t3))
                                          .length
                                          .toString())
                                      : Text(
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t1 != null &&
                                                  checkLate1(element.t1))
                                              .length
                                              .toString(),
                                        ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BaselineRow(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: isEnglish ? 0 : 3),
                                child: Text('${local?.shortPermission}: '),
                              ),
                              total
                                  ? Text((attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t3 != null &&
                                                  checkPermissiongetT2(
                                                      element.t3))
                                              .length +
                                          attsList
                                              .where((element) =>
                                                  element.userId ==
                                                      userDisplay[index].id &&
                                                  element.t1 != null &&
                                                  checkPermissiongetT1(
                                                      element.t1))
                                              .length)
                                      .toString())
                                  : afternoon
                                      ? Text(attsList
                                          .where((element) =>
                                              element.userId ==
                                                  userDisplay[index].id &&
                                              element.t3 != null &&
                                              checkPermissiongetT2(element.t3))
                                          .length
                                          .toString())
                                      : Text(
                                          attsList
                                              .where(
                                                (element) =>
                                                    element.userId ==
                                                        userDisplay[index].id &&
                                                    element.t1 != null &&
                                                    checkPermissiongetT1(
                                                        element.t1),
                                              )
                                              .length
                                              .toString(),
                                        ),
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
    AppLocalizations? local = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: _controller.text.isEmpty
                    ? const Icon(
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
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                hintText: '${local?.search}...',
                errorStyle: const TextStyle(
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
          const SizedBox(
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
