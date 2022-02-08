import 'package:ems/models/attendances.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_attendacnace_list.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_no_attendance.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_no_data.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_present.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/attendance/attendacne_all_time_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  AttendanceService _attendanceNoDateService = AttendanceService.instance;
  List<Attendance> attendanceDisplay = [];
  List<Attendance> attendanceAllDisplay = [];
  List<AttendanceWithDate> _attendanceDisplay = [];
  List<AttendanceWithDate> _attendanceNoDateDisplay = [];

  AttendanceService _attendanceService = AttendanceService.instance;
  List<Attendances> attendancesDisplay = [];
  List<AttendancesWithDate> attendancesByIdDisplay = [];
  List<AttendancesWithDate> attendanceList = [];
  List<AttendancesWithDate> _attendanceAll = [];
  List attendanceListAll = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool now = true;
  bool alltime = false;
  bool isOneDay = false;
  bool multiday = false;
  bool isFilterExpanded = false;
  bool _isLoading = true;
  List isToday = [];
  List<AttendancesWithDate> onedayList = [];
  String sortByValue = '';
  List<String> dropdownItems = [];

  String dropDownValue = '';
  bool afternoon = false;
  dynamic countPresent,
      countPresentNoon,
      countLate,
      countLateNoon,
      countAbsent,
      countAbsentNoon,
      countPermission,
      countPermissionNoon,
      lateMorning,
      lateAfternoon,
      absentMorning,
      absentAfternoon,
      permissionMorning,
      permissionAfternoon,
      presentMorning,
      presentAfternoon,
      presentAll,
      lateAll,
      permissionAll,
      absentAll;
  bool multipleDay = false;
  bool _isLoadingNoDate = true;
  bool order = false;
  List<Appointment>? _appointment;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  List isTodayNoon = [];
  List oneDayMorning = [];
  List oneDayNoon = [];
  List attendanceListNoon = [];
  int? onedayPresent,
      onedayPresentNoon,
      onedayLate,
      onedayLateNoon,
      onedayPermission,
      onedayPermissionNoon,
      onedayAbsent,
      onedayAbsentNoon,
      todayPresent,
      todayPresentNoon,
      todayLate,
      todayLateNoon,
      todayPermission,
      todayPermissionNoon,
      todayAbsent,
      todayAbsentNoon;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  fetchNoDate() async {
    try {
      List<AttendanceWithDate> attendanceNoDateDisplay =
          await _attendanceNoDateService.findManyByUserIdNoOvertime(
              userId: widget.id);
      setState(() {
        _attendanceNoDateDisplay = attendanceNoDateDisplay;
        _isLoadingNoDate = false;
      });
    } catch (e) {}
  }

  // fetchAllAttendance() async {
  //   _isLoading = true;
  //   try {
  //     List<AttendancesWithDate> attendanceDisplay = await _attendanceService
  //         .findManyByUserIdNoOvertime(userId: widget.id);
  //     setState(() {
  //       _attendanceAll = attendanceDisplay;
  //       _isLoading = false;
  //     });
  //     List flat = _attendanceAll.expand((element) => element.list).toList();
  //     attendanceListAll = flat.toList();
  //   } catch (e) {}
  // }

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

  fetchAttedancesById() async {
    try {
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(
        userId: 1,
        start: startDate,
        end: endDate,
      );
      setState(() {
        attendancesByIdDisplay = attendanceDisplay;

        var now = DateTime.now();
        var today = attendancesByIdDisplay.where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year);

        List todayFlat = today.expand((element) => element.list).toList();
        isToday = todayFlat;

        var oneDay = attendanceDisplay.where((element) =>
            element.date.day == startDate.day &&
            element.date.month == startDate.month &&
            element.date.year == startDate.year);
        onedayList = oneDay.toList();
        attendanceList = attendancesByIdDisplay;
        print(attendanceList);
      });
    } catch (err) {}
  }

  fetchAllAttendance() async {
    _isLoading = true;
    try {
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(userId: 1);
      setState(() {
        _attendanceAll = attendanceDisplay;
        _isLoading = false;
      });
      List flat = _attendanceAll.expand((element) => element.list).toList();
      attendanceListAll = flat.toList();
    } catch (e) {}
  }

  fetchManyAttendances() {
    try {
      _attendanceService.findManyAttendances().then((usersFromServer) {
        if (mounted) {
          setState(() {
            attendancesDisplay = [];
            attendancesDisplay.addAll(usersFromServer);
          });
        }
      });
    } catch (err) {}
  }

  fetchAttendanceByIdNoon() async {
    try {
      _isLoading = true;
      List<AttendanceWithDate> attendanceDisplay =
          await _attendanceService.findManyByUserIdNoOvertime(
        userId: widget.id,
        start: startDate,
        end: endDate,
      );
      setState(() {
        _attendanceDisplay = attendanceDisplay;
        _isLoading = false;
        var now = DateTime.now();
        var today = attendanceDisplay.where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year);
        List todayFlat = today.expand((element) => element.list).toList();
        var oneDay = attendanceDisplay.where((element) =>
            element.date.day == startDate.day &&
            element.date.month == startDate.month &&
            element.date.year == startDate.year);
        List oneDayFlat = oneDay.expand((element) => element.list).toList();
      });
      attendanceListNoon = _attendanceDisplay;
    } catch (e) {}
  }

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/attendances";

  Future deleteData(int id) async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final response = await http.delete(Uri.parse("$url/$id"));
    showInSnackBar("${local?.deletingAttendance}");
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      attendanceList = [];
      _attendanceAll = [];
      onedayList = [];
      // fetchAttendanceById();
      // fetchAllAttendance();
      showInSnackBar("${local?.deletedAttendance}");
    } else {
      return false;
    }
  }

  Future deleteData1(int id) async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final response = await http.delete(Uri.parse("$url/$id"));
    showInSnackBar("${local?.deletingAttendance}");
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      attendanceList = [];
      _attendanceAll = [];
      onedayList = [];
      // fetchAttendanceById();
      // fetchAllAttendance();
      showInSnackBar("${local?.deletedAttendance}");
    } else {
      return false;
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2000),
        backgroundColor: kBlueBackground,
        content: Text(
          value,
          style: kHeadingFour.copyWith(color: Colors.black),
        ),
      ),
    );
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
    _isLoading = true;
    var pc = await _attendanceService.countAbsentByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        absentMorning = pc;
        _isLoading = false;
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

  getPresentAll() async {
    var pc = await _attendanceService.countPresentAll(widget.id);
    if (mounted) {
      setState(() {
        presentAll = pc;
      });
    }
  }

  getAbsentAll() async {
    var pc = await _attendanceService.countAbsentAll(widget.id);
    if (mounted) {
      setState(() {
        absentAll = pc;
      });
    }
  }

  getLateAll() async {
    var pc = await _attendanceService.countLateAll(widget.id);
    if (mounted) {
      setState(() {
        lateAll = pc;
      });
    }
  }

  getPermissionAll() async {
    var pc = await _attendanceService.countPermissionAll(widget.id);
    if (mounted) {
      setState(() {
        permissionAll = pc;
      });
    }
  }

  void toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      getAbsentAll();
      getPermissionAll();
      getPresentAll();
      getLateAll();
      getPresent();
      getPresentNoon();
      getLate();
      getLateNoon();
      getAbsent();
      getAbsentNoon();
      getPermission();
      getPermissionNoon();
      // fetchAttendanceById();
      fetchAttendanceByIdNoon();
      fetchNoDate();
      fetchLate();
      fetchLateNoon();
      fetchAbsent();
      fetchAbsentNoon();
      fetchPermission();
      fetchPermissionNoon();
      fetchPresent();
      fetchPresentNoon();
      // fetchAllAttendance();
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
      if (dropdownItems.isEmpty) {
        dropdownItems = [
          '${local?.optionDay}',
          '${local?.optionMultiDay}',
          '${local?.optionAllTime}',
        ];
      }
      if (sortByValue.isEmpty) {
        sortByValue = local!.optionAllTime;
      }
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${local?.attendance}'),
      ),
      body: _isLoading && _isLoadingNoDate
          ? Container(
              padding: const EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${local?.fetchData}'),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/Gear-0.5s-200px.gif',
                      width: 60,
                    )
                  ],
                ),
              ),
            )
          : _isLoadingNoDate
              ? Container(
                  padding: const EdgeInsets.only(top: 320),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local?.fetchData}'),
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'assets/images/Gear-0.5s-200px.gif',
                          width: 60,
                        )
                      ],
                    ),
                  ),
                )
              : _attendanceNoDateDisplay.isEmpty
                  ? AttendanceInfoNoAttenance()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: toggleFilter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${local?.filter}',
                                          style: kParagraph.copyWith(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(
                                          isFilterExpanded
                                              ? MdiIcons.chevronUp
                                              : MdiIcons.chevronDown,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
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
                                            Text('${local?.dateRange}',
                                                style: kParagraph),
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
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: dropdownItems
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
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
                                          visible: sortByValue !=
                                              '${local?.optionAllTime}',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                sortByValue ==
                                                        '${local?.optionDay}'
                                                    ? "Date"
                                                    : '${local?.from}',
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
                                                  backgroundColor: kDarkestBlue,
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
                                          visible: sortByValue ==
                                              '${local?.optionMultiDay}',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${local?.to}',
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
                                                  backgroundColor: kDarkestBlue,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 16),
                                                primary: Colors.white,
                                                textStyle: kParagraph,
                                                backgroundColor: Colors.black38,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          kBorderRadius),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (sortByValue ==
                                                    '${local?.optionMultiDay}') {
                                                  setState(() {
                                                    alltime = false;
                                                    multipleDay = true;
                                                    now = false;
                                                    isFilterExpanded = false;
                                                    isOneDay = false;
                                                  });
                                                  attendanceList = [];
                                                  attendanceListNoon = [];
                                                  attendanceListAll = [];
                                                  fetchLate();
                                                  fetchLateNoon();
                                                  fetchAbsent();
                                                  fetchAbsentNoon();
                                                  fetchPermission();
                                                  fetchPermissionNoon();
                                                  fetchPresent();
                                                  fetchPresentNoon();
                                                  // fetchAttendanceById();
                                                  fetchAttendanceByIdNoon();
                                                }
                                                if (sortByValue ==
                                                    '${local?.optionAllTime}') {
                                                  setState(() {
                                                    multipleDay = false;
                                                    now = false;
                                                    alltime = true;
                                                    isFilterExpanded = false;
                                                    isOneDay = false;
                                                  });
                                                  attendanceList = [];
                                                  attendanceListNoon = [];
                                                  attendanceListAll = [];
                                                  // fetchAllAttendance();
                                                  getAbsentAll();
                                                  getPermissionAll();
                                                  getPresentAll();
                                                  getLateAll();
                                                }
                                                if (sortByValue ==
                                                    '${local?.optionDay}') {
                                                  setState(() {
                                                    multipleDay = false;
                                                    now = false;
                                                    alltime = false;
                                                    isFilterExpanded = false;
                                                    isOneDay = true;
                                                  });
                                                  fetchLate();
                                                  fetchLateNoon();
                                                  fetchAbsent();
                                                  fetchAbsentNoon();
                                                  fetchPermission();
                                                  fetchPermissionNoon();
                                                  fetchPresent();
                                                  fetchPresentNoon();
                                                  // fetchAttendanceById();
                                                  fetchAttendanceByIdNoon();
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Go',
                                                    style: kParagraph.copyWith(
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
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: kDarkestBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              // AttendanceInfoNameId(
                              //     name: _attendanceNoDateDisplay[0]
                              //         .list[0]
                              //         .users!
                              //         .name
                              //         .toString(),
                              //     id: _attendanceNoDateDisplay[0]
                              //         .list[0]
                              //         .users!
                              //         .id
                              //         .toString(),
                              //     image: _attendanceNoDateDisplay[0]
                              //         .list[0]
                              //         .users!
                              //         .image
                              //         .toString()),
                              SizedBox(
                                height: 25,
                              ),
                              //   Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceAround,
                              //     children: [
                              //       AttendanceInfoPresent(
                              //           numColor: kGreenText,
                              //           backgroundColor: kGreenBackground,
                              //           now: now,
                              //           todayMorning: todayPresent.toString(),
                              //           todayAfternoon:
                              //               todayPresentNoon.toString(),
                              //           isLoading: _isLoading,
                              //           isOneday: isOneDay,
                              //           onedayMorning: onedayPresent.toString(),
                              //           onedayAfternoon:
                              //               onedayPresentNoon.toString(),
                              //           presentAll: presentAll.toString(),
                              //           alltime: alltime,
                              //           text: '${local?.present} ',
                              //           afternoon: afternoon,
                              //           multipleDay: multipleDay,
                              //           presentAfternoon: presentAfternoon == null
                              //               ? '♽'
                              //               : presentAfternoon.toString(),
                              //           countPresentNoon: countPresentNoon == null
                              //               ? '♽'
                              //               : countPresentNoon.toString(),
                              //           presentMorning: presentMorning == null
                              //               ? '♽'
                              //               : presentMorning.toString(),
                              //           countPresent: countPresent == null
                              //               ? '♽'
                              //               : countPresent.toString()),
                              //       AttendanceInfoPresent(
                              //           numColor: kBlueText,
                              //           backgroundColor: kBlueBackground,
                              //           now: now,
                              //           todayMorning: todayPermission.toString(),
                              //           todayAfternoon:
                              //               todayPermissionNoon.toString(),
                              //           isLoading: _isLoading,
                              //           isOneday: isOneDay,
                              //           onedayMorning:
                              //               onedayPermission.toString(),
                              //           onedayAfternoon:
                              //               onedayPermissionNoon.toString(),
                              //           presentAll: permissionAll.toString(),
                              //           alltime: alltime,
                              //           text: '${local?.permission} ',
                              //           afternoon: afternoon,
                              //           multipleDay: multipleDay,
                              //           presentAfternoon:
                              //               permissionAfternoon == null
                              //                   ? '♽'
                              //                   : permissionAfternoon.toString(),
                              //           countPresentNoon:
                              //               countPermissionNoon == null
                              //                   ? '♽'
                              //                   : countPermissionNoon.toString(),
                              //           presentMorning: permissionMorning == null
                              //               ? '♽'
                              //               : permissionMorning.toString(),
                              //           countPresent: countPermission == null
                              //               ? '♽'
                              //               : countPermission.toString()),
                              //       AttendanceInfoPresent(
                              //           numColor: kYellowText,
                              //           backgroundColor: kYellowBackground,
                              //           now: now,
                              //           todayMorning: todayLate.toString(),
                              //           todayAfternoon: todayLateNoon.toString(),
                              //           isLoading: _isLoading,
                              //           isOneday: isOneDay,
                              //           onedayMorning: onedayLate.toString(),
                              //           onedayAfternoon:
                              //               onedayLateNoon.toString(),
                              //           presentAll: lateAll.toString(),
                              //           alltime: alltime,
                              //           text: '${local?.late} ',
                              //           afternoon: afternoon,
                              //           multipleDay: multipleDay,
                              //           presentAfternoon: lateAfternoon == null
                              //               ? '♽'
                              //               : lateAfternoon.toString(),
                              //           countPresentNoon: countLateNoon == null
                              //               ? '♽'
                              //               : countLateNoon.toString(),
                              //           presentMorning: lateMorning == null
                              //               ? '♽'
                              //               : lateMorning.toString(),
                              //           countPresent: countLate == null
                              //               ? '♽'
                              //               : countLate.toString()),
                              //       AttendanceInfoPresent(
                              //           numColor: kRedText,
                              //           backgroundColor: kRedBackground,
                              //           now: now,
                              //           todayMorning: todayAbsent.toString(),
                              //           todayAfternoon:
                              //               todayAbsentNoon.toString(),
                              //           isLoading: _isLoading,
                              //           isOneday: isOneDay,
                              //           onedayMorning: onedayAbsent.toString(),
                              //           onedayAfternoon:
                              //               onedayAbsentNoon.toString(),
                              //           presentAll: absentAll.toString(),
                              //           alltime: alltime,
                              //           text: '${local?.absent} ',
                              //           afternoon: afternoon,
                              //           multipleDay: multipleDay,
                              //           presentAfternoon: absentAfternoon == null
                              //               ? '♽'
                              //               : absentAfternoon.toString(),
                              //           countPresentNoon: countAbsentNoon == null
                              //               ? '♽'
                              //               : countAbsentNoon.toString(),
                              //           presentMorning: absentMorning == null
                              //               ? '♽'
                              //               : absentMorning.toString(),
                              //           countPresent: countAbsent == null
                              //               ? '♽'
                              //               : countAbsent.toString())
                              //     ],
                              //   ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),

                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: isEnglish ? 10 : 0,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 22, right: 32, top: 12, bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          isEnglish
                                              ? '${local?.attendance} '
                                              : '${local?.list} ',
                                          style: kHeadingThree,
                                        ),
                                        Text(
                                          isEnglish
                                              ? '${local?.list} '
                                              : '${local?.attendance} ',
                                          style: kHeadingThree,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: !alltime
                                          ? Container(
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
                                                value: dropDownValue,
                                                onChanged: (String? newValue) {
                                                  if (newValue ==
                                                      '${local?.afternoon}') {
                                                    setState(() {
                                                      afternoon = true;
                                                      dropDownValue = newValue!;
                                                    });
                                                  }
                                                  if (newValue ==
                                                      '${local?.morning}') {
                                                    setState(() {
                                                      afternoon = false;
                                                      dropDownValue = newValue!;
                                                    });
                                                  }
                                                },
                                                items: <String>[
                                                  '${local?.morning}',
                                                  '${local?.afternoon}',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          : Container(),
                                    )
                                  ],
                                ),
                              ),
                              isToday.isEmpty && now && isTodayNoon.isEmpty
                                  ? AttendanceInfoNoData()
                                  : _isLoading
                                      ? Container(
                                          padding: EdgeInsets.only(top: 150),
                                          child: Column(
                                            children: [
                                              Text('${local?.fetchData}'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Image.asset(
                                                  'assets/images/Gear-0.5s-200px.gif',
                                                  width: 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: AttendanceInfoAttendanceList(
                                                multiday: multiday,
                                                isOneDay: isOneDay,
                                                alltime: alltime,
                                                now: now,
                                                attendanceList: attendanceList,
                                                onedayList: onedayList,
                                                attendanceListAll:
                                                    attendanceListAll,
                                                attendancesByIdDisplay:
                                                    attendancesByIdDisplay,
                                                attendanceAll: _attendanceAll,
                                                fetchAttedancesById:
                                                    fetchAttedancesById,
                                                fetchAllAttendance:
                                                    fetchAllAttendance),
                                          ),
                                        ),
                            ],
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
