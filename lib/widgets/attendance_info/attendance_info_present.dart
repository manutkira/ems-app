import 'package:flutter/material.dart';

import '../../constants.dart';

class AttendanceInfoPresent extends StatelessWidget {
  final String text;
  final bool afternoon;
  final bool multipleDay;
  final String presentAfternoon;
  final String countPresentNoon;
  final String presentMorning;
  final String countPresent;
  const AttendanceInfoPresent({
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
    return Row(
      children: [
        Text(
          text,
          style: kHeadingFour.copyWith(color: kWhite),
        ),
        Text(
          afternoon
              ? multipleDay
                  ? presentAfternoon
                  : countPresentNoon
              : multipleDay
                  ? presentMorning
                  : countPresent,
          style: kHeadingFour.copyWith(color: kWhite),
        )
      ],
    );
  }
}
