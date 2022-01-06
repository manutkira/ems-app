import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class AttendanceInfoNameId extends StatelessWidget {
  final String name;
  final String id;
  final String image;
  const AttendanceInfoNameId({
    Key? key,
    required this.name,
    required this.id,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: kDarkestBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: image == null
                  ? Image.asset(
                      'assets/images/profile-icon-png-910.png',
                      width: 50,
                    )
                  : Image.network(
                      image,
                      height: 50,
                    ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaselineRow(
                children: [
                  Text(
                    '${local?.name} : ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(name),
                ],
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.id} : ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(id),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
