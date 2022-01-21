import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../../../constants.dart';
import '../../employee_edit_screen.dart';

class PersonalInfo extends StatelessWidget {
  List<User> userDisplay;
  List<User> user;
  final Function fetchUserById;
  PersonalInfo({
    Key? key,
    required this.userDisplay,
    required this.user,
    required this.fetchUserById,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${local?.personal}',
                  style: TextStyle(
                    fontSize: 27,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EmployeeEditScreen(
                                  userDisplay[0].id as int,
                                  userDisplay[0].name.toString(),
                                  userDisplay[0].phone.toString(),
                                  userDisplay[0].email.toString(),
                                  userDisplay[0].address.toString(),
                                  userDisplay[0].position.toString(),
                                  userDisplay[0].skill.toString(),
                                  userDisplay[0].salary.toString(),
                                  userDisplay[0].role.toString(),
                                  userDisplay[0].status.toString(),
                                  userDisplay[0].rate.toString(),
                                  userDisplay[0].background.toString(),
                                  userDisplay[0].image.toString(),
                                  userDisplay[0].imageId.toString())));
                      fetchUserById();
                    },
                    icon: Icon(Icons.edit)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BaselineRow(
                    children: [
                      Text(
                        '${local?.name} ',
                        style: kParagraph.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: isEnglish ? 80 : 90,
                      ),
                      Text(
                        userDisplay[0].name.toString(),
                        style: kParagraph.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: isEnglish ? 20 : 10,
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.id} ',
                    style: kParagraph.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: isEnglish ? 110 : 80,
                  ),
                  Text(
                    userDisplay[0].id.toString(),
                    style: kParagraph.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: isEnglish ? 20 : 10,
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.email} ',
                    style: kParagraph.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: isEnglish ? 85 : 90,
                  ),
                  SizedBox(
                    width: 210,
                    child: Text(
                      userDisplay[0].email.toString(),
                      style: kParagraph.copyWith(
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: isEnglish ? 20 : 10,
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.phoneNumber} ',
                    style: kParagraph.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: isEnglish ? 80 : 62,
                  ),
                  Text(
                    userDisplay[0].phone.toString(),
                    style: kParagraph.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${local?.address} ',
                      style: kParagraph.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: isEnglish ? 50 : 50,
                    ),
                    SizedBox(
                      width: 220,
                      // height: 35,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                          userDisplay[0].address == null
                              ? '${local?.noData}'
                              : userDisplay[0].address.toString(),
                          style: kParagraph.copyWith(
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${local?.background}: ',
                      style: kParagraph.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: isEnglish ? 16 : 46,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        userDisplay[0].background == null
                            ? '${local?.noData}'
                            : userDisplay[0].background.toString(),
                        style: kParagraph.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
