import 'package:ems/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class AttendanceInfoNoData extends StatelessWidget {
  const AttendanceInfoNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      padding: EdgeInsets.only(top: isEnglish ? 50 : 0, left: 0),
      child: Column(
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
          const Text(
            '🤷🏼',
            style: TextStyle(
              fontSize: 60,
            ),
          ),
        ],
      ),
    );
  }
}
