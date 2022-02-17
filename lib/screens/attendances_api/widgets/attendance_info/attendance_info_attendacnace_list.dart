import 'package:ems/persistence/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ems/models/attendances.dart';
import 'package:ems/screens/attendances_api/attendance_edit.dart';
import 'package:ems/screens/attendances_api/view_attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';

class AttendanceInfoAttendanceList extends ConsumerWidget {
  final bool multiday;
  final bool isOneDay;
  final bool alltime;
  final bool now;
  List<AttendancesWithDate> attendanceList;
  List<AttendancesWithDate> onedayList;
  List attendanceListAll;
  List<AttendancesWithDate> attendancesByIdDisplay;
  List<AttendancesWithDate> attendanceAll;

  final Function fetchAttedancesById;
  final Function fetchAllAttendance;
  final Function deleteData;
  final Function fetchAttendanceCountAll;
  final Function fetchPresentMorning;
  final Function fetchPresentMorningOneday;
  final Function fetchPresentAfternoonOneday;
  final Function fetchLateAfternoonOneday;
  final Function fetchLateMorningOneday;
  final Function fetchLateMorning;
  final Function fetchPresentAfternoon;
  final Function fetchLateAfternoon;

  AttendanceInfoAttendanceList({
    Key? key,
    required this.multiday,
    required this.isOneDay,
    required this.alltime,
    required this.now,
    required this.attendanceList,
    required this.onedayList,
    required this.attendanceListAll,
    required this.attendancesByIdDisplay,
    required this.attendanceAll,
    required this.fetchAttedancesById,
    required this.fetchAllAttendance,
    required this.deleteData,
    required this.fetchAttendanceCountAll,
    required this.fetchPresentMorning,
    required this.fetchPresentMorningOneday,
    required this.fetchPresentAfternoonOneday,
    required this.fetchLateAfternoonOneday,
    required this.fetchLateMorningOneday,
    required this.fetchLateMorning,
    required this.fetchPresentAfternoon,
    required this.fetchLateAfternoon,
  }) : super(key: key);

