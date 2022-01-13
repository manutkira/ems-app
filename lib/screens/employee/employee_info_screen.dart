import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'package:ems/models/user.dart';
import 'package:ems/screens/card/card.screen.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../constants.dart';

class EmployeeInfoScreen extends StatefulWidget {
  final int id;
  const EmployeeInfoScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  static const routeName = '/employee-infomation';

  @override
  State<EmployeeInfoScreen> createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  // late int employeeId;
  Object snapshotData = '';
  final UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];
  bool _isloading = true;

  fetchUserById() async {
    try {
      _userService.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            _isloading = true;
            user.add(usersFromServer);
            userDisplay = user;
            _isloading = false;
          });
        }
      });
    } catch (err) {}
  }

  @override
  void initState() {
    fetchUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final color = const Color(0xff05445E);
    final color1 = const Color(0xff3982A0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
        actions: [
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
              user = [];
              userDisplay = [];
              fetchUserById();
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${local?.fetchData}'),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: userDisplay[0].image == null
                                ? Image.asset(
                                    'assets/images/profile-icon-png-910.png',
                                    width: 70,
                                  )
                                : Image.network(
                                    userDisplay[0].image.toString(),
                                    height: 70,
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
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(userDisplay[0].name.toString()),
                              ],
                            ),
                            BaselineRow(
                              children: [
                                Text(
                                  '${local?.id} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(userDisplay[0].id.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              int id = userDisplay[0].id as int;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => NationalIdScreen(
                                    id: id.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Text('${local?.optionView}')),
                        IconButton(
                            onPressed: () {
                              int id = userDisplay[0].id as int;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => NationalIdScreen(
                                    id: id.toString(),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.credit_card)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                color1,
                                color,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.name} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.id} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 85 : 90,
                                  ),
                                  Text(
                                    userDisplay[0].email.toString(),
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
                                    '${local?.position} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 65 : 85,
                                  ),
                                  Text(
                                    userDisplay[0].position.toString(),
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
                                    '${local?.skill} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 95 : 92,
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: Text(
                                      userDisplay[0].skill.toString(),
                                      style: kParagraph.copyWith(
                                        color: Colors.white,
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
                                    '${local?.salary} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 78 : 85,
                                  ),
                                  Text(
                                    '\$${userDisplay[0].salary.toString()}',
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
                                    '${local?.role} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 95 : 99,
                                  ),
                                  Text(
                                    userDisplay[0].role.toString(),
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
                                    '${local?.status} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 78 : 78,
                                  ),
                                  Text(
                                    userDisplay[0].status.toString(),
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
                                    '${local?.rate} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 93 : 77,
                                  ),
                                  Text(
                                    userDisplay[0].rate.toString(),
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
                                    '${local?.phoneNumber} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 80 : 63,
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
                                child: Column(
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
                                      height: 20,
                                    ),
                                    Container(
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: Text(
                                          userDisplay[0].address.toString(),
                                          style: kParagraph.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
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
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        userDisplay[0].background.toString(),
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
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
