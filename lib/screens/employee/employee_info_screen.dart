import 'dart:convert';

import 'package:ems/models/rate.dart';
import 'package:ems/screens/employee/employee_edit_employment.dart';
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

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen>
    with SingleTickerProviderStateMixin {
  // rate list
  final List<Rate> rateList = [];
  final rateNameController = TextEditingController();
  final rateScoreController = TextEditingController();

  void addRateList(String name, int score) {
    final rate = Rate(rateName: name, score: score);
    setState(() {
      rateList.add(rate);
    });
  }

  // late int employeeId;
  Object snapshotData = '';
  final UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];
  bool _isloading = true;
  String dropDownValue = '';
  bool personal = true;
  bool Employeement = false;
  static List<Tab> myTabs = <Tab>[];
  late TabController _tabController;
  late Tab _handler;

  fetchUserById() async {
    try {
      _isloading = true;
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleSelected);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
      _handler = myTabs[_tabController.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final color = const Color(0xff05445E);
    final color1 = const Color(0xff3982A0);
    if (dropDownValue.isEmpty) {
      dropDownValue = local!.personal;
    }
    if (myTabs.isEmpty) {
      myTabs = [
        Tab(
          text: local?.personal,
        ),
        Tab(
          text: local?.employment,
        ),
      ];
    }

    String checkRole() {
      if (userDisplay[0].role == 'admin') {
        return '${local?.admin}';
      }
      if (userDisplay[0].role == 'employee') {
        return '${local?.employee}';
      } else {
        return '';
      }
    }

    String checkSatus() {
      if (userDisplay[0].status == 'active') {
        return '${local?.active}';
      }
      if (userDisplay[0].status == 'inactive') {
        return '${local?.inactive}';
      }
      if (userDisplay[0].status == 'resigned') {
        return '${local?.resigned}';
      }
      if (userDisplay[0].status == 'fired') {
        return '${local?.fired}';
      } else {
        return '';
      }
    }

    String checkRate() {
      if (userDisplay[0].rate == 'verygood') {
        return '${local?.veryGood}';
      }
      if (userDisplay[0].rate == 'good') {
        return '${local?.good}';
      }
      if (userDisplay[0].rate == 'medium') {
        return '${local?.medium}';
      }
      if (userDisplay[0].rate == 'low') {
        return '${local?.low}';
      } else {
        return '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => EmployeeEditScreen(
          //                 userDisplay[0].id as int,
          //                 userDisplay[0].name.toString(),
          //                 userDisplay[0].phone.toString(),
          //                 userDisplay[0].email.toString(),
          //                 userDisplay[0].address.toString(),
          //                 userDisplay[0].position.toString(),
          //                 userDisplay[0].skill.toString(),
          //                 userDisplay[0].salary.toString(),
          //                 userDisplay[0].role.toString(),
          //                 userDisplay[0].status.toString(),
          //                 userDisplay[0].rate.toString(),
          //                 userDisplay[0].background.toString(),
          //                 userDisplay[0].image.toString(),
          //                 userDisplay[0].imageId.toString())));
          //     user = [];
          //     userDisplay = [];
          //     fetchUserById();
          //   },
          //   icon: Icon(Icons.edit),
          // ),
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
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, right: 16, left: 30),
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
                                SizedBox(
                                  width: 130,
                                  child: Text(userDisplay[0].name.toString()),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
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
                            Row(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Container(
                      width: 350,
                      child: TabBar(
                        // ),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: '${local?.personal}',
                          ),
                          Tab(
                            text: '${local?.employment}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 500,
                      margin: EdgeInsets.only(top: 0),
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                kDarkestBlue,
                                color,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                        child: SizedBox(
                          height: 100,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Employment',
                                            style: TextStyle(
                                              fontSize: 27,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            EmployeeEditScreen(
                                                                userDisplay[0]
                                                                    .id as int,
                                                                userDisplay[0]
                                                                    .name
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .phone
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .email
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .address
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .position
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .skill
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .salary
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .role
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .status
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .rate
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .background
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .image
                                                                    .toString(),
                                                                userDisplay[0]
                                                                    .imageId
                                                                    .toString())));
                                                user = [];
                                                userDisplay = [];
                                                fetchUserById();
                                              },
                                              icon: Icon(Icons.edit)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BaselineRow(
                                              children: [
                                                Text(
                                                  '${local?.name} ',
                                                  style: kParagraph.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: isEnglish ? 80 : 90,
                                                ),
                                                Text(
                                                  userDisplay[0]
                                                      .name
                                                      .toString(),
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
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
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
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 15,
                                                  ),
                                                  child: Text(
                                                    userDisplay[0].address ==
                                                            null
                                                        ? '${local?.noData}'
                                                        : userDisplay[0]
                                                            .address
                                                            .toString(),
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
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: Text(
                                                  userDisplay[0].background ==
                                                          null
                                                      ? '${local?.noData}'
                                                      : userDisplay[0]
                                                          .background
                                                          .toString(),
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
                              ),
                              SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Employment',
                                                  style: TextStyle(
                                                    fontSize: 27,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  EmployeeEditEmployment(
                                                                    userDisplay[
                                                                            0]
                                                                        .name
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .phone
                                                                        .toString(),
                                                                    userDisplay[0]
                                                                            .id
                                                                        as int,
                                                                    userDisplay[
                                                                            0]
                                                                        .position
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .skill
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .salary
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .role
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .status
                                                                        .toString(),
                                                                    userDisplay[
                                                                            0]
                                                                        .rate
                                                                        .toString(),
                                                                  )));
                                                      user = [];
                                                      userDisplay = [];
                                                      fetchUserById();
                                                    },
                                                    icon: Icon(Icons.edit)),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: isEnglish ? 20 : 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BaselineRow(
                                                    children: [
                                                      Text(
                                                        '${local?.position} ',
                                                        style:
                                                            kParagraph.copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            isEnglish ? 65 : 85,
                                                      ),
                                                      Text(
                                                        userDisplay[0]
                                                                    .position ==
                                                                null
                                                            ? '${local?.noData}'
                                                            : userDisplay[0]
                                                                .position
                                                                .toString(),
                                                        style:
                                                            kParagraph.copyWith(
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
                                                    '${local?.skill} ',
                                                    style: kParagraph.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: isEnglish ? 95 : 92,
                                                  ),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text(
                                                      userDisplay[0].skill ==
                                                              null
                                                          ? '${local?.noData}'
                                                          : userDisplay[0]
                                                              .skill
                                                              .toString(),
                                                      style:
                                                          kParagraph.copyWith(
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: isEnglish ? 78 : 85,
                                                  ),
                                                  Text(
                                                    userDisplay[0].salary ==
                                                            null
                                                        ? '${local?.noData}'
                                                        : '\$${userDisplay[0].salary.toString()}',
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: isEnglish ? 95 : 99,
                                                  ),
                                                  Text(
                                                    checkRole(),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: isEnglish ? 78 : 78,
                                                  ),
                                                  Text(
                                                    checkSatus(),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: isEnglish ? 93 : 77,
                                                  ),
                                                  Text(
                                                    checkRate(),
                                                    style: kParagraph.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Rating',
                                              style: TextStyle(
                                                fontSize: 27,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (_) {
                                                        return Container(
                                                          height: 240,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: kBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(30),
                                                              topLeft: Radius
                                                                  .circular(30),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          '${local?.skill} ',
                                                                          style:
                                                                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width: isEnglish
                                                                              ? 52
                                                                              : 20,
                                                                        ),
                                                                        Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                                          child:
                                                                              Flex(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Container(
                                                                                  height: 35,
                                                                                  child: TextFormField(
                                                                                    decoration: InputDecoration(
                                                                                      contentPadding: EdgeInsets.only(left: 10),
                                                                                      hintText: '${local?.enterSkill}',
                                                                                      errorStyle: TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    controller: rateNameController,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          '${local?.score} ',
                                                                          style:
                                                                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width: isEnglish
                                                                              ? 40
                                                                              : 40,
                                                                        ),
                                                                        Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                                          child:
                                                                              Flex(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Container(
                                                                                  height: 35,
                                                                                  child: TextFormField(
                                                                                    decoration: InputDecoration(
                                                                                      contentPadding: EdgeInsets.only(left: 10),
                                                                                      hintText: '${local?.enterScore}',
                                                                                      errorStyle: TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    controller: rateScoreController,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            30),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        addRateList(
                                                                          rateNameController
                                                                              .text,
                                                                          int.parse(
                                                                              rateScoreController.text),
                                                                        );
                                                                        Navigator.pop(
                                                                            context);
                                                                        rateNameController.text =
                                                                            '';
                                                                        rateScoreController.text =
                                                                            '';
                                                                      },
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          Text(
                                                                        'Cancel',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: Icon(Icons.add))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: ListView(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(8),
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: rateList.map((e) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(e.rateName),
                                                          Text(
                                                              '${e.score.toString()} / 10'),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
