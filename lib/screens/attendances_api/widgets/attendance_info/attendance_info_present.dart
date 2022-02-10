import 'package:flutter/material.dart';

import 'package:ems/utils/utils.dart';

import '../../../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
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
    var counted = afternoon ? presentAfternoon : presentMorning;
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
                      style: kHeadingFour.copyWith(color: numColor),
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: kHeadingFour.copyWith(color: kWhite),
        ),
      ],
    );
  }
}
