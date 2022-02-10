import 'package:ems/models/attendances.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';
import 'attendances_api/widgets/attendance_info/attendance_info_present.dart';

class TestAttendances extends StatefulWidget {
  @override
  State<TestAttendances> createState() => _TestAttendancesState();
}

class _TestAttendancesState extends State<TestAttendances> {
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
  bool afternoon = false;
  List<AttendancesWithDate> isToday = [];
  List<AttendancesWithDate> onedayList = [];
  String sortByValue = '';
  String dropDownValue = '';
  List<String> dropdownItems = [];
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
      todayAbsentNoon,
      presentAll,
      lateAll,
      permissionAll,
      absentAll,
      presentMorning,
      presentAfternoon,
      permissionMorning,
      permissionAfternoon,
      lateMorning,
      lateAfternoon,
      absentMorning,
      absentAfternoon;

  final UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];
  fetchUserById() async {
    try {
      _isLoading = true;
      _userService.findOne(3).then((usersFromServer) {
        if (mounted) {
          setState(() {
            user = [];
            userDisplay = [];
            _isLoading = true;
            user.add(usersFromServer);
            userDisplay = user;
            _isLoading = false;
          });
        }
      });
    } catch (err) {}
  }

  fetchAllAttendance() async {
    _isLoading = true;
    try {
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(userId: 3);
      setState(() {
        _attendanceAll = attendanceDisplay;
        _isLoading = false;
      });
      List flat = _attendanceAll.expand((element) => element.list).toList();
      attendanceListAll = flat.toList();
      int presentAllMorning = attendanceDisplay
          .where((element) =>
              element.list[0].getT1 != null && checkPresent(element))
          .length;
      int presentAllAfternoon = attendanceDisplay
          .where((element) =>
              element.list[0].getT3 != null && checkPresengetT2(element))
          .length;
      int lateAllMorning = attendanceDisplay
          .where(
              (element) => element.list[0].getT1 != null && checkLate1(element))
          .length;
      int lateAllAfternoon = attendanceDisplay
          .where(
              (element) => element.list[0].getT3 != null && checkLate2(element))
          .length;
      int absentAllMorning = attendanceDisplay
          .where((element) =>
              element.list[0].getT1 != null && checkAbsengetT1(element))
          .length;
      int absentAllAfternoon = attendanceDisplay
          .where((element) =>
              element.list[0].getT3 != null && checkAbsengetT2(element))
          .length;
      int permissionAllMorning = attendanceDisplay
          .where((element) =>
              element.list[0].getT1 != null && checkPermissiongetT1(element))
          .length;
      int permissionAllAfternoon = attendanceDisplay
          .where((element) =>
              element.list[0].getT3 != null && checkPermissiongetT2(element))
          .length;
      presentAll = presentAllMorning + presentAllAfternoon;
      lateAll = lateAllMorning + lateAllAfternoon;
      absentAll = absentAllMorning + absentAllAfternoon;
      permissionAll = permissionAllMorning + permissionAllAfternoon;
    } catch (e) {}
  }

  fetchAttedancesById() async {
    try {
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(
        userId: 3,
        start: startDate,
        end: endDate,
      );
      setState(() {
        attendancesByIdDisplay = attendanceDisplay;

        presentMorning = attendanceDisplay
            .where((element) =>
                element.list[0].getT1 != null && checkPresent(element))
            .length;
        presentAfternoon = attendanceDisplay
            .where((element) =>
                element.list[0].getT3 != null && checkPresent(element))
            .length;
        absentMorning = attendanceDisplay
            .where((element) =>
                element.list[0].getT1 != null && checkAbsengetT1(element))
            .length;
        absentAfternoon = attendanceDisplay
            .where((element) =>
                element.list[0].getT3 != null && checkAbsengetT2(element))
            .length;
        lateMorning = attendanceDisplay
            .where((element) =>
                element.list[0].getT1 != null && checkLate1(element))
            .length;
        lateAfternoon = attendanceDisplay
            .where((element) =>
                element.list[0].getT3 != null && checkLate2(element))
            .length;
        permissionMorning = attendanceDisplay
            .where((element) =>
                element.list[0].getT1 != null && checkPermissiongetT1(element))
            .length;
        permissionAfternoon = attendanceDisplay
            .where((element) =>
                element.list[0].getT3 != null && checkPermissiongetT2(element))
            .length;
        var now = DateTime.now();
        var today = attendancesByIdDisplay.where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year);

        List todayFlat = today.expand((element) => element.list).toList();
        isToday = today.toList();
        todayPresent = isToday
            .where((element) =>
                element.list[0].getT1 != null && checkPresent(element))
            .length;
        todayPresentNoon = isToday
            .where((element) =>
                element.list[0].getT3 != null && checkPresengetT2(element))
            .length;
        todayLate = isToday
            .where((element) =>
                element.list[0].getT1 != null && checkLate1(element))
            .length;
        todayLateNoon = isToday
            .where((element) =>
                element.list[0].getT3 != null && checkLate2(element))
            .length;
        todayAbsent = isToday
            .where((element) =>
                element.list[0].getT1 != null && checkAbsengetT1(element))
            .length;
        todayAbsentNoon = isToday
            .where((element) =>
                element.list[0].getT3 != null && checkAbsengetT2(element))
            .length;
        todayPermission = isToday
            .where((element) =>
                element.list[0].getT1 != null && checkPermissiongetT1(element))
            .length;
        todayPermissionNoon = isToday
            .where((element) =>
                element.list[0].getT3 != null && checkPermissiongetT2(element))
            .length;

        var oneDay = attendanceDisplay.where((element) =>
            element.date.day == startDate.day &&
            element.date.month == startDate.month &&
            element.date.year == startDate.year);
        onedayList = oneDay.toList();

        onedayPresent = oneDay
            .where((element) =>
                element.list[0].getT1 != null && checkPresent(element))
            .length;
        onedayPresentNoon = oneDay
            .where((element) =>
                element.list[0].getT3 != null && checkPresengetT2(element))
            .length;
        onedayLate = oneDay
            .where((element) =>
                element.list[0].getT1 != null && checkLate1(element))
            .length;
        onedayLateNoon = oneDay
            .where((element) =>
                element.list[0].getT3 != null && checkLate2(element))
            .length;
        onedayAbsent = oneDay
            .where((element) =>
                element.list[0].getT1 != null && checkAbsengetT1(element))
            .length;
        onedayAbsentNoon = oneDay
            .where((element) =>
                element.list[0].getT3 != null && checkAbsengetT2(element))
            .length;
        onedayPermission = oneDay
            .where((element) =>
                element.list[0].getT1 != null && checkPermissiongetT1(element))
            .length;
        onedayPermissionNoon = oneDay
            .where((element) =>
                element.list[0].getT3 != null && checkPermissiongetT2(element))
            .length;
        attendanceList = attendancesByIdDisplay;
      });
    } catch (err) {}
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

  void toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchManyAttendances();
    fetchAttedancesById();
    fetchAllAttendance();
    fetchUserById();
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
      appBar: AppBar(
        title: Text('data'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${local?.dateRange}', style: kParagraph),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kDarkestBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton(
                                    borderRadius:
                                        const BorderRadius.all(kBorderRadius),
                                    dropdownColor: kDarkestBlue,
                                    underline: Container(),
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                    isDense: true,
                                    value: sortByValue,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: dropdownItems.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (sortByValue == newValue) return;
                                      setState(() {
                                        sortByValue = newValue as String;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            /// FROM FILTER
                            Visibility(
                              visible: sortByValue != '${local?.optionAllTime}',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sortByValue == '${local?.optionDay}'
                                        ? "Date"
                                        : '${local?.from}',
                                    style: kParagraph,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle: kParagraph,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      backgroundColor: kDarkestBlue,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(kBorderRadius),
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getDateStringFromDateTime(startDate),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(MdiIcons.calendar),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// TO FILTER
                            Visibility(
                              visible:
                                  sortByValue == '${local?.optionMultiDay}',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${local?.to}', style: kParagraph),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle: kParagraph,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      backgroundColor: kDarkestBlue,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(kBorderRadius),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await buildDateTimePicker(
                                        context: context,
                                        date: endDate,
                                      );
                                      if (picked != null && picked != endDate) {
                                        setState(() {
                                          endDate = picked;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getDateStringFromDateTime(endDate),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(MdiIcons.calendar),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// GO BUTTON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 16),
                                    primary: Colors.white,
                                    textStyle: kParagraph,
                                    backgroundColor: Colors.black38,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(kBorderRadius),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (sortByValue ==
                                        '${local?.optionMultiDay}') {
                                      setState(() {
                                        isOneDay = false;
                                        alltime = false;
                                        now = false;
                                        multiday = true;
                                        isFilterExpanded = false;
                                      });
                                      attendanceList = [];
                                      attendancesByIdDisplay = [];
                                      onedayList = [];
                                      fetchAttedancesById();
                                    }
                                    if (sortByValue ==
                                        '${local?.optionAllTime}') {
                                      setState(() {
                                        isOneDay = false;
                                        multiday = false;
                                        now = false;
                                        alltime = true;
                                        isFilterExpanded = false;
                                      });
                                      attendanceList = [];
                                      attendancesByIdDisplay = [];
                                      fetchAllAttendance();
                                    }
                                    if (sortByValue == '${local?.optionDay}') {
                                      setState(() {
                                        isOneDay = true;
                                        now = false;
                                        alltime = false;
                                        multiday = false;
                                        isFilterExpanded = false;
                                      });
                                      attendanceList = [];
                                      attendancesByIdDisplay = [];
                                      onedayList = [];
                                      fetchAttedancesById();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      Text(
                                        'Go',
                                        style: kParagraph.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Icon(MdiIcons.chevronRight)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttendanceInfoPresent(
                  isLoadingAll: true,
                  isLoadingById: true,
                  numColor: kGreenText,
                  backgroundColor: kGreenBackground,
                  now: now,
                  todayMorning: todayPresent.toString(),
                  todayAfternoon: todayPresentNoon.toString(),
                  isLoading: _isLoading,
                  isOneday: isOneDay,
                  onedayMorning: onedayPresent.toString(),
                  onedayAfternoon: onedayPresentNoon.toString(),
                  presentAll: presentAll.toString(),
                  alltime: alltime,
                  text: '${local?.present} ',
                  afternoon: afternoon,
                  multipleDay: multiday,
                  presentAfternoon: presentAfternoon == null
                      ? '♽'
                      : presentAfternoon.toString(),
                  presentMorning:
                      presentMorning == null ? '♽' : presentMorning.toString(),
                ),
                AttendanceInfoPresent(
                  isLoadingAll: true,
                  isLoadingById: true,
                  numColor: kBlueText,
                  backgroundColor: kBlueBackground,
                  now: now,
                  todayMorning: todayPermission.toString(),
                  todayAfternoon: todayPermissionNoon.toString(),
                  isLoading: _isLoading,
                  isOneday: isOneDay,
                  onedayMorning: onedayPermission.toString(),
                  onedayAfternoon: onedayPermissionNoon.toString(),
                  presentAll: permissionAll.toString(),
                  alltime: alltime,
                  text: '${local?.permission} ',
                  afternoon: afternoon,
                  multipleDay: multiday,
                  presentAfternoon: permissionAfternoon == null
                      ? '♽'
                      : permissionAfternoon.toString(),
                  presentMorning: permissionMorning == null
                      ? '♽'
                      : permissionMorning.toString(),
                ),
                AttendanceInfoPresent(
                  isLoadingAll: true,
                  isLoadingById: true,
                  numColor: kYellowText,
                  backgroundColor: kYellowBackground,
                  now: now,
                  todayMorning: todayLate.toString(),
                  todayAfternoon: todayLateNoon.toString(),
                  isLoading: _isLoading,
                  isOneday: isOneDay,
                  onedayMorning: onedayLate.toString(),
                  onedayAfternoon: onedayLateNoon.toString(),
                  presentAll: lateAll.toString(),
                  alltime: alltime,
                  text: '${local?.late} ',
                  afternoon: afternoon,
                  multipleDay: multiday,
                  presentAfternoon:
                      lateAfternoon == null ? '♽' : lateAfternoon.toString(),
                  presentMorning:
                      lateMorning == null ? '♽' : lateMorning.toString(),
                ),
                AttendanceInfoPresent(
                  isLoadingAll: true,
                  isLoadingById: true,
                  numColor: kRedText,
                  backgroundColor: kRedBackground,
                  now: now,
                  todayMorning: todayAbsent.toString(),
                  todayAfternoon: todayAbsentNoon.toString(),
                  isLoading: _isLoading,
                  isOneday: isOneDay,
                  onedayMorning: onedayAbsent.toString(),
                  onedayAfternoon: onedayAbsentNoon.toString(),
                  presentAll: absentAll.toString(),
                  alltime: alltime,
                  text: '${local?.absent} ',
                  afternoon: afternoon,
                  multipleDay: multiday,
                  presentAfternoon: absentAfternoon == null
                      ? '♽'
                      : absentAfternoon.toString(),
                  presentMorning:
                      absentMorning == null ? '♽' : absentMorning.toString(),
                )
              ],
            ),
            Container(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: multiday
                    ? attendanceList.length
                    : isOneDay
                        ? onedayList.length
                        : alltime
                            ? attendanceListAll.length
                            : attendancesByIdDisplay.length,
                itemBuilder: (context, index) {
                  late AttendancesWithDate all;
                  late AttendancesWithDate todayAttendance;
                  late AttendancesWithDate onedayAttendance;
                  late AttendancesWithDate multidayAttendance;
                  if (alltime) {
                    AttendancesWithDate allRecord = _attendanceAll[index];
                    all = allRecord;
                  }
                  if (now) {
                    AttendancesWithDate nowRecord = isToday[index];
                    todayAttendance = nowRecord;
                  }
                  if (isOneDay) {
                    AttendancesWithDate oneday = onedayList[index];
                    onedayAttendance = oneday;
                  }
                  if (multiday) {
                    AttendancesWithDate multiday = attendanceList[index];
                    multidayAttendance = multiday;
                  }

                  return multiday
                      ? _buildMultipleResult(multidayAttendance)
                      : isOneDay
                          ? _buildOnedayResult(onedayAttendance)
                          : alltime
                              ? _buildAllResult(all)
                              : _buildNowResult(todayAttendance);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkPresent(AttendancesWithDate element) {
    if (element.list[0].getT1?.note != 'absent') {
      if (element.list[0].getT1!.time.hour <= 7) {
        if (element.list[0].getT1!.time.minute <= 15) {
          return true;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesWithDate element) {
    if (element.list[0].getT3?.note != 'absent') {
      if (element.list[0].getT3!.time.hour <= 13) {
        if (element.list[0].getT3!.time.minute <= 15) {
          return true;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesWithDate element) {
    if (element.list[0].getT1?.note != 'absent') {
      if (element.list[0].getT1!.time.hour == 7) {
        if (element.list[0].getT1!.time.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT1!.time.hour > 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate2(AttendancesWithDate element) {
    if (element.list[0].getT3?.note != 'absent') {
      if (element.list[0].getT3!.time.hour == 13) {
        if (element.list[0].getT3!.time.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT3!.time.hour > 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkAbsengetT1(AttendancesWithDate element) {
    if (element.list[0].getT1!.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkAbsengetT2(AttendancesWithDate element) {
    if (element.list[0].getT3!.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT1(AttendancesWithDate element) {
    if (element.list[0].getT1!.note == 'permission') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT2(AttendancesWithDate element) {
    if (element.list[0].getT3!.note == 'permission') {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildAllResult(AttendancesWithDate record) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkin'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT1?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT1!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT1?.time.minute == null
                                    ? 'null'
                                    : ':${record.list[0].getT1!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( Present )'
                                      : checkLate1(record)
                                          ? '( late )'
                                          : checkAbsengetT1(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkout'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT2!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT2!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkin'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT3!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT3!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( Present )'
                                      : checkLate2(record)
                                          ? '( late )'
                                          : checkAbsengetT2(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkout'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT4!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT4!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkin'),
                    record.list[0].getT5?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT5!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT5!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('( OT )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkout'),
                    record.list[0].getT6?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT6!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT6!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildNowResult(AttendancesWithDate record) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkin'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT1?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT1!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT1?.time.minute == null
                                    ? 'null'
                                    : ':${record.list[0].getT1!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( Present )'
                                      : checkLate1(record)
                                          ? '( late )'
                                          : checkAbsengetT1(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkout'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT2!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT2!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkin'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT3!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT3!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( Present )'
                                      : checkLate2(record)
                                          ? '( late )'
                                          : checkAbsengetT2(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkout'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT4!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT4!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkin'),
                    record.list[0].getT5?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT5!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT5!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('( OT )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkout'),
                    record.list[0].getT6?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT6!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT6!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildOnedayResult(AttendancesWithDate record) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkin'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT1?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT1!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT1?.time.minute == null
                                    ? 'null'
                                    : ':${record.list[0].getT1!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( Present )'
                                      : checkLate1(record)
                                          ? '( late )'
                                          : checkAbsengetT1(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkout'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT2!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT2!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkin'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT3!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT3!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( Present )'
                                      : checkLate2(record)
                                          ? '( late )'
                                          : checkAbsengetT2(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkout'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT4!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT4!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkin'),
                    record.list[0].getT5?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT5!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT5!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('( OT )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkout'),
                    record.list[0].getT6?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT6!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT6!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMultipleResult(AttendancesWithDate record) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkin'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT1?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT1!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT1?.time.minute == null
                                    ? 'null'
                                    : ':${record.list[0].getT1!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( Present )'
                                      : checkLate1(record)
                                          ? '( late )'
                                          : checkAbsengetT1(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1: Checkout'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT2!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT2?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT2!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkin'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT3!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT3?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT3!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( Present )'
                                      : checkLate2(record)
                                          ? '( late )'
                                          : checkAbsengetT2(record)
                                              ? '( absent )'
                                              : '( permission )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2: Checkout'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT4!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT4?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT4!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kDarkestBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkin'),
                    record.list[0].getT5?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT5!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT5?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT5!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('( OT )'),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: kBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3: Checkout'),
                    record.list[0].getT6?.time.hour == null
                        ? Text('No data')
                        : Row(
                            children: [
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : record.list[0].getT6!.time.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.list[0].getT6?.time.hour == null
                                    ? 'null'
                                    : ':${record.list[0].getT6!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
