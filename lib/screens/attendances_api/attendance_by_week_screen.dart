import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/screens/attendances_api/widgets/event.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/services/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constants.dart';

class AttendanceByWeekScreen extends StatefulWidget {
  /// Custom events.
  final List<Event> events;
  AttendanceByWeekScreen({Key? key, this.events = const []}) : super(key: key);

  @override
  State<AttendanceByWeekScreen> createState() => _AttendanceByWeekScreenState();
}

class _AttendanceByWeekScreenState extends State<AttendanceByWeekScreen> {
  // service
  final AttendanceService _attendanceService = AttendanceService();
  final UserService _userService = UserService();

  //  list
  List<AttendancesByDate> attendanceList = [];
  List<Attendance> attsList = [];
  List<User> userList = [];
  List<User> users = [];

// variable
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  TextEditingController _controller = TextEditingController();

  // boolean
  bool afternoon = false;
  bool total = false;
  String dropDownValue = '';

// datetime
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  // boolean
  bool _isLoading = true;
  bool _isLoadingUser = true;

  void clearText() {
    _controller.clear();
  }

  // fetch user from api
  fetchUser() async {
    try {
      _isLoadingUser = true;
      List<User> userDisplay = await _userService.findMany();
      setState(() {
        users = userDisplay.toList();
        userList = users;
        _isLoadingUser = false;
      });
    } catch (err) {
      print(err);
    }
  }

  // fetch attendance from api
  fetchAttendances(dateStart, dateEnd) async {
    try {
      _isLoading = true;
      List<AttendancesByDate> attendanceDisplay =
          await _attendanceService.findMany(start: dateStart, end: dateEnd);
      setState(() {
        attendanceList = attendanceDisplay.toList();
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  countAttendance() {
    List<Attendance> att = [];
    attendanceList
        .map((e) => e.attendances?.map((e) => att.add(e)).toList())
        .toList();
    attsList = att;
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
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

  DateTime _selectedDate = DateTime.now();
  DateTime _firstDate = DateTime(1990);
  DateTime _lastDate = DateTime.now().add(Duration(days: 45));
  DatePeriod? _selectedPeriod;

  Color selectedPeriodStartColor = Colors.red;
  Color selectedPeriodLastColor = Colors.yellow;
  Color selectedPeriodMiddleColor = Colors.orange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // defaults for styles
    selectedPeriodLastColor = Colors.red;
    selectedPeriodMiddleColor = Colors.orange;
    selectedPeriodStartColor = Colors.red;
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
    // add selected colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: selectedPeriodLastColor,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10.0), bottomEnd: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: selectedPeriodStartColor,
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration: BoxDecoration(
          color: selectedPeriodMiddleColor, shape: BoxShape.rectangle),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          _iconNav(context, local),
        ],
      ),
      body: attendanceList.isEmpty
          ? Column(
              children: [_pickDateBtn(context, styles), _plsPickDate()],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _pickDateAndFilter(context, styles, local),
                ),
                Expanded(
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
                      child: _isLoading || _isLoadingUser
                          ? _fetching(local)
                          : _employeeListAndAttCount(local, isEnglish)),
                ),
              ],
            ),
    );
  }

