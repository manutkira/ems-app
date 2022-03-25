import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/attendance_edit.dart';
import 'package:ems/screens/attendances_api/view_attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';

// ignore: must_be_immutable
class AttendanceInfoAttendanceList extends ConsumerWidget {
  final bool multiday;
  final bool isOneDay;
  final bool alltime;
  final bool now;
  List<AttendancesByDate> attendanceList;
  List<AttendancesByDate> onedayList;
  List attendanceListAll;
  List<AttendancesByDate> attendancesByIdDisplay;
  List<AttendancesByDate> attendanceAll;

  final Function fetchAttedancesById;
  final Function fetchAllAttendance;
  final Function deleteData;
  Function fetchAttendanceCountAll;
  Function fetchAttendanceCount;

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
    required this.fetchAttendanceCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAdmin = ref.read(currentUserProvider).isAdmin;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return isOneDay && onedayList.isEmpty
        ? Column(
            children: [
              Text(
                local!.noAttendance,
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
              return multiday ? fetchAttedancesById() : fetchAllAttendance();
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
                late AttendancesByDate all;
                late AttendancesByDate todayAttendance;
                late AttendancesByDate onedayAttendance;
                late AttendancesByDate multidayAttendance;
                if (alltime) {
                  AttendancesByDate allRecord = attendanceAll[index];
                  all = allRecord;
                }
                if (now) {
                  AttendancesByDate nowRecord = attendanceList[index];
                  todayAttendance = nowRecord;
                }
                if (isOneDay) {
                  AttendancesByDate oneday = onedayList[index];
                  onedayAttendance = oneday;
                }
                if (multiday) {
                  AttendancesByDate multiday = attendanceList[index];

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

  checkPresent(AttendancesByDate element) {
    if (element.attendances?[0].t1?.note != 'absent' &&
        element.attendances?[0].t1?.note != 'permission') {
      if (element.attendances?[0].t1!.time!.hour == 7) {
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
    if (element.attendances?[0].t1!.note != 'absent' &&
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
    if (element.attendances?[0].t3!.note != 'absent') {
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
    if (element.attendances?[0].t2!.note == 'absent') {
      return true;
    } else {
      return false;
    }
  }

  popUp1(AttendancesByDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.attendances?[0].t1!.id as int;
          final DateTime date = record.attendances![0].date!;
          final String? note = record.attendances?[0].t1!.note;
          final TimeOfDay time = record.attendances![0].t1!.time!;
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
          fetchAttendanceCount();
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
                    deleteData(record.attendances?[0].t1!.id);
                  },
                  child: Text('${local?.yes}'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                // ignore: deprecated_member_use
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: Text('${local?.no}'),
                )
              ],
            ),
          );
        }
        if (selectedValue == 2) {
          final int id = record.attendances![0].t1!.id!;
          final DateTime date = record.attendances![0].date!;
          final TimeOfDay time = record.attendances![0].t1!.time!;
          final String? note = record.attendances![0].t1!.note;
          final String userName = record.attendances![0].user!.name.toString();
          final String image = record.attendances![0].user!.image.toString();
          final int userId = record.attendances![0].user!.id!;
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

  popUp2(AttendancesByDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);

    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.attendances![0].t2!.id!;
          final DateTime date = record.attendances![0].date!;
          final String? note = record.attendances?[0].t2!.note;
          final TimeOfDay time = record.attendances![0].t2!.time!;
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
          fetchAttendanceCount();
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
                    deleteData(record.attendances?[0].t2!.id);
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
          final int id = record.attendances![0].id!;
          final DateTime date = record.attendances![0].date!;
          final TimeOfDay time = record.attendances![0].t2!.time!;
          final String? note = record.attendances![0].t2!.note!;
          final String userName = record.attendances![0].user!.name.toString();
          final String image = record.attendances![0].user!.image.toString();
          final int userId = record.attendances![0].user!.id!;
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

  popUp3(AttendancesByDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.attendances![0].t3!.id!;
          final DateTime date = record.attendances![0].date!;
          final String? note = record.attendances![0].t3!.note;
          final TimeOfDay time = record.attendances![0].t3!.time!;
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
          fetchAttendanceCount();
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
                    deleteData(record.attendances?[0].t3!.id);
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
          final int id = record.attendances![0].t3!.id!;
          final DateTime date = record.attendances![0].date!;
          final TimeOfDay time = record.attendances![0].t3!.time!;
          final String? note = record.attendances![0].t3!.note;
          final String userName = record.attendances![0].user!.name.toString();
          final String image = record.attendances![0].user!.image.toString();
          final int userId = record.attendances![0].user!.id!;
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

  popUp4(AttendancesByDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    return PopupMenuButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          final int id = record.attendances![0].t4!.id!;
          final DateTime date = record.attendances![0].date!;
          final String? note = record.attendances![0].t4!.note;
          final TimeOfDay time = record.attendances![0].t4!.time!;
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
          fetchAttendanceCount();
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
                    deleteData(record.attendances![0].t4!.id);
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
          final int id = record.attendances![0].t4!.id!;
          final DateTime date = record.attendances![0].date!;
          final TimeOfDay time = record.attendances![0].t4!.time!;
          final String? note = record.attendances![0].t4!.note;
          final String userName = record.attendances![0].user!.name.toString();
          final String image = record.attendances![0].user!.image.toString();
          final int userId = record.attendances![0].user!.id!;
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
      AttendancesByDate record, BuildContext context, bool isAdmin) {
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
                    record.attendances?[0].t1 == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances?[0].t1?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t1!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances?[0].t1?.time!.minute == null
                                    ? 'null'
                                    : ':${record.attendances?[0].t1!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances?[0].t1 == null
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
                    record.attendances?[0].t2 == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances?[0].t2?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t2!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances?[0].t2?.time!.minute == null
                                    ? 'null'
                                    : ':${record.attendances?[0].t2!.time!.minute.toString().padLeft(2, '0')}',
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
                    record.attendances?[0].t3 == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances?[0].t3?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t3!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances?[0].t3?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances?[0].t3!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances?[0].t3?.time == null
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
                    record.attendances?[0].t4 == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances?[0].t4?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t4!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances?[0].t4?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances?[0].t4!.time!.minute.toString().padLeft(2, '0')}',
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
      AttendancesByDate record, BuildContext context, bool isAdmin) {
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
                    record.attendances?[0].t1?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t1?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t1!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t1?.time!.minute == null
                                    ? 'null'
                                    : ':${record.attendances![0].t1!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t1?.time == null
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
                    record.attendances![0].t2?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t2!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t2!.time!.minute.toString().padLeft(2, '0')}',
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
                    record.attendances![0].t3?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t3!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t3!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t3?.time! == null
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
                    record.attendances![0].t4?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t4!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t4!.time!.minute.toString().padLeft(2, '0')}',
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
      AttendancesByDate record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    // bool isEnglish = isInEnglish(context);

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
                    record.attendances![0].t1?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t1?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t1!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t1?.time!.minute == null
                                    ? 'null'
                                    : ':${record.attendances![0].t1!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t1?.time! == null
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
                    record.attendances![0].t2?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t2!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t2!.time!.minute.toString().padLeft(2, '0')}',
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
                    record.attendances![0].t3?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t3!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t3!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t3?.time! == null
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
                    record.attendances![0].t4?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t4!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t4!.time!.minute.toString().padLeft(2, '0')}',
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
      AttendancesByDate record, BuildContext context, bool isAdmin) {
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
                    record.attendances?[0].t1?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances?[0].t1?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t1!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t1?.time!.minute == null
                                    ? 'null'
                                    : ':${record.attendances![0].t1!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t1?.time == null
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
                    record.attendances![0].t2?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t2!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t2?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t2!.time!.minute.toString().padLeft(2, '0')}',
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
                    record.attendances![0].t3?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t3!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t3?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t3!.time!.minute.toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(record.attendances![0].t3?.time! == null
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
                    record.attendances![0].t4?.time!.hour == null
                        ? Text(local.noData)
                        : Row(
                            children: [
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : record.attendances![0].t4!.time!.hour
                                        .toString()
                                        .padLeft(2, '0'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                record.attendances![0].t4?.time!.hour == null
                                    ? 'null'
                                    : ':${record.attendances![0].t4!.time!.minute.toString().padLeft(2, '0')}',
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
