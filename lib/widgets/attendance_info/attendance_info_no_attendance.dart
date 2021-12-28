import 'package:flutter/material.dart';

import '../../constants.dart';

class AttendanceInfoNoAttenance extends StatelessWidget {
  const AttendanceInfoNoAttenance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 200, left: 40),
      child: Column(
        children: [
          Text(
            'NO ATTENDANCE ADDED YET!!',
            style: kHeadingThree.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/images/calendar.jpeg',
            width: 220,
          ),
        ],
      ),
    );
  }
}
