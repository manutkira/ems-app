import 'dart:convert';

import 'package:ems/models/rate.dart';
import 'package:ems/screens/employee/employee_edit_employment.dart';
import 'package:ems/screens/employee/widgets/employee_info/employment_info.dart';
import 'package:ems/screens/employee/widgets/employee_info/personal_info.dart';
import 'package:ems/utils/services/rate_service.dart';
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
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";
  final List<Rate> rateList = [];
  final rateNameController = TextEditingController();
  final rateScoreController = TextEditingController();
  final idController = TextEditingController();

  void addRateList(
    String name,
    int score,
    int id,
    int userId,
  ) {
    final rate = Rate(rateName: name, score: score, id: id, userId: userId);
    setState(() {
      rateList.add(rate);
    });
  }

  void deleteRateItem(int id) {
    setState(() {
      rateList.removeWhere((element) => element.id == id);
    });
  }

  // late int employeeId;
  Object snapshotData = '';
  final UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];
  final RateService _rateService = RateService.instance;
  List rateDisplay = [];
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
            user = [];
            userDisplay = [];
            _isloading = true;
            user.add(usersFromServer);
            userDisplay = user;
            _isloading = false;
          });
        }
      });
    } catch (err) {}
  }

  fetchRateDate() {
    try {
      _rateService.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            rateDisplay = [];
            rateDisplay.add(usersFromServer);
          });
        }
      });
    } catch (err) {}
  }

  @override
  void initState() {
    fetchUserById();
    fetchRateDate();
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
        title: Text('${local?.employeeInfo}'),
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
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              PersonalInfo(
                                  userDisplay: userDisplay,
                                  user: user,
                                  fetchUserById: () {
                                    fetchUserById();
                                  }),
                              EmploymentInfo(
                                  fetchRateDate: fetchRateDate,
                                  rateDisplay: rateDisplay,
                                  userDisplay: userDisplay,
                                  user: user,
                                  rateList: rateList,
                                  fetchUserById: fetchUserById,
                                  checkRole: checkRole,
                                  checkSatus: checkSatus,
                                  checkRate: checkRate,
                                  addRateList: addRate,
                                  deleteRateItem: deleteRateItem,
                                  rateNameController: rateNameController,
                                  rateScoreController: rateScoreController,
                                  idController: idController)
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  addRate() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aName = rateNameController.text;
    var aScore = rateScoreController.text;
    var request = await http.MultipartRequest(
        'POST', Uri.parse("$urlUser/${widget.id}/ratework"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files.add(http.MultipartFile.fromString('skill_name', aName));
    request.files.add(http.MultipartFile.fromString('score', aScore));

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 201) {
      Navigator.of(context).pop();
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
