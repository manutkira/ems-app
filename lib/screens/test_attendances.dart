import 'package:ems/models/attendances.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/utils.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

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
  List isToday = [];
  List onedayList = [];
  String sortByValue = '';
  List<String> dropdownItems = [];

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
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    setState(() {
      // if (dropDownValue.isEmpty) {
      //   dropDownValue = local!.morning;
      // }
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
                    AttendancesWithDate nowRecord = attendanceList[index];
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
    if (element.list[0].getT1!.time.hour <= 7) {
      if (element.list[0].getT1!.time.minute <= 15) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesWithDate element) {
    if (element.list[0].getT3!.time.hour <= 7) {
      if (element.list[0].getT3!.time.minute <= 15) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesWithDate element) {
    if (element.list[0].getT1!.note != 'absent') {
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
    if (element.list[0].getT3!.note != 'absent') {
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
    if (element.list[0].getT2!.note == 'absent') {
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
