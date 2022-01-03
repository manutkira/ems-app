import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class AttendanceInfoNoAttenance extends StatelessWidget {
  const AttendanceInfoNoAttenance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      padding: const EdgeInsets.only(top: 200, left: 90),
      child: Column(
        children: [
          Text(
            '${local?.noAttendance}',
            style: kHeadingThree.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: isEnglish ? 30 : 10,
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
