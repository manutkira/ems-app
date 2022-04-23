import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_week_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/services/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../services/attendance.dart';

// ignore: use_key_in_widget_constructors
class AttendanceByDayScreen extends StatefulWidget {
  @override
  _AttendanceByDayScreenState createState() => _AttendanceByDayScreenState();
}

class _AttendanceByDayScreenState extends State<AttendanceByDayScreen> {
  // services
  final AttendanceService _attendanceService = AttendanceService.instance;
  final UserService _userService = UserService.instance;

  // list attendances with user
  List<User> userDisplay = [];
  List<AttendancesByDate> attendanceDisplay = [];
  List<Attendance> checkedDate = [];
  List<Attendance> checkedDateNoon = [];
  List<Attendance> users = [];
  List<Attendance> usersNoon = [];
  List<Attendance> modified = [];
  List<User> user = [];

  // boolean
  bool noData = true;
  bool afternoon = false;

  // variable
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  DateTime testdate = DateTime(10, 11, 2021);
  String dropDownValue = '';
  final TextEditingController _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  // fetch attendances from api
  fetchAttendances() async {
    List<AttendancesByDate> atts = [];
    atts = await _attendanceService.findMany();

    setState(() {
      attendanceDisplay = atts;
      // attendanceDisplay.sort((a, b) =>
      //     a.id!.compareTo(b.id as num));
    });
  }

  fetchUser() async {
    List<User> userList = await _userService.findMany();
    setState(() {
      userDisplay = userList;
      user = userDisplay;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAttendances();
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

  // check date and filter from calendar
  void checkDate(DateTime pick) {
    List<Attendance> checkedT1 = [];
    var checkingDate = attendanceDisplay.where((element) {
      return element.date!.day == pick.day &&
          element.date!.month == pick.month &&
          element.date!.year == pick.year;
    }).toList();
    checkingDate
        .map((e) => e.attendances?.map((e) {
              if (e.t1 != null) {
                checkedT1.add(e);
                return;
              }
            }).toList())
        .toList();
    setState(() {
      users = checkedT1;
      checkedDate = users;
      checkedDate.sort((a, b) => a.userId!.compareTo(b.userId!));
    });
  }

  void checkDateNoon(DateTime pick) {
    List<Attendance> checkedT3 = [];
    var checkingDate = attendanceDisplay
        .where((element) =>
            element.date!.day == pick.day &&
            element.date!.month == pick.month &&
            element.date!.year == pick.year)
        .toList();
    checkingDate
        .map((e) => e.attendances?.map((e) {
              if (e.t3 != null) {
                checkedT3.add(e);
              }
              return;
            }).toList())
        .toList();
    setState(() {
      usersNoon = checkedT3;
      checkedDateNoon = usersNoon;
      checkedDateNoon.sort((a, b) => a.userId!.compareTo(b.userId!));
    });
  }

  String checkAttendance(Attendance attendance) {
    AppLocalizations? local = AppLocalizations.of(context);
    if (checkPresent(attendance.t1)) {
      return '${local?.present}';
    }
    if (checkLate1(attendance.t1)) {
      return '${local?.late}';
    }
    if (checkPermissiongetT1(attendance.t1)) {
      return '${local?.permission}';
    }
    if (checkAbsengetT1(attendance.t1)) {
      return '${local?.absent}';
    } else {
      return '';
    }
  }

  String checkAttendanceNoon(Attendance attendance) {
    AppLocalizations? local = AppLocalizations.of(context);
    if (checkPresengetT2(attendance.t3)) {
      return '${local?.present}';
    }
    if (checkLate2(attendance.t3)) {
      return '${local?.late}';
    }
    if (checkPermissiongetT2(attendance.t3)) {
      return '${local?.permission}';
    }
    if (checkAbsengetT2(attendance.t3)) {
      return '${local?.absent}';
    } else {
      return '';
    }
  }

  DateTime? _selectDate;

  // date picker popup
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
      checkDateNoon(picked);
      setState(() {
        _selectDate = picked;

        noData = false;
      });
    });
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
          title: Text('${local?.byDay}'),
          actions: [_popUpMenu(context, local)],
        ),
        body: attendanceDisplay.isEmpty
            ? _fetchingData(local)
            : Column(
                children: [
                  _pickDateIconAndFilterMenu(local),
                  _plsPickAndPicked(local),
                ],
              ));
  }