// employee list and attendance count
  Column _employeeListAndAttCount(AppLocalizations? local, bool isEnglish) {
    return Column(
      children: [
        Padding(
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
                                userList = users.where((user) {
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
                      userList = users.where((user) {
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
                      userList.sort((a, b) => a.name!
                          .toLowerCase()
                          .compareTo(b.name!.toLowerCase()));
                    });
                  }
                  if (selectedValue == 1) {
                    setState(() {
                      userList.sort((b, a) => a.name!
                          .toLowerCase()
                          .compareTo(b.name!.toLowerCase()));
                    });
                  }
                  if (selectedValue == 2) {
                    setState(() {
                      userList.sort((a, b) => a.id!.compareTo(b.id as int));
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
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 20),
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  100,
                                ),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: userList[index].image == null
                                ? Image.asset(
                                    'assets/images/profile-icon-png-910.png',
                                    width: 60,
                                  )
                                : Image.network(
                                    userList[index].image.toString(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaselineRow(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: isEnglish ? 0 : 3),
                                  child: Text(
                                    '${local?.name}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  userList[index].name!.length >= 13
                                      ? '${userList[index].name!.substring(0, 8).toString()}...'
                                      : userList[index]
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
                                      EdgeInsets.only(top: isEnglish ? 0 : 3),
                                  child: Text(
                                    '${local?.id}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(userList[index].id.toString()),
                              ],
                            ),
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
                                Text('${local?.shortPresent}: '),
                                total
                                    ? Text(
                                        (attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t1 != null &&
                                                        checkPresent(
                                                            element.t1)))
                                                    .length +
                                                attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t3 != null &&
                                                        checkPresengetT2(
                                                            element.t3)))
                                                    .length)
                                            .toString(),
                                      )
                                    : afternoon
                                        ? Text(attsList
                                            .where((element) => (element
                                                        .userId ==
                                                    userList[index].id &&
                                                element.t3 != null &&
                                                checkPresengetT2(element.t3)))
                                            .length
                                            .toString())
                                        : Text(attsList
                                            .where((element) =>
                                                (element.userId ==
                                                        userList[index].id &&
                                                    element.t1 != null &&
                                                    checkPresent(element.t1)))
                                            .length
                                            .toString()),
                              ],
                            ),
                            BaselineRow(
                              children: [
                                Text('${local?.shortAbsent}: '),
                                total
                                    ? Text(
                                        (attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t1 != null &&
                                                        checkAbsengetT1(
                                                            element.t1)))
                                                    .length +
                                                attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t3 != null &&
                                                        checkAbsengetT2(
                                                            element.t3)))
                                                    .length)
                                            .toString(),
                                      )
                                    : afternoon
                                        ? Text(attsList
                                            .where((element) => (element
                                                        .userId ==
                                                    userList[index].id &&
                                                element.t3 != null &&
                                                checkAbsengetT2(element.t3)))
                                            .length
                                            .toString())
                                        : Text(attsList
                                            .where((element) => (element
                                                        .userId ==
                                                    userList[index].id &&
                                                element.t1 != null &&
                                                checkAbsengetT1(element.t1)))
                                            .length
                                            .toString()),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            BaselineRow(
                              children: [
                                Text('${local?.shortLate}: '),
                                total
                                    ? Text(
                                        (attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t1 != null &&
                                                        checkLate1(element.t1)))
                                                    .length +
                                                attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t3 != null &&
                                                        checkLate2(element.t3)))
                                                    .length)
                                            .toString(),
                                      )
                                    : afternoon
                                        ? Text(attsList
                                            .where((element) =>
                                                (element.userId ==
                                                        userList[index].id &&
                                                    element.t3 != null &&
                                                    checkLate2(element.t3)))
                                            .length
                                            .toString())
                                        : Text(attsList
                                            .where((element) =>
                                                (element.userId ==
                                                        userList[index].id &&
                                                    element.t1 != null &&
                                                    checkLate1(element.t1)))
                                            .length
                                            .toString()),
                              ],
                            ),
                            BaselineRow(
                              children: [
                                Text('${local?.shortPermission}: '),
                                total
                                    ? Text(
                                        (attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t1 != null &&
                                                        checkPermissiongetT1(
                                                            element.t1)))
                                                    .length +
                                                attsList
                                                    .where((element) => (element
                                                                .userId ==
                                                            userList[index]
                                                                .id &&
                                                        element.t3 != null &&
                                                        checkPermissiongetT2(
                                                            element.t3)))
                                                    .length)
                                            .toString(),
                                      )
                                    : afternoon
                                        ? Text(attsList
                                            .where((element) =>
                                                (element.userId ==
                                                        userList[index].id &&
                                                    element.t3 != null &&
                                                    checkPermissiongetT2(
                                                        element.t3)))
                                            .length
                                            .toString())
                                        : Text(attsList
                                            .where((element) =>
                                                (element.userId ==
                                                        userList[index].id &&
                                                    element.t1 != null &&
                                                    checkPermissiongetT1(
                                                        element.t1)))
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
              );
            },
            itemCount: userList.length,
          ),
        ),
      ],
    );
  }

