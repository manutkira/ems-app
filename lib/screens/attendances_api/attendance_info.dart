import 'package:ems/models/attendance_count.dart';
import 'package:ems/services/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:ems/models/attendances.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/calendar_attendance.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_attendacnace_list.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_no_attendance.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_no_data.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_present.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';
import '../../services/attendance.dart' as service_new;
import '../../services/models/attendance_count.dart' as model_count;
import '../../services/models/attendance.dart' as model_new;

class AttendancesInfoScreen extends ConsumerStatefulWidget {
  static const routeName = '/attendances-info';
  final int id;
  const AttendancesInfoScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AttendancesInfoScreenState();
}

class _AttendancesInfoScreenState extends ConsumerState<AttendancesInfoScreen> {
  // services
  final service_new.AttendanceService _attendanceService =
      service_new.AttendanceService();
  final UserService _userService = UserService.instance;

  // list attendance
  List<model_new.Attendance> attendanceDisplay = [];
  List<model_new.Attendance> attendanceAllDisplay = [];

  // list attendances with date
  List<model_new.Attendance> attendancesDisplay = [];
  List<AttendancesByDate> _attendanceNoDateDisplay = [];
  List<AttendancesByDate> attendancesByIdDisplay = [];
  List<AttendancesByDate> attendanceList = [];
  List<AttendancesByDate> _attendanceAll = [];
  List<AttendancesByDate> onedayList = [];

  // list user
  List<User> userDisplay = [];
  List<User> user = [];

  // list dynamic
  List<model_new.Attendance> attendanceListAll = [];
  List isToday = [];
  List<String> dropdownItems = [];
  List isTodayNoon = [];
  List oneDayMorning = [];
  List oneDayNoon = [];
  List attendanceListNoon = [];

  // attendance count
  model_count.AttendanceCount? attendanceCount;
  model_count.AttendanceCount? attendanceCountAll;

  // boolean
  bool now = true;
  bool alltime = false;
  bool isOneDay = false;
  bool multiday = false;
  bool isFilterExpanded = false;
  bool afternoon = false;
  bool total = false;
  bool _loadingUser = true;
  bool _isLoadingAll = true;
  bool _isLoadingById = true;
  bool multipleDay = false;
  bool order = false;
  final bool _isLoading = true;
  bool _isLoadingCount = true;
  bool _isLoadingCountAll = true;

  // datetime
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // variables
  String sortByValue = '';
  String dropDownValue = '';
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
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
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

  // fetch attendance count from api
  fetchAttendanceCount() async {
    try {
      _isLoadingCount = true;
      model_count.AttendanceCount attendanceCountDisplay =
          await _attendanceService.countAttendance(
        widget.id,
        start: startDate,
        end: !isOneDay ? endDate : startDate,
      );
      if (mounted) {
        setState(() {
          attendanceCount = attendanceCountDisplay;
          _isLoadingCount = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  fetchAttendanceCountAll() async {
    try {
      _isLoadingCountAll = true;
      model_count.AttendanceCount attendanceCountDisplay =
          await _attendanceService.countAttendance(
        widget.id,
      );
      if (mounted) {
        setState(() {
          attendanceCountAll = attendanceCountDisplay;
          print('attendanceCountAll: ${attendanceCountAll}');
          _isLoadingCountAll = false;
        });
      }
    } catch (err) {}
  }

  fetchUserById() async {
    try {
      _loadingUser = true;
      _userService.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            _loadingUser = true;
            user = [];
            userDisplay = [];
            user.add(usersFromServer);
            userDisplay = user;
            _loadingUser = false;
          });
        }
      });
    } catch (err) {}
  }

