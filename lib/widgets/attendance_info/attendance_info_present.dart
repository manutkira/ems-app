import 'package:flutter/material.dart';

import 'package:ems/utils/utils.dart';

import '../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
  final bool multipleDay;
  dynamic presentAfternoon;
  dynamic countPresentNoon;
  dynamic presentMorning;
  dynamic countPresent;
  dynamic presentAll;
  // dynamic lateAll;
  // dynamic permissionAll;
  // dynamic absentAll;
  bool alltime;
  AttendanceInfoPresent({
    Key? key,
    required this.text,
    required this.afternoon,
    required this.multipleDay,
    required this.presentAfternoon,
    required this.countPresentNoon,
    required this.presentMorning,
    required this.countPresent,
    required this.presentAll,
    // required this.lateAll,
    // required this.permissionAll,
    // required this.absentAll,
    required this.alltime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEnglish = isInEnglish(context);
    var counted = afternoon
        ? multipleDay
            ? presentAfternoon
            : countPresentNoon
        : multipleDay
            ? presentMorning
            : countPresent;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
          child: Text(
            text,
            style: kHeadingFour.copyWith(color: kWhite),
          ),
        ),
        Visibility(
          visible: counted == null,
          child: CircularProgressIndicator(),
        ),
        Visibility(
          visible: counted != null,
          child: Text(
            alltime ? presentAll : counted,
            style: kHeadingFour.copyWith(color: kWhite),
          ),
        )
      ],
    );
  }
}
