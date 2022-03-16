import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/attendance.dart';
import '../../services/models/attendance.dart';

class AttendancesByMonthScreen extends StatefulWidget {
  @override
  _AttendancesByMonthScreenState createState() =>
      _AttendancesByMonthScreenState();
}

class _AttendancesByMonthScreenState extends State<AttendancesByMonthScreen> {
  // services
  final AttendanceService _attendanceService = AttendanceService.instance;
  final UserService _userService = UserService.instance;

  // list attendance with user
  List userDisplay = [];
  List<AttendancesByDate> attendanceDisplay = [];
  List<Attendance> attsList = [];
  List<User> users = [];

  // list dynamic
  List monthList = [];

  // variable
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  DateTime? _selectDate;
  var _selectMonth;
  var pickedYear;
  String dropDownValue = '';
  String dropDownValue1 = '';

  // fetch attendance from api
  fetchAttendances() async {
    List<AttendancesByDate> atts = [];
    atts = await _attendanceService.findMany();

    setState(() {
      attendanceDisplay = atts.toList();
      // attendanceDisplay.sort(
      //     (a, b) => a.attendances![0].id!.compareTo(b.attendances![0].id!));
    });
  }

  // text controller
  TextEditingController yearController = TextEditingController();
  TextEditingController _controller = TextEditingController();

  // boolean
  bool afternoon = false;
  bool total = false;

