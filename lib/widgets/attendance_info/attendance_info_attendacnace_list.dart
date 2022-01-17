import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:ems/models/attendance.dart';
import 'package:ems/screens/attendances_api/attendance_edit.dart';
import 'package:ems/screens/attendances_api/view_attendance.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/attendance_info/attendance_info_no_data.dart';

import '../../constants.dart';

class AttendanceInfoAttendanceList extends StatelessWidget {
  final bool now;
  final bool alltime;
  final bool afternoon;
  final bool multiple;
  final bool isOneDay;
  List oneDayMorning;
  final List<AttendanceWithDate> attendanceList;
  List attendanceAll;
  List attendanceAllDisplay;
  List<AttendanceWithDate> attendanceAllDis;
  final Function fetchAttendanceById;
  final Function deleteData;
  final Function deleteData1;
  final Function fetchAttendanceByIdNoon;
  final Function fetchAllAttendance;

  AttendanceInfoAttendanceList({
    Key? key,
    required this.now,
    required this.alltime,
    required this.afternoon,
    required this.multiple,
    required this.isOneDay,
    required this.oneDayMorning,
    required this.attendanceList,
    required this.attendanceAll,
    required this.attendanceAllDisplay,
    required this.attendanceAllDis,
    required this.fetchAttendanceById,
    required this.deleteData,
    required this.deleteData1,
    required this.fetchAttendanceByIdNoon,
    required this.fetchAllAttendance,
  }) : super(key: key);

  _onrefresh() {
    fetchAttendanceById();
    fetchAttendanceByIdNoon();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return isOneDay && oneDayMorning.isEmpty
        ? Column(
            children: [
              Text(
                '${local?.noAttendance}',
                style: kHeadingThree.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: isEnglish ? 30 : 0,
              ),
              Text(
                '🤷🏼',
                style: TextStyle(
                  fontSize: 60,
                ),
              )
            ],
          )
        : RefreshIndicator(
            onRefresh: () {
              return fetchAttendanceById();
            },
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            displacement: 3 + 0,
            color: kWhite,
            child: ListView.builder(
              itemBuilder: (context, index) {
                late AttendanceWithDate all;
                late AttendanceWithDate todayAttendance;
                late AttendanceWithDate onedayAttendance;
                late AttendanceWithDate multidayAttendance;
                if (alltime) {
                  AttendanceWithDate allRecord = attendanceAllDis[index];
                  all = allRecord;
                }
                if (now) {
                  AttendanceWithDate nowRecord = attendanceList[index];
                  todayAttendance = nowRecord;
                }
                if (isOneDay) {
                  AttendanceWithDate oneday = oneDayMorning[index];
                  onedayAttendance = oneday;
                }
                if (multiple) {
                  AttendanceWithDate multiday = attendanceList[index];
                  multidayAttendance = multiday;
                }

                return multiple
                    ? _buildMultidayResult(multidayAttendance)
                    : isOneDay
                        ? _buildOneDayResult(onedayAttendance, context)
                        : now
                            ? _buildNowResult(todayAttendance, context)
                            : _buildAllResult(all);
              },
              itemCount: multiple
                  ? attendanceList.length
                  : isOneDay
                      ? oneDayMorning.length
                      : now
                          ? attendanceList.length
                          : attendanceAllDis.length,
            ),
          );
  }

