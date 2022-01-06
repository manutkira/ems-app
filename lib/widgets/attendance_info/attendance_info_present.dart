import 'package:flutter/material.dart';

import 'package:ems/utils/utils.dart';

import '../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
  final bool multipleDay;
  final bool isOneday;
  final bool isLoading;
  final bool now;
  dynamic todayMorning;
  dynamic todayAfternoon;
  dynamic presentAfternoon;
  dynamic countPresentNoon;
  dynamic presentMorning;
  dynamic onedayMorning;
  dynamic onedayAfternoon;
  dynamic countPresent;
  dynamic presentAll;
  bool alltime;
  AttendanceInfoPresent({
    Key? key,
    required this.text,
    required this.afternoon,
    required this.multipleDay,
    required this.isOneday,
    required this.isLoading,
    required this.now,
    required this.todayMorning,
    required this.todayAfternoon,
    required this.presentAfternoon,
    required this.countPresentNoon,
    required this.presentMorning,
    required this.onedayMorning,
    required this.onedayAfternoon,
    required this.countPresent,
    required this.presentAll,
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
        isLoading
            ? SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                height: 10,
                width: 10,
              )
            : Visibility(
                visible: counted != null,
                child: Text(
                  now
                      ? afternoon
                          ? todayAfternoon
                          : todayMorning
                      : isOneday && !alltime
                          ? afternoon
                              ? onedayAfternoon
                              : onedayMorning
                          : alltime
                              ? presentAll
                              : counted,
                  style: kHeadingFour.copyWith(color: kWhite),
                ),
              )
      ],
    );
  }
}