// pls pick date msg and attendance list widget
  Expanded _plsPickAndPicked(AppLocalizations? local) {
    return Expanded(
      child: noData ? _plsPickDate(local) : _attendanceList(local),
    );
  }

// show attendance list after picked date
  Container _attendanceList(AppLocalizations? local) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
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
      child: !afternoon && checkedDate.isEmpty
          ? Column(
              children: [
                _searchBar(),
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Text(
                        '${local?.noAttendance}',
                        style: kHeadingThree.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'assets/images/attendanceicon.png',
                        width: 220,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : afternoon && checkedDateNoon.isEmpty
              ? Column(
                  children: [
                    _searchBar(),
                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Text(
                            '${local?.noAttendance}',
                            style: kHeadingThree.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/images/attendanceicon.png',
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
                        itemCount: afternoon
                            ? checkedDateNoon.length
                            : checkedDate.length,
                      ),
                    ),
                  ],
                ),
    );
  }

// show message to pick date
  Container _plsPickDate(AppLocalizations? local) {
    return Container(
      padding: const EdgeInsets.only(top: 140),
      child: Column(
        children: [
          Text(
            '${local?.plsPickDate}',
            style: kHeadingTwo.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/images/calendar.jpeg',
            width: 220,
          ),
        ],
      ),
    );
  }

