import 'package:flutter/material.dart';

import '../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
  final bool multipleDay;
  dynamic presentAfternoon;
  dynamic countPresentNoon;
  dynamic presentMorning;
  dynamic countPresent;
  AttendanceInfoPresent({
    Key? key,
    required this.text,
    required this.afternoon,
    required this.multipleDay,
    required this.presentAfternoon,
    required this.countPresentNoon,
    required this.presentMorning,
    required this.countPresent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var counted = afternoon
        ? multipleDay
            ? presentAfternoon
            : countPresentNoon
        : multipleDay
            ? presentMorning
            : countPresent;
    return Row(
      children: [
        Text(
          text,
          style: kHeadingFour.copyWith(color: kWhite),
        ),
        Visibility(
          visible: counted == null,
          child: CircularProgressIndicator(),
        ),
        Visibility(
          visible: counted != null,
          child: Text(
            counted,
            style: kHeadingFour.copyWith(color: kWhite),
          ),
        )
      ],
    );
  }
}
