import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/screens/attendances_api/tap_screen_alltime.dart';
import 'package:ems/screens/attendances_api/tap_screen_month.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';

class AttendanceByDayScreen extends StatefulWidget {
  @override
  _AttendanceByDayScreenState createState() => _AttendanceByDayScreenState();
}

class _AttendanceByDayScreenState extends State<AttendanceByDayScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  UserService _userService = UserService.instance;

  List userDisplay = [];
  List<Attendance> attendanceDisplay = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  DateTime testdate = DateTime(10, 11, 2021);
  bool noData = true;
  List<Attendance> checkedDate = [];
  List<Attendance> checkedDateNoon = [];
  List<Attendance> users = [];
  String dropDownValue = '';
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
      attendanceDisplay = att2;
      attendanceDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAttendances();
    _userService.findMany().then((value) {
      userDisplay.addAll(value);
    });
  }

  void checkDate(DateTime pick) {
    var checkingDate = attendanceDisplay.where((element) =>
        element.date!.day == pick.day &&
        element.date!.month == pick.month &&
        element.date!.year == pick.year &&
        element.code == 'cin1' &&
        element.type != 'checkout');
    setState(() {
      users = checkingDate.toList();
      checkedDate = users;
      checkedDate.sort((a, b) => a.userId!.compareTo(b.userId as int));
    });
  }

  void checkDateNoon(DateTime pick) {
    var checkingDate = attendanceDisplay.where((element) =>
        element.date!.day == pick.day &&
        element.date!.month == pick.month &&
        element.date!.year == pick.year &&
        element.code == 'cin2' &&
        element.type != 'checkout');
    setState(() {
      users = checkingDate.toList();
      checkedDateNoon = users;
      print(checkedDateNoon[0].type);
      checkedDateNoon.sort((a, b) => a.userId!.compareTo(b.userId as int));
    });
  }

  String checkAttendance(Attendance attendance) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    if (attendance.type == 'checkin' &&
        attendance.date!.hour == 7 &&
        attendance.date!.minute <= 15 &&
        attendance.code == 'cin1') {
      return '${local?.present}';
    }
    if (attendance.type == 'checkin' &&
        attendance.date!.hour >= 7 &&
        attendance.date!.minute >= 16 &&
        attendance.code == 'cin1') {
      return '${local?.late}';
    }
    if (attendance.type == 'permission' && attendance.code == 'cin1') {
      return '${local?.permission}';
    }
    if (attendance.type == 'absent' && attendance.code == 'cin1') {
      return '${local?.absent}';
    } else {
      return '';
    }
  }

  String checkAttendanceNoon(Attendance attendance) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    if (attendance.type == 'checkin' &&
        attendance.date!.hour == 13 &&
        attendance.date!.minute <= 15 &&
        attendance.code == 'cin2') {
      return '${local?.present}';
    }
    if (attendance.type == 'checkin' &&
        attendance.date!.hour >= 13 &&
        attendance.date!.minute >= 16 &&
        attendance.code == 'cin2') {
      return '${local?.late}';
    }
    if (attendance.type == 'permission' && attendance.code == 'cin2') {
      return '${local?.permission}';
    }
    if (attendance.type == 'absent' && attendance.code == 'cin2') {
      return '${local?.absent}';
    } else {
      return '';
    }
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
    bool isEnglish = isInEnglish(context);

    setState(() {
      if (dropDownValue.isEmpty) {
        dropDownValue = local!.morning;
      }
    });
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
                          '${local?.byMonth}',
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
        body: attendanceDisplay.isEmpty
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
            : Column(
                children: [
                  Padding(
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
                        RaisedButton(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 7, right: 7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
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
                            style: TextStyle(fontSize: 12),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
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
                  ),
                  Expanded(
                    child: noData
                        ? Container(
                            padding: EdgeInsets.only(top: 140),
                            child: Column(
                              children: [
                                Text(
                                  '${local?.plsPickDate}',
                                  style: kHeadingTwo.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Image.asset(
                                  'assets/images/calendar.jpeg',
                                  width: 220,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 15),
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
                            child:
                                checkedDate.isEmpty && checkedDateNoon.isEmpty
                                    ? Column(
                                        children: [
                                          _searchBar(),
                                          Container(
                                            padding: EdgeInsets.only(top: 150),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${local?.noAttendance}',
                                                  style: kHeadingThree.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
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
                          ),
                  ),
                ],
              ));
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
                            checkedDate = users.where((user) {
                              var userName = user.users!.name!.toLowerCase();
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
                  checkedDate = users.where((user) {
                    var userName = user.users!.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  checkedDate.sort((a, b) => a.users!.name!
                      .toLowerCase()
                      .compareTo(b.users!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  checkedDate.sort((b, a) => a.users!.name!
                      .toLowerCase()
                      .compareTo(b.users!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  checkedDate
                      .sort((a, b) => a.userId!.compareTo(b.userId as int));
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
            icon: Icon(Icons.sort),
          ),
        ],
      ),
    );
  }

  _listItem(index) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
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
                  child: afternoon
                      ? checkedDateNoon[index].users!.image == null
                          ? Image.asset(
                              'assets/images/profile-icon-png-910.png')
                          : Image.network(
                              checkedDateNoon[index].users!.image.toString(),
                              fit: BoxFit.cover,
                              height: 75,
                            )
                      : checkedDate[index].users!.image == null
                          ? Image.asset(
                              'assets/images/profile-icon-png-910.png')
                          : Image.network(
                              checkedDate[index].users!.image.toString(),
                              fit: BoxFit.cover,
                              height: 75,
                            ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                        child: Text(
                          '${local?.name}: ',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 15,
                          ),
                        ),
                      ),
                      Text(
                        afternoon
                            ? checkedDateNoon[index].users!.name.toString()
                            : checkedDate[index].users!.name.toString(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                        child: Text(
                          '${local?.id}: ',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 15,
                          ),
                        ),
                      ),
                      Text(
                        afternoon
                            ? checkedDateNoon[index].users!.id.toString()
                            : checkedDate[index].userId.toString(),
                      ),
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
              decoration: afternoon
                  ? BoxDecoration(
                      color: checkedDateNoon[index].type == 'checkin' &&
                              checkedDateNoon[index].date!.hour == 13 &&
                              checkedDateNoon[index].date!.minute <= 15 &&
                              checkedDateNoon[index].code == 'cin2'
                          ? Color(0xff9CE29B)
                          : checkedDateNoon[index].type == 'checkin' &&
                                  checkedDateNoon[index].date!.hour >= 13 &&
                                  checkedDateNoon[index].date!.minute >= 16 &&
                                  checkedDateNoon[index].code == 'cin2'
                              ? Color(0xffF3FDB6)
                              : checkedDateNoon[index].type == 'absent' &&
                                      checkedDateNoon[index].code == 'cin2'
                                  ? Color(0xffFFCBCE)
                                  : Color(0xff77B1C9),
                      borderRadius: BorderRadius.circular(10))
                  : BoxDecoration(
                      color: checkedDate[index].type == 'checkin' &&
                              checkedDate[index].date!.hour == 7 &&
                              checkedDate[index].date!.minute <= 15 &&
                              checkedDate[index].code == 'cin1'
                          ? Color(0xff9CE29B)
                          : checkedDate[index].type == 'checkin' &&
                                  checkedDate[index].date!.hour >= 7 &&
                                  checkedDate[index].date!.minute >= 16 &&
                                  checkedDate[index].code == 'cin1'
                              ? Color(0xffF3FDB6)
                              : checkedDate[index].type == 'absent' &&
                                      checkedDate[index].code == 'cin1'
                                  ? Color(0xffFFCBCE)
                                  : Color(0xff77B1C9),
                      borderRadius: BorderRadius.circular(10)),
              child: afternoon
                  ? Text(
                      checkAttendanceNoon(checkedDateNoon[index]),
                      style: TextStyle(
                        color: checkedDateNoon[index].type == 'checkin' &&
                                checkedDateNoon[index].date!.hour == 13 &&
                                checkedDateNoon[index].date!.minute <= 15 &&
                                checkedDateNoon[index].code == 'cin2'
                            ? Color(0xff334732)
                            : checkedDateNoon[index].type == 'checkin' &&
                                    checkedDateNoon[index].code == 'cin2' &&
                                    checkedDateNoon[index].date!.hour >= 13 &&
                                    checkedDateNoon[index].date!.minute >= 16
                                ? Color(0xff5A5E45)
                                : checkedDateNoon[index].type == 'absent' &&
                                        checkedDateNoon[index].code == 'cin2'
                                    ? Color(0xffA03E3E)
                                    : checkedDateNoon[index].type ==
                                                'permission' &&
                                            checkedDateNoon[index].code ==
                                                'cin2'
                                        ? Color(0xff313B3F)
                                        : Color(0xff313B3F),
                      ),
                    )
                  : Text(
                      checkAttendance(checkedDate[index]),
                      style: TextStyle(
                        color: checkedDate[index].type == 'checkin' &&
                                checkedDate[index].date!.hour == 7 &&
                                checkedDate[index].date!.minute <= 15 &&
                                checkedDate[index].code == 'cin1'
                            ? Color(0xff334732)
                            : checkedDate[index].type == 'checkin' &&
                                    checkedDate[index].date!.hour >= 7 &&
                                    checkedDate[index].date!.minute >= 16 &&
                                    checkedDate[index].code == 'cin1'
                                ? Color(0xff5A5E45)
                                : checkedDate[index].type == 'absent' &&
                                        checkedDate[index].code == 'cin1'
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
