import 'package:ems/models/attendance.dart';
import 'package:ems/models/attendances.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/services/attendance_service.dart';

class AttendancesByMonthScreen extends StatefulWidget {
  @override
  _AttendancesByMonthScreenState createState() =>
      _AttendancesByMonthScreenState();
}

class _AttendancesByMonthScreenState extends State<AttendancesByMonthScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  UserService _userService = UserService.instance;

  List userDisplay = [];
  List<AttendancesWithUser> attendanceDisplay = [];
  List<User> users = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  fetchAttendances() async {
    List<AttendancesWithDateWithUser> atts = [];
    atts = await _attendanceService.findMany();
    List<AttendancesWithUser> att2 =
        attendancesWithUsesrFromAttendancesbyDay(atts);
    setState(() {
      attendanceDisplay = att2;
      attendanceDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

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

  DateTime? _selectDate;
  var _selectMonth;

  TextEditingController yearController = TextEditingController();
  var _controller = TextEditingController();
  var pickedYear;
  String dropDownValue = '';
  String dropDownValue1 = '';
  bool afternoon = false;
  bool total = false;
  List monthList = [];

  void clearText() {
    _controller.clear();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   yearController.dispose();
  //   super.dispose();
  // }

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

  String? get _errorText {
    final text = yearController.value.text;
    if (text.isEmpty || text == null) {
      return 'Please Enter Year';
    }
    if (double.tryParse(text) == null) {
      return 'Please Enter valid number';
    }
    if (text.length < 4 || text.length > 4) {
      return 'Enter 4 Digits';
    }
    return null;
  }

  bool _validate = false;

  final _formKey = GlobalKey<FormState>();

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

  void monthPick() {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
  }

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
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text(
                        '${local?.byAllTime}',
                        style: TextStyle(
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
                                  content: Container(
                                    height: 300,
                                    width: 400,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            // TextField(
                                            //   keyboardType: TextInputType.number,
                                            //   decoration: InputDecoration(
                                            //       errorText: _validate
                                            //           ? '${local?.enter4Digits}'
                                            //           : '${local?.enter4Digits}',
                                            //       hintText: '${local?.enterYear}'),
                                            //   controller: yearController,
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 250,
                                              child: GridView.count(
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 20,
                                                childAspectRatio: 2.2,
                                                crossAxisCount: 3,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
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
                                                              style: TextStyle(
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
                                                              style: TextStyle(
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
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      //   BaselineRow(
                                                      //     children: [
                                                      //       Padding(
                                                      //         padding:
                                                      //             EdgeInsets.only(
                                                      //                 top: isEnglish
                                                      //                     ? 0
                                                      //                     : 3),
                                                      //         child: Text(
                                                      //             '${local?.shortPresent}: '),
                                                      //       ),
                                                      //       total
                                                      //           ? Text((attendanceDisplay
                                                      //                       .where(
                                                      //                           (element) {
                                                      //                     return element.userId == userDisplay[index].id &&
                                                      //                         element.date.month ==
                                                      //                             _selectMonth &&
                                                      //                         checkPresent(
                                                      //                             element) &&
                                                      //                         element.date.year ==
                                                      //                             int.parse(pickedYear);
                                                      //                   }).length +
                                                      //                   attendanceDisplay
                                                      //                       .where(
                                                      //                           (element) {
                                                      //                     return element.userId == userDisplay[index].id &&
                                                      //                         element.date.month ==
                                                      //                             _selectMonth &&
                                                      //                         checkPresentNoon(
                                                      //                             element) &&
                                                      //                         element.date.year ==
                                                      //                             int.parse(pickedYear);
                                                      //                   }).length)
                                                      //               .toString())
                                                      //           : afternoon
                                                      //               ? Text(attendanceDisplay
                                                      //                   .where((element) {
                                                      //                     return element.userId == userDisplay[index].id &&
                                                      //                         element.date.month ==
                                                      //                             _selectMonth &&
                                                      //                         checkPresentNoon(
                                                      //                             element) &&
                                                      //                         element.date.year ==
                                                      //                             int.parse(pickedYear);
                                                      //                   })
                                                      //                   .length
                                                      //                   .toString())
                                                      //               : Text(
                                                      //                   attendanceDisplay
                                                      //                       .where(
                                                      //                           (element) {
                                                      //                         return element.userId == userDisplay[index].id &&
                                                      //                             element.date.month == _selectMonth &&
                                                      //                             checkPresent(element) &&
                                                      //                             element.date.year == int.parse(pickedYear);
                                                      //                       })
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 ),
                                                      //     ],
                                                      //   ),
                                                      //   const SizedBox(
                                                      //     height: 10,
                                                      //   ),
                                                      //   BaselineRow(
                                                      //     children: [
                                                      //       Padding(
                                                      //         padding:
                                                      //             EdgeInsets.only(
                                                      //                 top: isEnglish
                                                      //                     ? 0
                                                      //                     : 3),
                                                      //         child: Text(
                                                      //             '${local?.shortAbsent}: '),
                                                      //       ),
                                                      //       total
                                                      //           ? Text((attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month ==
                                                      //                               _selectMonth &&
                                                      //                           checkAbsent(
                                                      //                               element) &&
                                                      //                           element.date.year ==
                                                      //                               int.parse(
                                                      //                                   pickedYear)))
                                                      //                       .length +
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkAbsentNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length)
                                                      //               .toString())
                                                      //           : afternoon
                                                      //               ? Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkAbsentNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 )
                                                      //               : Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkAbsent(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 ),
                                                      //     ],
                                                      //   ),
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
                                                      //   BaselineRow(
                                                      //     children: [
                                                      //       Padding(
                                                      //         padding:
                                                      //             EdgeInsets.only(
                                                      //                 top: isEnglish
                                                      //                     ? 0
                                                      //                     : 3),
                                                      //         child: Text(
                                                      //             '${local?.shortLate}: '),
                                                      //       ),
                                                      //       total
                                                      //           ? Text((attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month ==
                                                      //                               _selectMonth &&
                                                      //                           checkLate(
                                                      //                               element) &&
                                                      //                           element.date.year ==
                                                      //                               int.parse(
                                                      //                                   pickedYear)))
                                                      //                       .length +
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkLateNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length)
                                                      //               .toString())
                                                      //           : afternoon
                                                      //               ? Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkLateNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 )
                                                      //               : Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkLate(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 ),
                                                      //     ],
                                                      //   ),
                                                      //   const SizedBox(
                                                      //     height: 10,
                                                      //   ),
                                                      //   BaselineRow(
                                                      //     children: [
                                                      //       Padding(
                                                      //         padding:
                                                      //             EdgeInsets.only(
                                                      //                 top: isEnglish
                                                      //                     ? 0
                                                      //                     : 3),
                                                      //         child: Text(
                                                      //             '${local?.shortPermission}: '),
                                                      //       ),
                                                      //       total
                                                      //           ? Text((attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month ==
                                                      //                               _selectMonth &&
                                                      //                           checkPermission(
                                                      //                               element) &&
                                                      //                           element.date.year ==
                                                      //                               int.parse(
                                                      //                                   pickedYear)))
                                                      //                       .length +
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkPermissionNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length)
                                                      //               .toString())
                                                      //           : afternoon
                                                      //               ? Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkPermissionNoon(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 )
                                                      //               : Text(
                                                      //                   attendanceDisplay
                                                      //                       .where((element) => (element.userId == userDisplay[index].id &&
                                                      //                           element.date.month == _selectMonth &&
                                                      //                           checkPermission(element) &&
                                                      //                           element.date.year == int.parse(pickedYear)))
                                                      //                       .length
                                                      //                       .toString(),
                                                      //                 ),
                                                      //     ],
                                                      //   ),
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