  Widget _buildMultidayResult(AttendanceWithDate record) {
    List recordMorning = record.list
        .where((element) =>
            element.code != 'cin2' &&
            element.code != 'cout2' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    List recordAfternoon = record.list
        .where((element) =>
            element.code != 'cin1' &&
            element.code != 'cout1' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(record.date),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              AppLocalizations? local = AppLocalizations.of(context);
              bool isEnglish = isInEnglish(context);
              return afternoon
                  ? recordAfternoon.isEmpty
                      ? Text('data')
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 8,
                          ),
                          color: index % 2 == 0 ? kDarkestBlue : kBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(recordAfternoon[index].date),
                              ),
                              Row(
                                children: [
                                  Text(
                                    recordAfternoon[index].type == 'checkin'
                                        ? '${local?.checkIn}'
                                        : recordAfternoon[index].type ==
                                                'checkout'
                                            ? '${local?.checkOut}'
                                            : recordAfternoon[index].type ==
                                                    'absent'
                                                ? '${local?.absent}'
                                                : recordAfternoon[index].type ==
                                                        'permission'
                                                    ? '${local?.permission}'
                                                    : recordAfternoon[index]
                                                        .type
                                                        .toString(),
                                  ),
                                  PopupMenuButton(
                                    color: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onSelected: (int selectedValue) async {
                                      if (afternoon == true) {
                                        if (selectedValue == 0) {
                                          final int userId =
                                              recordAfternoon[index].userId;
                                          final int id =
                                              recordAfternoon[index].id;
                                          final String type =
                                              recordAfternoon[index].type;
                                          final DateTime date =
                                              recordAfternoon[index].date;
                                          final String? note =
                                              recordAfternoon[index].note;
                                          final String code =
                                              recordAfternoon[index].code;
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) => AttedancesEdit(
                                                id: id,
                                                userId: userId,
                                                type: type,
                                                date: date,
                                                note: note,
                                                code: code,
                                              ),
                                            ),
                                          );
                                          fetchAttendanceById();
                                        }
                                        if (selectedValue == 1) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  Text('${local?.areYouSure}'),
                                              content: Text(
                                                  '${local?.cannotUndone}'),
                                              actions: [
                                                OutlineButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    deleteData1(
                                                        recordAfternoon[index]
                                                            .id as int);
                                                  },
                                                  child: Text('${local?.yes}'),
                                                  borderSide: BorderSide(
                                                      color: Colors.green),
                                                ),
                                                OutlineButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                  child: Text('${local?.no}'),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                        if (selectedValue == 2) {
                                          final int userId =
                                              recordAfternoon[index].userId;
                                          final int id =
                                              recordAfternoon[index].id;
                                          final String type =
                                              recordAfternoon[index].type;
                                          final DateTime date =
                                              recordAfternoon[index].date;
                                          final String? note =
                                              recordAfternoon[index].note;
                                          final String userName =
                                              recordAfternoon[index]
                                                  .users!
                                                  .name;
                                          final String image =
                                              recordAfternoon[index]
                                                  .users
                                                  .image;
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ViewAttendanceScreen(
                                                id: id,
                                                userId: userId,
                                                type: type,
                                                date: date,
                                                note: note,
                                                userName: userName,
                                                image: image,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                        child: Text(
                                          '${local?.optionView}',
                                          style: kParagraph.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 2,
                                      ),
                                      if (record.list[0].users!.role == 'admin')
                                        PopupMenuItem(
                                          child: Text(
                                            '${local?.edit}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 0,
                                        ),
                                      if (record.list[0].users!.role == 'admin')
                                        PopupMenuItem(
                                          child: Text(
                                            '${local?.delete}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 1,
                                        ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
                                  ),
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
                      color: index % 2 == 0 ? kDarkestBlue : kBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(recordMorning[index].date),
                          ),
                          Row(
                            children: [
                              Text(
                                recordMorning[index].type == 'checkin'
                                    ? '${local?.checkIn}'
                                    : recordMorning[index].type == 'checkout'
                                        ? '${local?.checkOut}'
                                        : recordMorning[index].type == 'absent'
                                            ? '${local?.absent}'
                                            : recordMorning[index].type ==
                                                    'permission'
                                                ? '${local?.permission}'
                                                : recordMorning[index]
                                                    .type
                                                    .toString(),
                              ),
                              PopupMenuButton(
                                color: Colors.black,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onSelected: (int selectedValue) async {
                                  if (afternoon == false) {
                                    if (selectedValue == 0) {
                                      final int userId =
                                          recordMorning[index].userId;
                                      final int id = recordMorning[index].id;
                                      final String type =
                                          recordMorning[index].type;
                                      final DateTime date =
                                          recordMorning[index].date;
                                      final String? note =
                                          recordMorning[index].note;
                                      final String code =
                                          recordMorning[index].code;
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => AttedancesEdit(
                                            id: id,
                                            userId: userId,
                                            type: type,
                                            date: date,
                                            note: note,
                                            code: code,
                                          ),
                                        ),
                                      );
                                      fetchAttendanceById();
                                    }
                                    if (selectedValue == 1) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('${local?.areYouSure}'),
                                          content:
                                              Text('${local?.cannotUndone}'),
                                          actions: [
                                            OutlineButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                deleteData(recordMorning[index]
                                                    .id as int);
                                              },
                                              child: Text('${local?.yes}'),
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            OutlineButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              child: Text('${local?.no}'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    if (selectedValue == 2) {
                                      final int userId =
                                          recordMorning[index].userId;
                                      final int id = recordMorning[index].id;
                                      final String type =
                                          recordMorning[index].type;
                                      final DateTime date =
                                          recordMorning[index].date;
                                      final String note =
                                          recordMorning[index].note;
                                      final String userName =
                                          recordMorning[index].users!.name;
                                      final String image =
                                          recordMorning[index].users.image;
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              ViewAttendanceScreen(
                                            id: id,
                                            userId: userId,
                                            type: type,
                                            date: date,
                                            note: note,
                                            userName: userName,
                                            image: image,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text(
                                      '${local?.optionView}',
                                      style: kParagraph.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: 2,
                                  ),
                                  if (record.list[0].users!.role == 'admin')
                                    PopupMenuItem(
                                      child: Text(
                                        '${local?.edit}',
                                        style: kParagraph.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 0,
                                    ),
                                  if (record.list[0].users!.role == 'admin')
                                    PopupMenuItem(
                                      child: Text(
                                        '${local?.delete}',
                                        style: kParagraph.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 1,
                                    ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
            itemCount:
                afternoon ? recordAfternoon.length : recordMorning.length)
      ],
    );
  }

  Widget _buildOneDayResult(AttendanceWithDate record, BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    List onedayMorning = record.list
        .where((element) =>
            element.code != 'cin2' &&
            element.code != 'cout2' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    List ondayAfternoon = record.list
        .where((element) =>
            element.code != 'cin1' &&
            element.code != 'cout1' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    return ondayAfternoon.isEmpty && afternoon
        ? Column(
            children: [
              Text(
                '${local?.noAttendance}',
                style: kHeadingThree.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: isEnglish ? 30 : 0,
              ),
              Text(
                '🤷🏼',
                style: TextStyle(
                  fontSize: 60,
                ),
              )
            ],
          )
        : onedayMorning.isEmpty && !afternoon
            ? Column(
                children: [
                  Text(
                    '${local?.noAttendance}',
                    style: kHeadingThree.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: isEnglish ? 30 : 0,
                  ),
                  Text(
                    '🤷🏼',
                    style: TextStyle(
                      fontSize: 60,
                    ),
                  )
                ],
              )
            : ExpansionTile(
                collapsedBackgroundColor: Color(0xff254973),
                backgroundColor: Color(0xff254973),
                textColor: Colors.white,
                iconColor: Colors.white,
                initiallyExpanded: true,
                title: Text(
                  getDateStringFromDateTime(record.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      AppLocalizations? local = AppLocalizations.of(context);
                      bool isEnglish = isInEnglish(context);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                        color: index % 2 == 0 ? kDarkestBlue : kBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            afternoon
                                ? Text(DateFormat('dd/MM/yyyy HH:mm').format(
                                    ondayAfternoon[index].date as DateTime))
                                : Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(
                                        onedayMorning[index].date as DateTime),
                                  ),
                            Row(
                              children: [
                                afternoon
                                    ? Text(
                                        ondayAfternoon[index].type == 'checkin'
                                            ? '${local?.checkIn}'
                                            : ondayAfternoon[index].type ==
                                                    'checkout'
                                                ? '${local?.checkOut}'
                                                : ondayAfternoon[index].type ==
                                                        'absent'
                                                    ? '${local?.absent}'
                                                    : ondayAfternoon[index]
                                                                .type ==
                                                            'permission'
                                                        ? '${local?.permission}'
                                                        : ondayAfternoon[index]
                                                            .type
                                                            .toString(),
                                        style: kParagraph)
                                    : Text(
                                        onedayMorning[index].type == 'checkin'
                                            ? '${local?.checkIn}'
                                            : onedayMorning[index].type ==
                                                    'checkout'
                                                ? '${local?.checkOut}'
                                                : onedayMorning[index].type ==
                                                        'absent'
                                                    ? '${local?.absent}'
                                                    : onedayMorning[index]
                                                                .type ==
                                                            'permission'
                                                        ? '${local?.permission}'
                                                        : onedayMorning[index]
                                                            .type
                                                            .toString(),
                                        style: kParagraph),
                                PopupMenuButton(
                                  color: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onSelected: (int selectedValue) async {
                                    if (afternoon == false) {
                                      if (selectedValue == 0) {
                                        final int userId =
                                            onedayMorning[index].userId;
                                        final int id = onedayMorning[index].id;
                                        final String type =
                                            onedayMorning[index].type;
                                        final DateTime date =
                                            onedayMorning[index].date;
                                        final String? note =
                                            onedayMorning[index].note;
                                        final String code =
                                            onedayMorning[index].code;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => AttedancesEdit(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              code: code,
                                            ),
                                          ),
                                        );
                                        oneDayMorning = [];
                                        attendanceAllDisplay = [];
                                        fetchAttendanceById();
                                      }
                                      if (selectedValue == 1) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.areYouSure}'),
                                            content:
                                                Text('${local?.cannotUndone}'),
                                            actions: [
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteData(
                                                      onedayMorning[index].id
                                                          as int);
                                                },
                                                child: Text('Yes'),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                child: Text('No'),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      if (selectedValue == 2) {
                                        final int userId =
                                            onedayMorning[index].userId;
                                        final int id = onedayMorning[index].id;
                                        final String type =
                                            onedayMorning[index].type;
                                        final DateTime date =
                                            onedayMorning[index].date;
                                        final String? note =
                                            onedayMorning[index].note;
                                        final String userName =
                                            onedayMorning[index].users!.name;
                                        final String image =
                                            onedayMorning[index].users.image;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewAttendanceScreen(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              userName: userName,
                                              image: image,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    if (afternoon == true) {
                                      if (selectedValue == 0) {
                                        final int userId =
                                            ondayAfternoon[index].userId;
                                        final int id = ondayAfternoon[index].id;
                                        final String type =
                                            ondayAfternoon[index].type;
                                        final DateTime date =
                                            ondayAfternoon[index].date;
                                        final String? note =
                                            ondayAfternoon[index].note;
                                        final String code =
                                            ondayAfternoon[index].code;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => AttedancesEdit(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              code: code,
                                            ),
                                          ),
                                        );
                                        attendanceAllDisplay = [];
                                        fetchAttendanceById();
                                      }
                                      if (selectedValue == 1) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.areYouSure}'),
                                            content:
                                                Text('${local?.cannotUndone}'),
                                            actions: [
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteData(
                                                      ondayAfternoon[index].id
                                                          as int);
                                                },
                                                child: Text('Yes'),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                child: Text('No'),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      if (selectedValue == 2) {
                                        final int userId =
                                            onedayMorning[index].userId;
                                        final int id = onedayMorning[index].id;
                                        final String type =
                                            onedayMorning[index].type;
                                        final DateTime date =
                                            onedayMorning[index].date;
                                        final String note =
                                            onedayMorning[index].note;
                                        final String userName =
                                            onedayMorning[index].users!.name;
                                        final String image =
                                            onedayMorning[index].users.image;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewAttendanceScreen(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              userName: userName,
                                              image: image,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      child: Text('${local?.optionView}',
                                          style: kParagraph.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      value: 2,
                                    ),
                                    if (record.list[0].users!.role == 'admin')
                                      PopupMenuItem(
                                        child: Text('${local?.edit}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        value: 0,
                                      ),
                                    if (record.list[0].users!.role == 'admin')
                                      PopupMenuItem(
                                        child: Text('${local?.delete}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        value: 1,
                                      ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: afternoon
                        ? ondayAfternoon.length
                        : onedayMorning.length,
                  )
                ],
              );
  }

  Widget _buildNowResult(AttendanceWithDate record, BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    List recordMorning = record.list
        .where((element) =>
            element.code != 'cin2' &&
            element.code != 'cout2' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    List recordAfternoon = record.list
        .where((element) =>
            element.code != 'cin1' &&
            element.code != 'cout1' &&
            element.code != 'cin3' &&
            element.code != 'cout3')
        .toList();
    return recordAfternoon.isEmpty && afternoon
        ? Column(
            children: [
              Text(
                '${local?.noAttendance}',
                style: kHeadingThree.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: isEnglish ? 30 : 0,
              ),
              Text(
                '🤷🏼',
                style: TextStyle(
                  fontSize: 60,
                ),
              )
            ],
          )
        : recordMorning.isEmpty && !afternoon
            ? Column(
                children: [
                  Text(
                    '${local?.noAttendance}',
                    style: kHeadingThree.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: isEnglish ? 30 : 0,
                  ),
                  Text(
                    '🤷🏼',
                    style: TextStyle(
                      fontSize: 60,
                    ),
                  )
                ],
              )
            : ExpansionTile(
                collapsedBackgroundColor: Color(0xff254973),
                backgroundColor: Color(0xff254973),
                textColor: Colors.white,
                iconColor: Colors.white,
                initiallyExpanded: true,
                title: Text(
                  getDateStringFromDateTime(record.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      AppLocalizations? local = AppLocalizations.of(context);
                      bool isEnglish = isInEnglish(context);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                        color: index % 2 == 0 ? kDarkestBlue : kBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            afternoon
                                ? Text(DateFormat('dd/MM/yyyy HH:mm').format(
                                    recordAfternoon[index].date as DateTime))
                                : Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(
                                        recordMorning[index].date as DateTime),
                                  ),
                            Row(
                              children: [
                                afternoon
                                    ? Text(
                                        recordAfternoon[index].type == 'checkin'
                                            ? '${local?.checkIn}'
                                            : recordAfternoon[index].type ==
                                                    'checkout'
                                                ? '${local?.checkOut}'
                                                : recordAfternoon[index].type ==
                                                        'absent'
                                                    ? '${local?.absent}'
                                                    : recordAfternoon[index]
                                                                .type ==
                                                            'permission'
                                                        ? '${local?.permission}'
                                                        : recordAfternoon[index]
                                                            .type
                                                            .toString(),
                                        style: kParagraph)
                                    : Text(
                                        recordMorning[index].type == 'checkin'
                                            ? '${local?.checkIn}'
                                            : recordMorning[index].type ==
                                                    'checkout'
                                                ? '${local?.checkOut}'
                                                : recordMorning[index].type ==
                                                        'absent'
                                                    ? '${local?.absent}'
                                                    : recordMorning[index]
                                                                .type ==
                                                            'permission'
                                                        ? '${local?.permission}'
                                                        : recordMorning[index]
                                                            .type
                                                            .toString(),
                                        style: kParagraph),
                                PopupMenuButton(
                                  color: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onSelected: (int selectedValue) async {
                                    if (afternoon == false) {
                                      if (selectedValue == 0) {
                                        final int userId =
                                            recordMorning[index].userId as int;
                                        final int id =
                                            recordMorning[index].id as int;
                                        final String type = recordMorning[index]
                                            .type
                                            .toString();
                                        final DateTime date =
                                            recordMorning[index].date
                                                as DateTime;
                                        final String? note =
                                            recordMorning[index].note;
                                        final String code =
                                            recordMorning[index].code;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => AttedancesEdit(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              code: code,
                                            ),
                                          ),
                                        );
                                        fetchAttendanceById();
                                      }
                                      if (selectedValue == 1) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.areYouSure}'),
                                            content:
                                                Text('${local?.cannotUndone}'),
                                            actions: [
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteData(
                                                      recordMorning[index].id
                                                          as int);
                                                },
                                                child: Text('Yes'),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                child: Text('No'),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      if (selectedValue == 2) {
                                        final int userId =
                                            recordMorning[index].userId as int;
                                        final int id =
                                            recordMorning[index].id as int;
                                        final String type = recordMorning[index]
                                            .type
                                            .toString();
                                        final DateTime date =
                                            recordMorning[index].date
                                                as DateTime;
                                        final String? note =
                                            recordMorning[index].note;
                                        final String userName =
                                            recordMorning[index]
                                                .users!
                                                .name
                                                .toString();
                                        final String image =
                                            recordMorning[index]
                                                .users!
                                                .image
                                                .toString();
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewAttendanceScreen(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              userName: userName,
                                              image: image,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    if (afternoon == true) {
                                      if (selectedValue == 0) {
                                        final int userId =
                                            recordAfternoon[index].userId;
                                        final int id =
                                            recordAfternoon[index].id;
                                        final String type =
                                            recordAfternoon[index].type;
                                        final DateTime date =
                                            recordAfternoon[index].date;
                                        final String? note =
                                            recordAfternoon[index].note;
                                        final String code =
                                            recordAfternoon[index].code;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => AttedancesEdit(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              code: code,
                                            ),
                                          ),
                                        );
                                        fetchAttendanceById();
                                      }
                                      if (selectedValue == 1) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.areYouSure}'),
                                            content:
                                                Text('${local?.cannotUndone}'),
                                            actions: [
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteData(
                                                      recordAfternoon[index].id
                                                          as int);
                                                },
                                                child: Text('Yes'),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                child: Text('No'),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      if (selectedValue == 2) {
                                        final int userId =
                                            recordMorning[index].userId as int;
                                        final int id =
                                            recordMorning[index].id as int;
                                        final String type = recordMorning[index]
                                            .type
                                            .toString();
                                        final DateTime date =
                                            recordMorning[index].date
                                                as DateTime;
                                        final String note = recordMorning[index]
                                            .note
                                            .toString();
                                        final String userName =
                                            recordMorning[index]
                                                .users!
                                                .name
                                                .toString();
                                        final String image =
                                            recordMorning[index]
                                                .users!
                                                .image
                                                .toString();
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewAttendanceScreen(
                                              id: id,
                                              userId: userId,
                                              type: type,
                                              date: date,
                                              note: note,
                                              userName: userName,
                                              image: image,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      child: Text('${local?.optionView}',
                                          style: kParagraph.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      value: 2,
                                    ),
                                    if (recordMorning[0].users!.role == 'admin')
                                      PopupMenuItem(
                                        child: Text('${local?.edit}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        value: 0,
                                      ),
                                    if (recordMorning[0].users!.role == 'admin')
                                      PopupMenuItem(
                                        child: Text('${local?.delete}',
                                            style: kParagraph.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        value: 1,
                                      ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: afternoon
                        ? recordAfternoon.length
                        : recordMorning.length,
                  ),
                ],
              );
  }

  Widget _buildAllResult(AttendanceWithDate record) {
    return ExpansionTile(
      collapsedBackgroundColor: Color(0xff254973),
      backgroundColor: Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(record.date),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        ListView.builder(
          itemBuilder: (context, index) {
            AppLocalizations? local = AppLocalizations.of(context);
            bool isEnglish = isInEnglish(context);
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 8,
              ),
              color: index % 2 == 0 ? kDarkestBlue : kBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(record.list[index].date as DateTime),
                  ),
                  Row(
                    children: [
                      Text(
                        record.list[index].type == 'checkin'
                            ? '${local?.checkIn}'
                            : record.list[index].type == 'checkout'
                                ? '${local?.checkOut}'
                                : record.list[index].type == 'absent'
                                    ? '${local?.absent}'
                                    : record.list[index].type == 'permission'
                                        ? '${local?.permission}'
                                        : record.list[index].type.toString(),
                      ),
                      PopupMenuButton(
                        color: Colors.black,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onSelected: (int selectedValue) async {
                          if (selectedValue == 0) {
                            final int userId = record.list[index].userId as int;
                            final int id = record.list[index].id as int;
                            final String type =
                                record.list[index].type.toString();
                            final DateTime date =
                                record.list[index].date as DateTime;
                            final String? note = record.list[index].note;
                            final String code =
                                record.list[index].code.toString();
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AttedancesEdit(
                                  id: id,
                                  userId: userId,
                                  type: type,
                                  date: date,
                                  note: note,
                                  code: code,
                                ),
                              ),
                            );
                            fetchAllAttendance();
                          }
                          if (selectedValue == 1) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('${local?.areYouSure}'),
                                content: Text('${local?.cannotUndone}'),
                                actions: [
                                  OutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      deleteData(record.list[index].id as int);
                                    },
                                    child: Text('${local?.yes}'),
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  OutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    borderSide: BorderSide(color: Colors.red),
                                    child: Text('${local?.no}'),
                                  )
                                ],
                              ),
                            );
                          }
                          if (selectedValue == 2) {
                            final int userId = record.list[index].userId as int;
                            final int id = record.list[index].id as int;
                            final String type =
                                record.list[index].type.toString();
                            final DateTime date =
                                record.list[index].date as DateTime;
                            final String? note = record.list[index].note;
                            final String userName =
                                record.list[index].users!.name.toString();
                            final String image =
                                record.list[index].users!.image.toString();
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ViewAttendanceScreen(
                                  id: id,
                                  userId: userId,
                                  type: type,
                                  date: date,
                                  note: note,
                                  userName: userName,
                                  image: image,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Text(
                              '${local?.optionView}',
                              style: kParagraph.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            value: 2,
                          ),
                          if (record.list[0].users!.role == 'admin')
                            PopupMenuItem(
                              child: Text(
                                '${local?.edit}',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              value: 0,
                            ),
                          if (record.list[0].users!.role == 'admin')
                            PopupMenuItem(
                              child: Text(
                                '${local?.delete}',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              value: 1,
                            ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: record.list.length,
        )
      ],
    );
  }
}