  _onrefresh() {
    fetchAttedancesById();
    fetchAllAttendance();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAdmin = ref.read(currentUserProvider).isAdmin;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return isOneDay && onedayList.isEmpty
        ? Column(
            children: [
              Text(
                '${local!.noAttendance}',
                style: kHeadingThree.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: isEnglish ? 30 : 0,
              ),
              const Text(
                '🤷🏼',
                style: TextStyle(
                  fontSize: 60,
                ),
              )
            ],
          )
        : RefreshIndicator(
            onRefresh: () {
              return fetchAttedancesById();
            },
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            displacement: 3 + 0,
            color: kWhite,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
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
                  AttendancesWithDate allRecord = attendanceAll[index];
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
                    ? _buildMultipleResult(multidayAttendance, context, isAdmin)
                    : isOneDay
                        ? _buildOnedayResult(onedayAttendance, context, isAdmin)
                        : alltime
                            ? _buildAllResult(all, context, isAdmin)
                            : _buildNowResult(
                                todayAttendance, context, isAdmin);
              },
            ),
          );
  }

  checkPresent(AttendancesWithDate element) {
    if (element.list[0].getT1?.note != 'absent' &&
        element.list[0].getT1?.note != 'permission') {
      if (element.list[0].getT1!.time.hour == 7) {
        if (element.list[0].getT1!.time.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT1!.time.hour < 7) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkPresengetT2(AttendancesWithDate element) {
    if (element.list[0].getT3?.note != 'absent' &&
        element.list[0].getT3?.note != 'permission') {
      if (element.list[0].getT3!.time.hour == 13) {
        if (element.list[0].getT3!.time.minute <= 15) {
          return true;
        } else {
          return false;
        }
      } else if (element.list[0].getT3!.time.hour < 13) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  checkLate1(AttendancesWithDate element) {
    if (element.list[0].getT1!.note != 'absent' &&
        element.list[0].getT1?.note != 'permission') {
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

  popUp1(AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.list[0].getT1!.id as int;
          final DateTime date = record.list[0].date as DateTime;
          final String? note = record.list[0].getT1!.note;
          final TimeOfDay time = record.list[0].getT1!.time;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AttedancesEdit(
                id: id,
                date: date,
                note: note,
                time: time,
              ),
            ),
          );
          fetchAttedancesById();
          fetchAllAttendance();
          fetchAttendanceCountAll();
          fetchPresentMorning();
          fetchPresentMorningOneday();
          fetchPresentAfternoonOneday();
          fetchLateAfternoonOneday();
          fetchLateMorningOneday();
          fetchLateMorning();
          fetchPresentAfternoon();
          fetchLateAfternoon();
        }
        if (selectedValue == 1) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('${local?.areYouSure}'),
              content: Text('${local?.cannotUndone}'),
              actions: [
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteData(record.list[0].getT1!.id);
                  },
                  child: Text('Yes'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: const Text('No'),
                )
              ],
            ),
          );
        }
        if (selectedValue == 2) {
          final int attendanceId = record.list[0].id;
          final int id = record.list[0].getT1!.id;
          final DateTime date = record.list[0].date;
          final TimeOfDay time = record.list[0].getT1!.time;
          final String? note = record.list[0].getT1!.note;
          final String userName = record.list[0].user!.name.toString();
          final String image = record.list[0].user!.image.toString();
          final int userId = record.list[0].user!.id!;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ViewAttendanceScreen(
                userId: userId,
                id: id,
                date: date,
                note: note,
                userName: userName,
                image: image,
                time: time,
              ),
            ),
          );
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('${local?.optionView}',
              style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
          value: 2,
        ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.edit}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 0,
          ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.delete}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 1,
          ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  popUp2(AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);

    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.list[0].getT2!.id;
          final DateTime date = record.list[0].date;
          final String? note = record.list[0].getT2!.note;
          final TimeOfDay time = record.list[0].getT2!.time;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AttedancesEdit(
                id: id,
                date: date,
                note: note,
                time: time,
              ),
            ),
          );
          fetchAttedancesById();
          fetchAllAttendance();
          fetchAttendanceCountAll();
          fetchPresentMorning();
          fetchPresentMorningOneday();
          fetchPresentAfternoonOneday();
          fetchLateAfternoonOneday();
          fetchLateMorningOneday();
          fetchLateMorning();
          fetchPresentAfternoon();
          fetchLateAfternoon();
        }
        if (selectedValue == 1) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('${local?.areYouSure}'),
              content: Text('${local?.cannotUndone}'),
              actions: [
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteData(record.list[0].getT2!.id);
                  },
                  child: const Text('Yes'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: const Text('No'),
                )
              ],
            ),
          );
        }
        if (selectedValue == 2) {
          final int id = record.list[0].id;
          final DateTime date = record.list[0].date;
          final TimeOfDay time = record.list[0].getT2!.time;
          final String? note = record.list[0].getT2!.note;
          final String userName = record.list[0].user!.name.toString();
          final String image = record.list[0].user!.image.toString();
          final int userId = record.list[0].user!.id!;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ViewAttendanceScreen(
                userId: userId,
                id: id,
                date: date,
                note: note,
                userName: userName,
                image: image,
                time: time,
              ),
            ),
          );
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('${local?.optionView}',
              style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
          value: 2,
        ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.edit}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 0,
          ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.delete}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 1,
          ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  popUp3(AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.list[0].getT3!.id;
          final DateTime date = record.list[0].date;
          final String? note = record.list[0].getT3!.note;
          final TimeOfDay time = record.list[0].getT3!.time;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AttedancesEdit(
                id: id,
                date: date,
                note: note,
                time: time,
              ),
            ),
          );
          fetchAttedancesById();
          fetchAllAttendance();
          fetchAttendanceCountAll();
          fetchPresentMorning();
          fetchPresentMorningOneday();
          fetchPresentAfternoonOneday();
          fetchLateAfternoonOneday();
          fetchLateMorningOneday();
          fetchLateMorning();
          fetchPresentAfternoon();
          fetchLateAfternoon();
        }
        if (selectedValue == 1) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('${local?.areYouSure}'),
              content: Text('${local?.cannotUndone}'),
              actions: [
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteData(record.list[0].getT3!.id);
                  },
                  child: const Text('Yes'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: const Text('No'),
                )
              ],
            ),
          );
        }
        if (selectedValue == 2) {
          final int id = record.list[0].getT3!.id;
          final DateTime date = record.list[0].date;
          final TimeOfDay time = record.list[0].getT3!.time;
          final String? note = record.list[0].getT3!.note;
          final String userName = record.list[0].user!.name.toString();
          final String image = record.list[0].user!.image.toString();
          final int userId = record.list[0].user!.id!;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ViewAttendanceScreen(
                userId: userId,
                id: id,
                date: date,
                note: note,
                userName: userName,
                image: image,
                time: time,
              ),
            ),
          );
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('${local?.optionView}',
              style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
          value: 2,
        ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.edit}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 0,
          ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.delete}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 1,
          ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  popUp4(AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.list[0].getT4!.id;
          final DateTime date = record.list[0].date;
          final String? note = record.list[0].getT4!.note;
          final TimeOfDay time = record.list[0].getT4!.time;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AttedancesEdit(
                id: id,
                date: date,
                note: note,
                time: time,
              ),
            ),
          );
          fetchAttedancesById();
          fetchAllAttendance();
          fetchAttendanceCountAll();
          fetchPresentMorning();
          fetchPresentMorningOneday();
          fetchPresentAfternoonOneday();
          fetchLateAfternoonOneday();
          fetchLateMorningOneday();
          fetchLateMorning();
          fetchPresentAfternoon();
          fetchLateAfternoon();
        }
        if (selectedValue == 1) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('${local?.areYouSure}'),
              content: Text('${local?.cannotUndone}'),
              actions: [
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteData(record.list[0].getT4!.id);
                  },
                  child: const Text('Yes'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: const Text('No'),
                )
              ],
            ),
          );
        }
        if (selectedValue == 2) {
          final int id = record.list[0].getT3!.id;
          final DateTime date = record.list[0].date;
          final TimeOfDay time = record.list[0].getT4!.time;
          final String? note = record.list[0].getT4!.note;
          final String userName = record.list[0].user!.name.toString();
          final String image = record.list[0].user!.image.toString();
          final int userId = record.list[0].user!.id!;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ViewAttendanceScreen(
                userId: userId,
                id: id,
                date: date,
                note: note,
                userName: userName,
                image: image,
                time: time,
              ),
            ),
          );
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('${local?.optionView}',
              style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
          value: 2,
        ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.edit}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 0,
          ),
        if (isAdmin)
          PopupMenuItem(
            child: Text('${local?.delete}',
                style: kParagraph.copyWith(fontWeight: FontWeight.bold)),
            value: 1,
          ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  Widget _buildAllResult(
      AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);

    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: const Color(0xff254973),
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
                    Text('1- ${local!.checkIn}'),
                    record.list[0].getT1 == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1 == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( ${local.present} )'
                                      : checkLate1(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT1(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp1(record, context, isAdmin)
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
                    Text('1- ${local.checkOut}'),
                    record.list[0].getT2 == null
                        ? Text('${local.noData}')
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
                                record.list[0].getT2?.time.minute == null
                                    ? 'null'
                                    : ':${record.list[0].getT2!.time.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              popUp2(record, context, isAdmin)
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
                    Text('2- ${local.checkIn}'),
                    record.list[0].getT3 == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( ${local.present} )'
                                      : checkLate2(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT2(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp3(record, context, isAdmin)
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
                    Text('2- ${local.checkOut}'),
                    record.list[0].getT4 == null
                        ? Text('${local.noData}')
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
                              popUp4(record, context, isAdmin)
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

  Widget _buildNowResult(
      AttendancesWithDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);

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
                    Text('1- ${local!.checkIn}'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( ${local.present} )'
                                      : checkLate1(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT1(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp1(record, context, isAdmin)
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
                    Text('1- ${local.checkOut}'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp2(record, context, isAdmin)
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
                    Text('2- ${local.checkIn}'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( ${local.present} )'
                                      : checkLate2(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT2(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp3(record, context, isAdmin)
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
                    Text('2- ${local.checkOut}'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp4(record, context, isAdmin)
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

  Widget _buildOnedayResult(
      AttendancesWithDate record, BuildContext context, bool isAdmin) {
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
                    Text('1- ${local!.checkIn}'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('${local.noData}')
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
                                      ? '( ${local.present} )'
                                      : checkLate1(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT1(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp1(record, context, isAdmin)
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
                    Text('1- ${local.checkOut}'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp2(record, context, isAdmin)
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
                    Text('2- ${local.checkIn}'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('${local.noData}')
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
                                      ? '( ${local.present} )'
                                      : checkLate2(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT2(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp3(record, context, isAdmin)
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
                    Text('2- ${local.checkOut}'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp4(record, context, isAdmin)
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

  Widget _buildMultipleResult(
      AttendancesWithDate record, context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);

    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
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
                    Text('1- ${local!.checkIn}'),
                    record.list[0].getT1?.time.hour == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT1?.time == null
                                  ? 'null'
                                  : checkPresent(record)
                                      ? '( ${local.present} )'
                                      : checkLate1(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT1(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp1(record, context, isAdmin)
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
                    Text('1- ${local.checkOut}'),
                    record.list[0].getT2?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp2(record, context, isAdmin)
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
                    Text('2- ${local.checkIn}'),
                    record.list[0].getT3?.time.hour == null
                        ? Text('${local.noData}')
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.list[0].getT3?.time == null
                                  ? 'null'
                                  : checkPresengetT2(record)
                                      ? '( ${local.present} )'
                                      : checkLate2(record)
                                          ? '( ${local.late} )'
                                          : checkAbsengetT2(record)
                                              ? '( ${local.absent} )'
                                              : '( ${local.permission} )'),
                              popUp3(record, context, isAdmin)
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
                    Text('2- ${local.checkOut}'),
                    record.list[0].getT4?.time.hour == null
                        ? Text('${local.noData}')
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
                              popUp4(record, context, isAdmin)
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
