import 'package:flutter/material.dart';

import 'package:ems/utils/utils.dart';

import '../../../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
  final bool total;
  final bool multipleDay;
  final bool isOneday;
  final bool isLoading;
  final bool isLoadingAll;
  final bool isLoadingById;
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
  Color numColor;
  Color backgroundColor;
  AttendanceInfoPresent({
    Key? key,
    required this.text,
    required this.afternoon,
    required this.total,
    required this.multipleDay,
    required this.isOneday,
    required this.isLoading,
    required this.isLoadingAll,
    required this.isLoadingById,
    required this.now,
    required this.todayMorning,
    required this.todayAfternoon,
    this.presentAfternoon,
    this.countPresentNoon,
    this.presentMorning,
    required this.onedayMorning,
    required this.onedayAfternoon,
    this.countPresent,
    required this.presentAll,
    required this.alltime,
    required this.numColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEnglish = isInEnglish(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 47,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isLoading && isLoadingAll || isLoadingById
                ? SizedBox(
                    child: Image.asset(
                      'assets/images/Gear-0.5s-200px.gif',
                      width: 20,
                    ),
                    // height: 10,
                    // width: 10,
                  )
                : Visibility(
                    // visible: counted != null,
                    child: Text(
                      now
                          ? total
                              ? (int.parse(todayMorning) +
                                      int.parse(todayAfternoon))
                                  .toString()
                              : afternoon
                                  ? todayAfternoon
                                  : todayMorning
                          : isOneday && !alltime
                              ? total
                                  ? (int.parse(onedayAfternoon) +
                                          int.parse(onedayMorning))
                                      .toString()
                                  : afternoon
                                      ? onedayAfternoon
                                      : onedayMorning
                              : alltime
                                  ? presentAll
                                  : multipleDay && !isOneday && !alltime
                                      ? total
                                          ? (int.parse(presentAfternoon) +
                                                  int.parse(presentMorning))
                                              .toString()
                                          : afternoon
                                              ? presentAfternoon
                                              : presentMorning
                                      : '',
                      style: kHeadingFour.copyWith(color: numColor),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: isEnglish
              ? const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )
              : kHeadingFour.copyWith(color: kWhite),
        ),
      ],
    );
  }
}
