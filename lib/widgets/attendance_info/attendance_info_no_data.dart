import 'package:flutter/material.dart';

import '../../constants.dart';

class AttendanceInfoNoData extends StatelessWidget {
  const AttendanceInfoNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 0),
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
            Text(
              '🤷🏼',
              style: TextStyle(
                fontSize: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