// pick date button and filter morning/afternoon
  Padding _pickDateIconAndFilterMenu(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _selectDate == null
                ? '${local?.date}: _______'
                : '${local?.date}: ${DateFormat.yMd().format(_selectDate as DateTime)}',
            style: kParagraph.copyWith(fontSize: 14),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 7, right: 7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // elevation: 10,
            color: kDarkestBlue,
            onPressed: () {
              setState(
                () {
                  _byDayDatePicker();
                },
              );
            },
            child: Text(
              '${local?.pickDate}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
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
                    dropDownValue = newValue!;
                  });
                }
                if (newValue == '${local?.morning}') {
                  setState(() {
                    afternoon = false;
                    dropDownValue = newValue!;
                  });
                }
              },
              items: <String>[
                '${local?.morning}',
                '${local?.afternoon}',
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

// fetching and loading widget
  Container _fetchingData(AppLocalizations? local) {
    return Container(
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
    );
  }

// icon to navigate to other screen
  PopupMenuButton<int> _popUpMenu(
      BuildContext context, AppLocalizations? local) {
    return PopupMenuButton(
        color: kBlack,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onSelected: (item) => onSelected(context, item as int),
        icon: const Icon(Icons.filter_list),
        itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  '${local?.byWeek}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 2,
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
              PopupMenuItem(
                child: Text(
                  '${local?.byAllTime}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 1,
              ),
            ]);
  }

// searchBar to search employee list
  _searchBar() {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
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

                            setState(() {
                              if (!afternoon) {
                                checkedDate = users;
                              }
                              if (afternoon) {
                                checkedDateNoon = usersNoon;
                              }
                            });
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
              onChanged: (value) {
                if (value.isEmpty) {
                  if (afternoon) {
                    checkedDateNoon = usersNoon;
                  }
                  if (!afternoon) {
                    checkedDate = users;
                  }
                }
                setState(() {
                  if (!afternoon) {
                    checkedDate = users
                        .where((element) => element.user!.name!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }
                  if (afternoon) {
                    checkedDateNoon = usersNoon
                        .where((element) => element.user!.name!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  checkedDate.sort((a, b) => a.user!.name!
                      .toLowerCase()
                      .compareTo(b.user!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  checkedDate.sort((b, a) => a.user!.name!
                      .toLowerCase()
                      .compareTo(b.user!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  checkedDate.sort((a, b) => a.userId!.compareTo(b.userId!));
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  '${local?.fromAtoZ}',
                  style: TextStyle(
                    fontSize: isEnglish ? 15 : 16,
                  ),
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.fromZtoA}',
                  style: TextStyle(
                    fontSize: isEnglish ? 15 : 16,
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.byId}',
                  style: TextStyle(
                    fontSize: isEnglish ? 15 : 16,
                  ),
                ),
                value: 2,
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
    );
  }

// employee list widget
  _listItem(index) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: afternoon
                      ? checkedDateNoon[index].user!.image == null
                          ? Image.asset(
                              'assets/images/profile-icon-png-910.png')
                          : Image.network(
                              checkedDateNoon[index].user!.image.toString(),
                              fit: BoxFit.cover,
                              height: 75,
                            )
                      : checkedDate[index].user?.image == null
                          ? Image.asset(
                              'assets/images/profile-icon-png-910.png')
                          : Image.network(
                              checkedDate[index].user!.image.toString(),
                              fit: BoxFit.cover,
                              height: 75,
                            ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaselineRow(
                    children: [
                      Text(
                        '${local?.name}: ',
                        style: TextStyle(
                          fontSize: isEnglish ? 15 : 15,
                        ),
                      ),
                      Text(
                        afternoon
                            ? checkedDateNoon[index].user!.name.toString()
                            : checkedDate[index].user!.name.toString(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: isEnglish ? 8 : 0,
                  ),
                  BaselineRow(
                    children: [
                      Text(
                        '${local?.id}: ',
                        style: TextStyle(
                          fontSize: isEnglish ? 15 : 15,
                        ),
                      ),
                      Text(
                        afternoon
                            ? checkedDateNoon[index].user!.id.toString()
                            : checkedDate[index].userId.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.all(3),
              width: 80,
              alignment: Alignment.center,
              decoration: afternoon
                  ? BoxDecoration(
                      color: checkPresengetT2(checkedDateNoon[index].t3)
                          ? const Color(0xff9CE29B)
                          : checkLate2(checkedDateNoon[index].t3)
                              ? const Color(0xffF3FDB6)
                              : checkAbsengetT2(checkedDateNoon[index].t3)
                                  ? const Color(0xffFFCBCE)
                                  : const Color(0xff77B1C9),
                      borderRadius: BorderRadius.circular(10))
                  : BoxDecoration(
                      color: checkPresent(checkedDate[index].t1)
                          ? const Color(0xff9CE39B)
                          : checkLate1(checkedDate[index].t1)
                              ? const Color(0xffF3FDB6)
                              : checkAbsengetT1(checkedDate[index].t1)
                                  ? const Color(0xffFFCBCE)
                                  : const Color(0xff77B1C9),
                      borderRadius: BorderRadius.circular(10)),
              child: afternoon
                  ? Text(
                      checkAttendanceNoon(checkedDateNoon[index]),
                      style: TextStyle(
                        color: checkPresengetT2(checkedDateNoon[index].t3)
                            ? const Color(0xff334732)
                            : checkLate2(checkedDateNoon[index].t3)
                                ? const Color(0xff5A5E45)
                                : checkAbsengetT2(checkedDateNoon[index].t3)
                                    ? const Color(0xffA03E3E)
                                    : checkPermissiongetT2(
                                            checkedDateNoon[index].t3)
                                        ? const Color(0xff313B3F)
                                        : const Color(0xff313B3F),
                      ),
                    )
                  : Text(
                      checkAttendance(checkedDate[index]),
                      style: TextStyle(
                        color: checkPresent(checkedDate[index].t1)
                            ? const Color(0xff334732)
                            : checkLate1(checkedDate[index].t1)
                                ? const Color(0xff5A5E45)
                                : checkAbsengetT1(checkedDate[index].t1)
                                    ? const Color(0xffA03E3E)
                                    : const Color(0xff313B3F),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

// onSelected popupmenu
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
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AttendanceByWeekScreen(),
          ),
        );
        break;
    }
  }
}