  // fetch attendance from api
  fetchAllAttendance() async {
    _isLoadingAll = true;
    try {
      List<AttendancesByDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(widget.id);
      setState(() {
        _attendanceAll = attendanceDisplay;
        _isLoadingAll = false;
      });
      List<model_new.Attendance> flat = _attendanceAll
          .expand((element) => element.attendances!)
          .toList() as List<model_new.Attendance>;
      attendanceListAll = flat.toList();

      int absentAllMorning = attendanceDisplay
          .where((element) =>
              element.attendances![0].t1 != null && checkAbsengetT1(element))
          .length;
      int absentAllAfternoon = attendanceDisplay
          .where((element) =>
              element.attendances?[0].t3 != null && checkAbsengetT2(element))
          .length;
      int permissionAllMorning = attendanceDisplay
          .where((element) =>
              element.attendances?[0].t1 != null &&
              checkPermissiongetT1(element))
          .length;
      int permissionAllAfternoon = attendanceDisplay
          .where((element) =>
              element.attendances?[0].t3 != null &&
              checkPermissiongetT2(element))
          .length;
      absentAll = absentAllMorning + absentAllAfternoon;
      permissionAll = permissionAllMorning + permissionAllAfternoon;
    } catch (e) {}
  }

  fetchAttedancesById() async {
    _isLoadingById = true;
    try {
      List<AttendancesByDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(
        widget.id,
        start: startDate,
        end: endDate,
      );
      setState(() {
        attendancesByIdDisplay = attendanceDisplay;
        _isLoadingById = false;

        absentMorning = attendanceDisplay
            .where((element) =>
                element.attendances?[0].t1 != null && checkAbsengetT1(element))
            .length;
        absentAfternoon = attendanceDisplay
            .where((element) =>
                element.attendances?[0].t3 != null && checkAbsengetT2(element))
            .length;

        permissionMorning = attendanceDisplay
            .where((element) =>
                element.attendances?[0].t1 != null &&
                checkPermissiongetT1(element))
            .length;
        permissionAfternoon = attendanceDisplay
            .where((element) =>
                element.attendances?[0].t3 != null &&
                checkPermissiongetT2(element))
            .length;
        var now = DateTime.now();
        var today = attendancesByIdDisplay.where((element) =>
            element.date?.day == now.day &&
            element.date?.month == now.month &&
            element.date?.year == now.year);

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
            element.date?.day == startDate.day &&
            element.date?.month == startDate.month &&
            element.date?.year == startDate.year);
        onedayList = oneDay.toList();
        onedayAbsent = oneDay
            .where((element) =>
                element.attendances?[0].t1 != null && checkAbsengetT1(element))
            .length;
        onedayAbsentNoon = oneDay
            .where((element) =>
                element.attendances?[0].t3 != null && checkAbsengetT2(element))
            .length;
        onedayPermission = oneDay
            .where((element) =>
                element.attendances?[0].t1 != null &&
                checkPermissiongetT1(element))
            .length;
        onedayPermissionNoon = oneDay
            .where((element) =>
                element.attendances?[0].t3 != null &&
                checkPermissiongetT2(element))
            .length;
        attendanceList = attendancesByIdDisplay;
      });
    } catch (err) {}
  }

  // check attendance status
  checkPresent(AttendancesByDate element) {
    if (element.attendances?[0].t1?.note != 'absent' &&
        element.attendances?[0].t1?.note != 'permission') {
      if (element.attendances?[0].t1!.time?.hour == 7) {
        if (element.attendances![0].t1!.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t1!.time!.hour < 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesByDate element) {
    if (element.attendances?[0].t3?.note != 'absent' &&
        element.attendances?[0].t3?.note != 'permission') {
      if (element.attendances?[0].t3!.time!.hour == 13) {
        if (element.attendances![0].t3!.time!.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t3!.time!.hour < 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesByDate element) {
    if (element.attendances?[0].t1?.note != 'absent' &&
        element.attendances?[0].t1?.note != 'permission') {
      if (element.attendances?[0].t1!.time!.hour == 7) {
        if (element.attendances![0].t1!.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t1!.time!.hour > 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate2(AttendancesByDate element) {
    if (element.attendances?[0].t3?.note != 'absent' &&
        element.attendances?[0].t3?.note != 'permission') {
      if (element.attendances?[0].t3!.time!.hour == 13) {
        if (element.attendances![0].t3!.time!.minute >= 16) {
          return true;
        } else {
          return false;
        }
      } else if (element.attendances![0].t3!.time!.hour > 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkAbsengetT1(AttendancesByDate element) {
    if (element.attendances?[0].t1!.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkAbsengetT2(AttendancesByDate element) {
    if (element.attendances?[0].t3!.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT1(AttendancesByDate element) {
    if (element.attendances?[0].t1!.note == 'permission') {
      return true;
    } else {
      return false;
    }
  }

  checkPermissiongetT2(AttendancesByDate element) {
    if (element.attendances?[0].t3!.note == 'permission') {
      return true;
    } else {
      return false;
    }
  }

  String url =
      "http://rest-api-laravel-flutter.herokuapp.com/api/attendance_record";

  Future deleteData(int id) async {
    AppLocalizations? local = AppLocalizations.of(context);
    final response = await http.delete(Uri.parse("$url/$id"));
    print(response.statusCode);
    showInSnackBar("${local?.deletingAttendance}");
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      attendanceList = [];
      _attendanceAll = [];
      onedayList = [];
      fetchAttendanceCount();
      fetchAttendanceCountAll();
      fetchAttedancesById();
      fetchAllAttendance();
      showInSnackBar("${local?.deletedAttendance}");
    } else {
      return false;
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2000),
        backgroundColor: kBlueBackground,
        content: Text(
          value,
          style: kHeadingFour.copyWith(color: Colors.black),
        ),
      ),
    );
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
      fetchAttendanceCountAll();
      fetchAttendanceCount();
      fetchAttedancesById();
      fetchAllAttendance();
      fetchUserById();
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
        actions: [
          !_loadingUser
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AttendanceCalendar(id: userDisplay[0].id!)));
                  },
                  icon: Icon(Icons.calendar_today))
              : Text(''),
        ],
      ),
      body: _isLoadingCount || _loadingUser || _isLoadingCountAll
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
                    Image.asset(
                      'assets/images/Gear-0.5s-200px.gif',
                      width: 60,
                    )
                  ],
                ),
              ),
            )
          :
          // _isLoadingNoDate
          //     ? Container(
          //         padding: const EdgeInsets.only(top: 320),
          //         alignment: Alignment.center,
          //         child: Center(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Text('${local?.fetchData}'),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Image.asset(
          //                 'assets/images/Gear-0.5s-200px.gif',
          //                 width: 60,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     :
          // _attendanceNoDateDisplay.isEmpty
          //     ? const AttendanceInfoNoAttenance()
          //     :
          Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.dateRange}',
                                        style: kParagraph),
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
                                        borderRadius: const BorderRadius.all(
                                            kBorderRadius),
                                        dropdownColor: kDarkestBlue,
                                        underline: Container(),
                                        style: kParagraph.copyWith(
                                            fontWeight: FontWeight.bold),
                                        isDense: true,
                                        value: sortByValue,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items:
                                            dropdownItems.map((String items) {
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
                                  visible:
                                      sortByValue != '${local?.optionAllTime}',
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
                                              getDateStringFromDateTime(
                                                  startDate),
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
                                          if (picked != null &&
                                              picked != endDate) {
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
                                              getDateStringFromDateTime(
                                                  endDate),
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
                                          fetchAllAttendance();
                                          fetchAttendanceCountAll();
                                          fetchAttendanceCount();
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
                                          fetchAttendanceCount();
                                        }
                                        if (sortByValue ==
                                            '${local?.optionDay}') {
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
                                          fetchAllAttendance();
                                          fetchAttendanceCount();
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
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: kDarkestBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      AttendanceInfoNameId(
                          name: userDisplay[0].name.toString(),
                          id: userDisplay[0].id.toString(),
                          image: userDisplay[0].image.toString()),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AttendanceInfoPresent(
                            total: total,
                            isLoadingAll: _isLoadingAll,
                            isLoadingById: _isLoadingById,
                            numColor: kGreenText,
                            backgroundColor: kGreenBackground,
                            now: now,
                            todayMorning:
                                attendanceCount!.morningPresent.toString(),
                            todayAfternoon:
                                attendanceCount!.afternoonPresent.toString(),
                            isLoading: _isLoading,
                            isOneday: isOneDay,
                            onedayMorning:
                                attendanceCount!.morningPresent.toString(),
                            onedayAfternoon:
                                attendanceCount!.afternoonPresent.toString(),
                            presentAll:
                                attendanceCountAll!.totalPresent.toString(),
                            alltime: alltime,
                            text: '${local?.present} ',
                            afternoon: afternoon,
                            multipleDay: multiday,
                            presentAfternoon:
                                attendanceCount!.afternoonPresent.toString(),
                            presentMorning:
                                attendanceCount!.morningPresent.toString(),
                          ),
                          AttendanceInfoPresent(
                            total: total,
                            isLoadingAll: _isLoadingAll,
                            isLoadingById: _isLoadingById,
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
                            total: total,
                            isLoadingAll: _isLoadingAll,
                            isLoadingById: _isLoadingById,
                            numColor: kYellowText,
                            backgroundColor: kYellowBackground,
                            now: now,
                            todayMorning:
                                attendanceCount!.morningLate.toString(),
                            todayAfternoon:
                                attendanceCount!.afternoonLate.toString(),
                            isLoading: _isLoading,
                            isOneday: isOneDay,
                            onedayMorning:
                                attendanceCount!.morningLate.toString(),
                            onedayAfternoon:
                                attendanceCount!.afternoonLate.toString(),
                            presentAll:
                                attendanceCountAll!.totalLate.toString(),
                            alltime: alltime,
                            text: '${local?.late} ',
                            afternoon: afternoon,
                            multipleDay: multiday,
                            presentAfternoon:
                                attendanceCount!.afternoonLate.toString(),
                            presentMorning:
                                attendanceCount!.morningLate.toString(),
                          ),
                          AttendanceInfoPresent(
                            total: total,
                            isLoadingAll: _isLoadingAll,
                            isLoadingById: _isLoadingById,
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
                            presentMorning: absentMorning == null
                                ? '♽'
                                : absentMorning.toString(),
                          )
                        ],
                      ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: const BorderRadius.all(
                                            kBorderRadius),
                                        dropdownColor: kDarkestBlue,
                                        icon: const Icon(Icons.expand_more),
                                        value: dropDownValue,
                                        onChanged: (String? newValue) {
                                          if (newValue ==
                                              '${local?.afternoon}') {
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
                                          '${local?.total}'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
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
                      (isToday.isEmpty && now && isTodayNoon.isEmpty) ||
                              (multiday && attendanceList.isEmpty)
                          ? AttendanceInfoNoData()
                          : _isLoading && _isLoadingAll || _isLoadingById
                              ? Container(
                                  padding: EdgeInsets.only(top: 150),
                                  child: Column(
                                    children: [
                                      Text('${local?.fetchData}'),
                                      const SizedBox(
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
                                    padding: const EdgeInsets.only(top: 15),
                                    child: AttendanceInfoAttendanceList(
                                      deleteData: deleteData,
                                      multiday: multiday,
                                      isOneDay: isOneDay,
                                      alltime: alltime,
                                      now: now,
                                      attendanceList: attendanceList,
                                      onedayList: onedayList,
                                      attendanceListAll: attendanceListAll,
                                      attendancesByIdDisplay:
                                          attendancesByIdDisplay,
                                      attendanceAll: _attendanceAll,
                                      fetchAttedancesById: fetchAttedancesById,
                                      fetchAllAttendance: fetchAllAttendance,
                                      fetchAttendanceCount:
                                          fetchAttendanceCount,
                                      fetchAttendanceCountAll:
                                          fetchAttendanceCountAll,
                                    ),
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
