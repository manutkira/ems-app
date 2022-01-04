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
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      height: 120,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: kDarkestBlue,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 75,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: isEnglish ? 50 : 74,
                    margin: const EdgeInsets.only(left: 25, top: 25),
                    child: Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaselineRow(
                            children: [
                              Text(
                                '${local?.id} : ',
                                style: kParagraph.copyWith(
                                    color: kLightBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: isEnglish ? 47 : 20,
                              ),
                              Text(
                                id,
                                style: kParagraph.copyWith(
                                    color: kLightBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: isEnglish ? 10 : 0,
                          ),
                          BaselineRow(
                            children: [
                              Text(
                                '${local?.name} : ',
                                style: kParagraph.copyWith(
                                    color: kLightBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: isEnglish ? 20 : 32,
                              ),
                              Text(
                                name,
                                style: kParagraph.copyWith(
                                    color: kLightBlue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
