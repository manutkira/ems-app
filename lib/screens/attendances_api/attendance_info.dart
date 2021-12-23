import 'package:ems/models/attendance_no_s.dart';
import 'package:ems/screens/attendances_api/attendance_edit.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';

class AttendancesInfoScreen extends StatefulWidget {
  static const routeName = '/attendances-info';
  final int id;

  AttendancesInfoScreen(this.id);
  @override
  _AttendancesInfoScreenState createState() => _AttendancesInfoScreenState();
}

class _AttendancesInfoScreenState extends State<AttendancesInfoScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  List<Attendance> attendanceDisplay = [];

  AttendanceService _attendanceAllService = AttendanceService.instance;
  List<Attendance> attendanceAllDisplay = [];

  AttendanceByIdService _overtimeService = AttendanceByIdService.instance;
  List<AttendanceById> _attendanceDisplay = [];

  String dropDownValue = 'Morning';
  bool afternoon = false;
  dynamic countPresent = '';
  dynamic countPresentNoon = '';
  dynamic countLate = '';
  dynamic countLateNoon = '';
  dynamic countAbsent = '';
  dynamic countAbsentNoon = '';
  dynamic countPermission = '';
  dynamic countPermissionNoon = '';
  dynamic lateMorning = '';
  dynamic lateAfternoon = '';
  dynamic absentMorning = '';
  dynamic absentAfternoon = '';
  dynamic permissionMorning = '';
  dynamic permissionAfternoon = '';
  dynamic presentMorning = '';
  dynamic presentAfternoon = '';
  bool multipleDay = false;
  bool _isLoading = true;
  bool order = false;
  bool isFilterExpanded = true;
  List<Appointment>? _appointment;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  List<Attendance>? isToday;
  bool now = true;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  String sortByValue = 'All Time';
  var dropdownItems = [
    'Multiple Days',
    'All Time',
  ];

  fetchAttendance() async {
    try {
      List<AttendanceById> attendanceDisplay =
          await _overtimeService.findByUserId(userId: widget.id);
      setState(() {
        _attendanceDisplay = attendanceDisplay;
      });
    } catch (e) {
      print('hehe $e');
    }
  }

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/attendances";

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      _attendanceAllService.findManyByUserId(userId: widget.id).then((value) {
        setState(() {
          attendanceAllDisplay = [];
          attendanceAllDisplay.addAll(value);
          _isLoading = false;
          var now = DateTime.now();
          var today = attendanceAllDisplay
              .where((element) =>
                  element.date?.day == now.day &&
                  element.date?.month == now.month &&
                  element.date?.year == now.year)
              .toList();
          isToday = today.toList();
          isToday?.sort((a, b) => a.id!.compareTo(b.id!));
        });
      });
    } else {
      return false;
    }
  }

  Future deleteData1(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      checkedDate = [];
      users = [];
      _attendanceAllService.findManyByUserId(userId: widget.id).then((value) {
        setState(() {
          attendanceAllDisplay.addAll(value);
          _isLoading = false;
          var checkingDate = attendanceAllDisplay.where((element) =>
              element.date?.day == _selectDate?.day &&
              element.date?.month == _selectDate?.month &&
              element.date?.year == _selectDate?.year);
          setState(() {
            users = checkingDate.toList();
            checkedDate = users;
            checkedDate.sort((a, b) => a.id!.compareTo(b.id!));
          });
        });
      });
    } else {
      return false;
    }
  }

  fetchLate() async {
    var pc = await _attendanceService.countLateByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        lateMorning = pc;
      });
    }
  }

  fetchLateNoon() async {
    var pc = await _attendanceService.countLateNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        lateAfternoon = pc;
      });
    }
  }

  fetchAbsent() async {
    var pc = await _attendanceService.countAbsentByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        absentMorning = pc;
      });
    }
  }

  fetchAbsentNoon() async {
    var pc = await _attendanceService.countAbsentNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        absentAfternoon = pc;
      });
    }
  }

  fetchPermission() async {
    var pc = await _attendanceService.countPermissionByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        permissionMorning = pc;
      });
    }
  }

  fetchPermissionNoon() async {
    var pc = await _attendanceService.countPermissionNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        permissionAfternoon = pc;
      });
    }
  }

  fetchPresent() async {
    var pc = await _attendanceService.countPresentByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        presentMorning = pc;
        print('present $presentMorning');
      });
    }
  }

  fetchPresentNoon() async {
    var pc = await _attendanceService.countPresentNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        presentAfternoon = pc;
      });
    }
  }

  getPresent() async {
    var pc = await _attendanceService.countPresent(widget.id);
    if (mounted) {
      setState(() {
        countPresent = pc;
      });
    }
  }

  getPresentNoon() async {
    var pc = await _attendanceService.countPresentNoon(widget.id);
    if (mounted) {
      setState(() {
        countPresentNoon = pc;
      });
    }
  }

  getLate() async {
    var pc = await _attendanceService.countLate(widget.id);
    if (mounted) {
      setState(() {
        countLate = pc;
      });
    }
  }

  getLateNoon() async {
    var pc = await _attendanceService.countLateNoon(widget.id);
    if (mounted) {
      setState(() {
        countLateNoon = pc;
      });
    }
  }

  getAbsent() async {
    var pc = await _attendanceService.countAbsent(widget.id);
    if (mounted) {
      setState(() {
        countAbsent = pc;
      });
    }
  }

  getAbsentNoon() async {
    var pc = await _attendanceService.countAbsentNoon(widget.id);
    if (mounted) {
      setState(() {
        countAbsentNoon = pc;
      });
    }
  }

  getPermission() async {
    var pc = await _attendanceService.countPermission(widget.id);
    if (mounted) {
      setState(() {
        countPermission = pc;
      });
    }
  }

  getPermissionNoon() async {
    var pc = await _attendanceService.countPermissionNoon(widget.id);
    if (mounted) {
      setState(() {
        countPermissionNoon = pc;
      });
    }
  }

  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  @override
  void initState() {
    super.initState();

    try {
      getPresent();
      getPresentNoon();
      getLate();
      getLateNoon();
      getAbsent();
      getAbsentNoon();
      getPermission();
      getPermissionNoon();
      fetchAttendance();
      fetchLate();
      fetchLateNoon();
      fetchAbsent();
      fetchAbsentNoon();
      fetchPermission();
      fetchPermissionNoon();
      fetchPresent();
      fetchPresentNoon();
      _attendanceAllService.findManyByUserId(userId: widget.id).then((value) {
        setState(() {
          attendanceAllDisplay.addAll(value);
          _isLoading = false;
          var now = DateTime.now();
          var today = attendanceAllDisplay
              .where((element) =>
                  element.date?.day == now.day &&
                  element.date?.month == now.month &&
                  element.date?.year == now.year)
              .toList();
          isToday = today.toList();
          isToday?.sort((a, b) => a.id!.compareTo(b.id!));
        });
      });
    } catch (err) {}
  }

  List<Attendance> checkedDate = [];
  List<Attendance> users = [];

  void checkDate(DateTime pick) {
    var checkingDate = attendanceAllDisplay.where((element) =>
        element.date?.day == pick.day &&
        element.date?.month == pick.month &&
        element.date?.year == pick.year);
    setState(() {
      users = checkingDate.toList();
      checkedDate = users;
      checkedDate.sort((a, b) => a.id!.compareTo(b.id!));
    });
  }

  void checkToday(DateTime pick) {}

  DateTime? _selectDate;

  void _byDayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: startDate,
      lastDate: endDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      checkDate(picked);
      setState(() {
        _selectDate = picked;
        now = false;
      });
    });
  }

  Color checkColor(AttendanceById attendance) {
    if (attendance.checkin1!.type == 'absent') {
      return Colors.red;
    }
    if (attendance.checkin1!.type == 'permission') {
      return Colors.blue;
    }
    if (attendance.checkin1!.type == 'checkout') {
      return Colors.lightGreen;
    }
    if (attendance.checkin1!.date!.hour >= 7 &&
        attendance.checkin1!.date!.minute >= 16 &&
        attendance.checkin1!.code == 'cin1' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin1!.date!.hour >= 13 &&
        attendance.checkin1!.date!.minute >= 16 &&
        attendance.checkin1!.code == 'cin2' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.yellow;
    }
    if (attendance.checkin1!.date!.hour == 7 &&
        attendance.checkin1!.date!.minute <= 15 &&
        attendance.checkin1!.code == 'cin1' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.green;
    }
    if (attendance.checkin1!.code == 'cin3') {
      return Color(0xffd4d2bc);
    }
    if (attendance.checkin1!.date!.hour == 13 &&
        attendance.checkin1!.date!.minute <= 15 &&
        attendance.checkin1!.code == 'cin2' &&
        attendance.checkin1!.type == 'checkin') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    DateTime? startTime;
    DateTime? endTime;
    _attendanceDisplay.asMap().forEach((key, value) {
      Appointment newAppointment = Appointment(
        startTime: value.checkin1?.date as DateTime,
        endTime: value.checkout1?.date as DateTime,
        color: checkColor(value),
      );
      meetings.add(newAppointment);
    });
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: _isLoading
          ? Container(
              padding: const EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Fetching Data'),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            )
          : attendanceAllDisplay.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 200, left: 40),
                  child: Column(
                    children: [
                      Text(
                        'NO ATTENDANCE ADDED YET!!',
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
                )
              : Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 120,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kLightBlue,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 20),
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.white,
                                          )),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: Image.network(
                                          attendanceAllDisplay[0].users!.image!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 75,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 25, top: 25),
                                    child: Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'ID: ',
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 45,
                                              ),
                                              Text(
                                                attendanceAllDisplay[0]
                                                    .users!
                                                    .id
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Name: ',
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                attendanceAllDisplay[0]
                                                    .users!
                                                    .name
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 550,
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
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
                                    borderRadius:
                                        const BorderRadius.all(kBorderRadius),
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
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: isFilterExpanded,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),

                                          /// SORT FILTER
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: kDarkestBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: DropdownButton(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          kBorderRadius),
                                                  dropdownColor: kDarkestBlue,
                                                  underline: Container(),
                                                  style: kParagraph.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  isDense: true,
                                                  value: sortByValue,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  items: dropdownItems
                                                      .map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    if (sortByValue == newValue)
                                                      return;
                                                    setState(() {
                                                      sortByValue =
                                                          newValue as String;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),

                                          /// FROM FILTER
                                          Visibility(
                                            visible: sortByValue != 'All Time',
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  sortByValue == 'Day'
                                                      ? "Date"
                                                      : 'From',
                                                  style: kParagraph,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    textStyle: kParagraph,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                    backgroundColor:
                                                        kDarkestBlue,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              kBorderRadius),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final DateTime? picked =
                                                        await buildDateTimePicker(
                                                      context: context,
                                                      date: startDate,
                                                    );
                                                    if (picked != null &&
                                                        picked != startDate) {
                                                      setState(() {
                                                        startDate = picked;
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        getDateStringFromDateTime(
                                                            startDate),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                          MdiIcons.calendar),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// TO FILTER
                                          Visibility(
                                            visible:
                                                sortByValue == 'Multiple Days',
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text('To',
                                                    style: kParagraph),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    textStyle: kParagraph,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                    backgroundColor:
                                                        kDarkestBlue,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              kBorderRadius),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final DateTime? picked =
                                                        await buildDateTimePicker(
                                                      context: context,
                                                      date: endDate,
                                                    );
                                                    if (picked != null &&
                                                        picked != endDate) {
                                                      setState(() {
                                                        endDate = picked;
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        getDateStringFromDateTime(
                                                            endDate),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                          MdiIcons.calendar),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// GO BUTTON
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                                  primary: Colors.white,
                                                  textStyle: kParagraph,
                                                  backgroundColor:
                                                      Colors.black38,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            kBorderRadius),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (sortByValue ==
                                                      'Multiple Days') {
                                                    setState(() {
                                                      multipleDay = true;
                                                    });
                                                    fetchLate();
                                                    fetchLateNoon();
                                                    fetchAbsent();
                                                    fetchAbsentNoon();
                                                    fetchPermission();
                                                    fetchPermissionNoon();
                                                    fetchPresent();
                                                    fetchPresentNoon();
                                                  }
                                                  if (sortByValue ==
                                                      'All Time') {
                                                    setState(() {
                                                      multipleDay = false;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Go',
                                                      style:
                                                          kParagraph.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Icon(
                                                        MdiIcons.chevronRight)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Present: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              afternoon
                                                  ? multipleDay
                                                      ? presentAfternoon
                                                          .toString()
                                                      : countPresentNoon
                                                          .toString()
                                                  : multipleDay
                                                      ? presentMorning
                                                          .toString()
                                                      : countPresent.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Permission: ',
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                          Text(
                                            afternoon
                                                ? multipleDay
                                                    ? permissionAfternoon
                                                        .toString()
                                                    : countPermissionNoon
                                                        .toString()
                                                : multipleDay
                                                    ? permissionMorning
                                                        .toString()
                                                    : countPermission
                                                        .toString(),
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Late: ',
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                            Text(
                                              afternoon
                                                  ? multipleDay
                                                      ? lateAfternoon.toString()
                                                      : countLateNoon.toString()
                                                  : multipleDay
                                                      ? lateMorning.toString()
                                                      : countLate.toString(),
                                              style: kHeadingFour.copyWith(
                                                  color: kWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Absent: ',
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                          Text(
                                            afternoon
                                                ? multipleDay
                                                    ? absentAfternoon.toString()
                                                    : countAbsentNoon.toString()
                                                : multipleDay
                                                    ? absentMorning.toString()
                                                    : countAbsent.toString(),
                                            style: kHeadingFour.copyWith(
                                                color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // Container(
                            //   margin: const EdgeInsets.all(20),
                            //   padding:
                            //       const EdgeInsets.only(top: 40, right: 10),
                            //   child: SfCalendar(
                            //     view: CalendarView.month,
                            //     dataSource:
                            //         MeetingDataSource(getAppointments()),
                            //     todayHighlightColor: Colors.grey,
                            //     headerHeight: 25,
                            //     scheduleViewSettings:
                            //         const ScheduleViewSettings(
                            //             appointmentTextStyle:
                            //                 TextStyle(color: Colors.black)),
                            //     cellBorderColor: Colors.grey,
                            //     allowedViews: const [
                            //       CalendarView.month,
                            //       CalendarView.schedule,
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Text(
                                    _selectDate == null
                                        ? 'Pick a Date'
                                        : 'Date: ${DateFormat.yMd().format(_selectDate as DateTime)}',
                                    style: kParagraph.copyWith(fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  OutlineButton.icon(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _byDayDatePicker();
                                      });
                                    },
                                    icon: Icon(Icons.calendar_today),
                                    label: Text('Choose Date'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    return now
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 8,
                                            ),
                                            color: index % 2 == 0
                                                ? Color(0xff177d9c)
                                                : kBlue,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(isToday?[index]
                                                          .date as DateTime),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(isToday![index].type!,
                                                        style: kParagraph),
                                                    PopupMenuButton(
                                                      color: Colors.black,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      onSelected: (int
                                                          selectedValue) async {
                                                        if (selectedValue ==
                                                            0) {
                                                          final int userId =
                                                              isToday![index]
                                                                  .userId!;
                                                          final int id =
                                                              isToday![index]
                                                                  .id!;
                                                          final String type =
                                                              isToday![index]
                                                                  .type!;
                                                          final DateTime date =
                                                              isToday![index]
                                                                  .date!;
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  AttedancesEdit(
                                                                id: id,
                                                                userId: userId,
                                                                type: type,
                                                                date: date,
                                                              ),
                                                            ),
                                                          );
                                                          attendanceAllDisplay =
                                                              [];
                                                          _attendanceAllService
                                                              .findManyByUserId(
                                                                  userId:
                                                                      widget.id)
                                                              .then((value) {
                                                            setState(() {
                                                              attendanceAllDisplay
                                                                  .addAll(
                                                                      value);
                                                              _isLoading =
                                                                  false;
                                                              var now = DateTime
                                                                  .now();
                                                              var today = attendanceAllDisplay
                                                                  .where((element) =>
                                                                      element.date?.day == now.day &&
                                                                      element.date
                                                                              ?.month ==
                                                                          now
                                                                              .month &&
                                                                      element.date
                                                                              ?.year ==
                                                                          now.year)
                                                                  .toList();
                                                              isToday = today
                                                                  .toList();
                                                              isToday?.sort((a,
                                                                      b) =>
                                                                  a.id!.compareTo(
                                                                      b.id!));
                                                            });
                                                          });
                                                        }
                                                        if (selectedValue ==
                                                            1) {
                                                          print(isToday?[index]
                                                              .id);
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                              title: Text(
                                                                  'Are you sure?'),
                                                              content: Text(
                                                                  'This action cannot be undone!'),
                                                              actions: [
                                                                OutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    deleteData(
                                                                        isToday?[index].id
                                                                            as int);
                                                                  },
                                                                  child: Text(
                                                                      'Yes'),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.green),
                                                                ),
                                                                OutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red),
                                                                  child: Text(
                                                                      'No'),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (_) => [
                                                        PopupMenuItem(
                                                          child: Text('Edit',
                                                              style: kParagraph.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          value: 0,
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text('Delete',
                                                              style: kParagraph.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          value: 1,
                                                        ),
                                                      ],
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 8,
                                            ),
                                            color:
                                                index % 2 == 0 ? color : color1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(checkedDate[index]
                                                          .date!),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        checkedDate[index]
                                                            .type!,
                                                        style: kParagraph),
                                                    PopupMenuButton(
                                                      color: Colors.black,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      onSelected: (int
                                                          selectedValue) async {
                                                        if (selectedValue ==
                                                            0) {
                                                          final int userId =
                                                              checkedDate[index]
                                                                  .userId!;
                                                          final int id =
                                                              checkedDate[index]
                                                                  .id!;
                                                          final String type =
                                                              checkedDate[index]
                                                                  .type!;
                                                          final DateTime date =
                                                              checkedDate[index]
                                                                  .date!;
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  AttedancesEdit(
                                                                id: id,
                                                                userId: userId,
                                                                type: type,
                                                                date: date,
                                                              ),
                                                            ),
                                                          );
                                                          attendanceAllDisplay =
                                                              [];
                                                          checkedDate = [];
                                                          users = [];
                                                          _attendanceAllService
                                                              .findManyByUserId(
                                                                  userId:
                                                                      widget.id)
                                                              .then((value) {
                                                            setState(() {
                                                              attendanceAllDisplay
                                                                  .addAll(
                                                                      value);
                                                              _isLoading =
                                                                  false;
                                                              var checkingDate = attendanceAllDisplay.where((element) =>
                                                                  element.date?.day == _selectDate?.day &&
                                                                  element.date
                                                                          ?.month ==
                                                                      _selectDate
                                                                          ?.month &&
                                                                  element.date
                                                                          ?.year ==
                                                                      _selectDate
                                                                          ?.year);
                                                              setState(() {
                                                                users =
                                                                    checkingDate
                                                                        .toList();
                                                                checkedDate =
                                                                    users;
                                                                checkedDate.sort((a,
                                                                        b) =>
                                                                    a.id!.compareTo(
                                                                        b.id!));
                                                              });
                                                            });
                                                          });
                                                        }
                                                        if (selectedValue ==
                                                            1) {
                                                          print(
                                                              checkedDate[index]
                                                                  .id);
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                              title: Text(
                                                                  'Are you sure?'),
                                                              content: Text(
                                                                  'This action cannot be undone!'),
                                                              actions: [
                                                                OutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    deleteData1(
                                                                        checkedDate[index].id
                                                                            as int);
                                                                  },
                                                                  child: Text(
                                                                      'Yes'),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.green),
                                                                ),
                                                                OutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red),
                                                                  child: Text(
                                                                      'No'),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (_) => [
                                                        PopupMenuItem(
                                                          child: Text(
                                                            'Edit',
                                                            style: kParagraph
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          value: 0,
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text(
                                                            'Delete',
                                                            style: kParagraph
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          value: 1,
                                                        ),
                                                      ],
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                  },
                                  itemCount: now
                                      ? isToday?.length
                                      : checkedDate.length,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