  @override
  void initState() {
    super.initState();
    fetchAttendances();
    _userService.findMany().then((value) {
      users.addAll(value);
      userDisplay = users;
      userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

  countAttendance() {
    List<Attendance> att = [];
    attendanceDisplay
        .map((e) => e.attendances?.map((e) => att.add(e)).toList())
        .toList();
    attsList = att;
  }

  void clearText() {
    _controller.clear();
  }

  // date picker popup
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    setState(() {
      if (dropDownValue.isEmpty) {
        dropDownValue = local!.morning;
      }
      if (dropDownValue1.isEmpty) {
        dropDownValue1 = '2022';
      }
      if (monthList.isEmpty) {
        monthList = [
          '${local?.jan}',
          '${local?.feb}',
          '${local?.mar}',
          '${local?.apr}',
          '${local?.may}',
          '${local?.jun}',
          '${local?.jul}',
          '${local?.aug}',
          '${local?.sep}',
          '${local?.oct}',
          '${local?.nov}',
          '${local?.dec}',
        ];
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('${local?.byMonth}'),
        actions: [
          PopupMenuButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: kBlack,
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
                  ])
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _selectMonth == null
                          ? '${local?.monthYear}: ____'
                          : '${local?.monthYear}: $_selectMonth/$pickedYear',
                      style: kParagraph.copyWith(fontSize: 14),
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: kDarkestBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, _setState) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  title: Text('${local?.pickMonth}'),
                                  content: SizedBox(
                                    height: 300,
                                    width: 400,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kDarkestBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: DropdownButton(
                                                underline: Container(),
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                isDense: true,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        kBorderRadius),
                                                dropdownColor: kDarkestBlue,
                                                icon: const Icon(
                                                    Icons.expand_more),
                                                value: dropDownValue1,
                                                onChanged: (String? newValue) {
                                                  _setState(() {
                                                    dropDownValue1 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  '2021',
                                                  '2022',
                                                  '2023',
                                                  '2024',
                                                  '2025',
                                                  '2026',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 250,
                                              child: GridView.count(
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 20,
                                                childAspectRatio: 2.2,
                                                crossAxisCount: 3,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: [
                                                  ...monthList
                                                      .asMap()
                                                      .entries
                                                      .map((e) {
                                                    int index = e.key;
                                                    String name = e.value;
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _selectMonth =
                                                              index + 1;
                                                          pickedYear =
                                                              dropDownValue1;
                                                          Navigator.of(context)
                                                              .pop();
                                                          countAttendance();
                                                        });
                                                      },
                                                      child: Text(name),
                                                      style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .teal,
                                                                      width:
                                                                          2.0)))),
                                                    );
                                                  })
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        '${local?.pickMonth}',
                        style: kParagraph,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
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
              ),
              pickedYear == null
                  ? Container(
                      padding: const EdgeInsets.only(top: 150, left: 70),
                      child: Column(
                        children: [
                          Text(
                            '${local?.plsPickMonth}',
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
                    )
                  : Expanded(
                      flex: 3,
                      child: Container(
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
                        child: userDisplay.isEmpty
                            ? Column(
                                children: [
                                  _searchBar(),
                                  Container(
                                    padding: const EdgeInsets.only(top: 150),
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
                                      shrinkWrap: true,
                                      itemCount: userDisplay.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          margin: const EdgeInsets.all(20),
                                          decoration: const BoxDecoration(
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
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    100)),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.white,
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              150),
                                                      child: userDisplay[index]
                                                                  .image ==
                                                              null
                                                          ? Image.asset(
                                                              'assets/images/profile-icon-png-910.png',
                                                              width: 60,
                                                            )
                                                          : Image.network(
                                                              userDisplay[index]
                                                                  .image
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                              width: 65,
                                                              height: 75,
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      BaselineRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                              '${local?.name}: ',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            userDisplay[index]
                                                                        .name
                                                                        .length >=
                                                                    13
                                                                ? '${userDisplay[index].name.substring(0, 8).toString()}...'
                                                                : userDisplay[
                                                                        index]
                                                                    .name
                                                                    // .substring(
                                                                    //     userDisplay[index].name.length - 7)
                                                                    .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      BaselineRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                              '${local?.id}: ',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                              userDisplay[index]
                                                                  .id
                                                                  .toString()),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                                '${local?.shortPresent}: '),
                                                          ),
                                                          total
                                                              ? Text((attsList.where(
                                                                          (element) {
                                                                        return element.userId == userDisplay[index].id &&
                                                                            element.date!.month ==
                                                                                _selectMonth &&
                                                                            element.t1 !=
                                                                                null &&
                                                                            checkPresent(element
                                                                                .t1) &&
                                                                            element.date!.year ==
                                                                                int.parse(pickedYear);
                                                                      }).length +
                                                                      attsList.where(
                                                                          (element) {
                                                                        return element.userId == userDisplay[index].id &&
                                                                            element.date!.month ==
                                                                                _selectMonth &&
                                                                            element.t3 !=
                                                                                null &&
                                                                            checkPresengetT2(element
                                                                                .t3) &&
                                                                            element.date!.year ==
                                                                                int.parse(pickedYear);
                                                                      }).length)
                                                                  .toString())
                                                              : afternoon
                                                                  ? Text(attsList
                                                                      .where((element) {
                                                                        return element.userId == userDisplay[index].id &&
                                                                            element.date!.month ==
                                                                                _selectMonth &&
                                                                            element.t3 !=
                                                                                null &&
                                                                            checkPresengetT2(element
                                                                                .t3) &&
                                                                            element.date!.year ==
                                                                                int.parse(pickedYear);
                                                                      })
                                                                      .length
                                                                      .toString())
                                                                  : Text(
                                                                      attsList
                                                                          .where(
                                                                              (element) {
                                                                            return element.userId == userDisplay[index].id &&
                                                                                element.date!.month == _selectMonth &&
                                                                                element.t1 != null &&
                                                                                checkPresent(element.t1) &&
                                                                                element.date!.year == int.parse(pickedYear);
                                                                          })
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
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                                '${local?.shortAbsent}: '),
                                                          ),
                                                          total
                                                              ? Text((attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month ==
                                                                                  _selectMonth &&
                                                                              element.t1 !=
                                                                                  null &&
                                                                              checkAbsengetT1(element
                                                                                  .t1) &&
                                                                              element.date!.year ==
                                                                                  int.parse(
                                                                                      pickedYear)))
                                                                          .length +
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkAbsengetT2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length)
                                                                  .toString())
                                                              : afternoon
                                                                  ? Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkAbsengetT2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length
                                                                          .toString(),
                                                                    )
                                                                  : Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t1 != null &&
                                                                              checkAbsengetT1(element.t1) &&
                                                                              element.date!.year == int.parse(pickedYear)))
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      BaselineRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                                '${local?.shortLate}: '),
                                                          ),
                                                          total
                                                              ? Text((attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month ==
                                                                                  _selectMonth &&
                                                                              element.t1 !=
                                                                                  null &&
                                                                              checkLate1(element
                                                                                  .t1) &&
                                                                              element.date!.year ==
                                                                                  int.parse(
                                                                                      pickedYear)))
                                                                          .length +
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkLate2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length)
                                                                  .toString())
                                                              : afternoon
                                                                  ? Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkLate2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length
                                                                          .toString(),
                                                                    )
                                                                  : Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t1 != null &&
                                                                              checkLate1(element.t1) &&
                                                                              element.date!.year == int.parse(pickedYear)))
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
                                                                EdgeInsets.only(
                                                                    top: isEnglish
                                                                        ? 0
                                                                        : 3),
                                                            child: Text(
                                                                '${local?.shortPermission}: '),
                                                          ),
                                                          total
                                                              ? Text((attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month ==
                                                                                  _selectMonth &&
                                                                              element.t1 !=
                                                                                  null &&
                                                                              checkPermissiongetT1(element
                                                                                  .t1) &&
                                                                              element.date!.year ==
                                                                                  int.parse(
                                                                                      pickedYear)))
                                                                          .length +
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkPermissiongetT2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length)
                                                                  .toString())
                                                              : afternoon
                                                                  ? Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t3 != null &&
                                                                              checkPermissiongetT2(element.t3) &&
                                                                              element.date!.year == int.parse(pickedYear)))
                                                                          .length
                                                                          .toString(),
                                                                    )
                                                                  : Text(
                                                                      attsList
                                                                          .where((element) => (element.userId == userDisplay[index].id &&
                                                                              element.date!.month == _selectMonth &&
                                                                              element.t1 != null &&
                                                                              checkPermissiongetT1(element.t1) &&
                                                                              element.date!.year == int.parse(pickedYear)))
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
      ),
    );
  }

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
                text = _controller.text.toLowerCase();
                setState(() {
                  userDisplay = users.where((user) {
                    var userName = user.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
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
                  userDisplay.sort((a, b) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  userDisplay.sort((b, a) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
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