// fetching and loading widget
  Container _fetching(AppLocalizations? local) {
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

// pick date btn and filter morning/afternoon
  Row _pickDateAndFilter(BuildContext context, DatePickerRangeStyles styles,
      AppLocalizations? local) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: _selectedPeriod?.start == null && _selectedPeriod?.end == null
              ? Text(
                  'Date: ____',
                )
              : Row(
                  children: [
                    Text(
                      'Date: ',
                      style: kParagraph.copyWith(fontSize: 14),
                    ),
                    Column(
                      children: [
                        Text(DateFormat('dd/MM/yyyy')
                            .format(_selectedPeriod!.start)),
                        Text(DateFormat('dd/MM/yyyy')
                            .format(_selectedPeriod!.end))
                      ],
                    )
                  ],
                ),
        ),
        RaisedButton(
          color: kDarkestBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: WeekPicker(
                          selectedDate: _selectedDate,
                          onChanged: (date) {
                            _onSelectedDateChanged(date);
                            setState(() {});
                          },
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          datePickerStyles: styles,
                          onSelectionError: _onSelectionError,
                          eventDecorationBuilder: _eventDecorationBuilder,
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 20),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await fetchAttendances(
                                  _selectedPeriod?.start, _selectedPeriod?.end);
                              countAttendance();
                            },
                            child: Text('OK'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Text('Pick Date'),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
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
    );
  }

// please pick date message
  Container _plsPickDate() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 0),
      child: Column(
        children: [
          Text(
            'Please Pick date',
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

// pick date button
  Row _pickDateBtn(BuildContext context, DatePickerRangeStyles styles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            'Date: ____',
            style: kParagraph.copyWith(fontSize: 14),
          ),
        ),
        RaisedButton(
          color: kDarkestBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: WeekPicker(
                          selectedDate: _selectedDate,
                          onChanged: (date) {
                            _onSelectedDateChanged(date);
                            setState(() {});
                          },
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          datePickerStyles: styles,
                          onSelectionError: _onSelectionError,
                          eventDecorationBuilder: _eventDecorationBuilder,
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 20),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await fetchAttendances(
                                  _selectedPeriod?.start, _selectedPeriod?.end);
                              countAttendance();
                            },
                            child: Text('OK'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Text('Pick Date'),
        ),
      ],
    );
  }

// icon for navigate to other screens
  PopupMenuButton<int> _iconNav(BuildContext context, AppLocalizations? local) {
    return PopupMenuButton(
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
            '${local?.byMonth}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: 2,
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
      ],
    );
  }

// date picker onChange
  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedDate = newPeriod.start;
      _selectedPeriod = newPeriod;
    });
  }

// on error date picker
  void _onSelectionError(Object e) {
    if (e is UnselectablePeriodException) print("catch error: $e");
  }

// date picker decoration
  EventDecoration? _eventDecorationBuilder(DateTime date) {
    List<DateTime> eventsDates =
        widget.events.map<DateTime>((e) => e.date).toList();

    bool isEventDate = eventsDates.any((d) =>
        date.year == d.year && date.month == d.month && d.day == date.day);

    if (!isEventDate) return null;

    BoxDecoration roundedBorder = BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));

    TextStyle? whiteText =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white);

    return isEventDate
        ? EventDecoration(boxDecoration: roundedBorder, textStyle: whiteText)
        : null;
  }
}

// on select icon nav option
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
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AttendancesByMonthScreen(),
        ),
      );
      break;
  }
}
