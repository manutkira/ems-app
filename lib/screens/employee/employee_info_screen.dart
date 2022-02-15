import 'dart:convert';

import 'package:ems/models/bank.dart';
import 'package:ems/models/rate.dart';
import 'package:ems/screens/employee/widgets/employee_info/employment_info.dart';
import 'package:ems/screens/employee/widgets/employee_info/personal_info.dart';
import 'package:ems/utils/services/bank_service.dart';
import 'package:ems/utils/services/position_service.dart';
import 'package:ems/utils/services/rate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'package:ems/models/user.dart';
import 'package:ems/screens/card/card.screen.dart';
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
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // services
  final UserService _userService = UserService.instance;
  final RateServices _rateServices = RateServices.instance;
  final BankService _bankService = BankService.instance;
  final PositionService _positionService = PositionService.instance;

  // list user
  List<User> userDisplay = [];
  List<User> user = [];

  // list position
  List positionDisplay = [];

  // list bank
  List<Bank> bankDisplay = [];

  // list rate
  final List<Rate> rateList = [];
  List rateDisplay = [];
  List<Rate> ratesDisplay = [];

  // text controller
  final rateNameController = TextEditingController();
  final rateScoreController = TextEditingController();
  final idController = TextEditingController();

  // bollean
  bool _isloading = true;
  bool personal = true;
  bool employeement = false;

  // variable
  Object snapshotData = '';
  String dropDownValue = '';
  static List<Tab> myTabs = <Tab>[];
  late TabController _tabController;
  late Tab _handler;

  void deleteRateItem(int id) {
    setState(() {
      rateList.removeWhere((element) => element.id == id);
    });
  }

  // fetch user from api
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

  // fetch rate from api
  fetchRateData() {
    try {
      _rateServices.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            ratesDisplay = [];
            ratesDisplay.addAll(usersFromServer);
          });
        }
      });
    } catch (err) {}
  }

  // fetch bank info from api
  fetchBankData() {
    try {
      _bankService.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            bankDisplay = [];
            bankDisplay.addAll(usersFromServer);
          });
        }
      });
    } catch (err) {}
  }

  // fetch position from api
  fetchUserPosition() {
    try {
      _positionService.findPosition(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            positionDisplay = [];
            positionDisplay.add(usersFromServer);
          });
        }
      });
    } catch (err) {}
  }

  @override
  void initState() {
    fetchBankData();
    fetchRateData();
    fetchUserById();
    fetchUserPosition();
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
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 16, left: 30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          userDisplay[0].image == null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 1,
                                                    color: Colors.white,
                                                  )),
                                                  child: Image.asset(
                                                    'assets/images/profile-icon-png-910.png',
                                                    height: 200,
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 1,
                                                    color: Colors.white,
                                                  )),
                                                  child: Image.network(
                                                    userDisplay[0]
                                                        .image
                                                        .toString(),
                                                    height: 200,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ));
                          },
                          child: Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
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
                        ),
                        const SizedBox(
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
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(userDisplay[0].name.toString()),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            BaselineRow(
                              children: [
                                Text(
                                  '${local?.id} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
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
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                content: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    userDisplay[0].imageId ==
                                                            null
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              width: 1,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                            child: Text(
                                                                'No Image'))
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              width: 1,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                            child:
                                                                Image.network(
                                                              userDisplay[0]
                                                                  .imageId
                                                                  .toString(),
                                                              height: 200,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Text('${local?.optionView}')),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                content: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    userDisplay[0].imageId ==
                                                            null
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              width: 1,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                            child: Text(
                                                                'No Image'))
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              width: 1,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                            child:
                                                                Image.network(
                                                              userDisplay[0]
                                                                  .imageId
                                                                  .toString(),
                                                              height: 200,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ));
                                    },
                                    icon: const Icon(Icons.credit_card)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DefaultTabController(
                    length: 2,
                    child: SizedBox(
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
                      margin: const EdgeInsets.only(top: 0),
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
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
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              PersonalInfo(
                                  bankDisplay: bankDisplay,
                                  fetchBankData: fetchBankData,
                                  userDisplay: userDisplay,
                                  user: user,
                                  fetchUserById: () {
                                    fetchUserById();
                                  }),
                              EmploymentInfo(
                                  fetchUserPosition: fetchUserPosition,
                                  positionDisplay: positionDisplay,
                                  fetchRateDate: fetchRateData,
                                  rateDisplay: ratesDisplay,
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
