// ignore_for_file: prefer_const_declarations, unused_local_variable, unused_field

import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/widgets/employee_info/employment_info.dart';
import 'package:ems/screens/employee/widgets/employee_info/personal_info.dart';
import 'package:ems/services/position.dart';
import 'package:ems/services/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../models/bank.dart' as model_bank;
import '../../models/rating.dart';
import '../../services/bank.dart' as service_bank;
import '../../services/rating.dart';

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
  final RatingService _rateServices = RatingService();
  final service_bank.BankService _bankService = service_bank.BankService();
  final PositionService _positionService = PositionService.instance;

  // list user
  List<User> userDisplay = [];
  List<User> user = [];

  // list position
  List positionDisplay = [];

  // list bank
  List<model_bank.Bank> bankDisplay = [];

  // list rate
  final List<Rating> rateList = [];
  List rateDisplay = [];
  List<Rating> ratesDisplay = [];

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
    } catch (err) {
      rethrow;
    }
  }

  // fetch rate from api
  fetchRateData() {
    try {
      _rateServices.findAllByUserId(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            ratesDisplay = [];
            ratesDisplay.addAll(usersFromServer);
          });
        }
      });
    } catch (err) {
      rethrow;
    }
  }

  // fetch bank info from api
  fetchBankData() {
    try {
      _bankService.findAllByUserId(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            bankDisplay = [];
            bankDisplay.addAll(usersFromServer);
          });
        }
      });
    } catch (err) {
      rethrow;
    }
  }

  // fetch position from api
  fetchUserPosition() {
    try {
      _positionService.findAllByUserId(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            positionDisplay = [];
            positionDisplay.add(usersFromServer);
          });
        }
      });
    } catch (err) {
      rethrow;
    }
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('${local?.employeeInfo}'),
      ),
      body: _isloading
          ? _fetchingData(local)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 9, left: 30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _profileImg(context),
                        const SizedBox(
                          width: 20,
                        ),
                        _nameAndID(local, context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _tabViewTitle(local),
                  _tabView(color, context, checkRole, checkSatus)
                ],
              ),
            ),
    );
  }

// tabview widget with personal and employment information
  Container _tabView(
    Color color,
    BuildContext context,
    String checkRole(),
    String checkSatus(),
  ) {
    return Container(
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
                    contextt: context,
                    bankDisplay: bankDisplay,
                    fetchBankData: fetchBankData,
                    userDisplay: userDisplay,
                    user: user,
                    fetchUserById: () {
                      fetchUserById();
                    }),
                EmploymentInfo(
                    contextt: context,
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
                    // checkRate: checkRate,
                    checkRate: () {},
                    addRateList: createRate,
                    deleteRateItem: deleteRateItem,
                    rateNameController: rateNameController,
                    rateScoreController: rateScoreController,
                    idController: idController)
              ],
            ),
          ),
        ));
  }

// tavbar view title/name
  DefaultTabController _tabViewTitle(AppLocalizations? local) {
    return DefaultTabController(
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
    );
  }

// name and id
  Column _nameAndID(AppLocalizations? local, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaselineRow(
          children: [
            Text(
              '${local?.name} : ',
              style: kParagraph.copyWith(fontWeight: FontWeight.bold),
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
              style: kParagraph.copyWith(fontWeight: FontWeight.bold),
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
                                userDisplay[0].imageId == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        )),
                                        child: const Text('No Image'))
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        )),
                                        child: Image.network(
                                          userDisplay[0].imageId.toString(),
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
                                userDisplay[0].imageId == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        )),
                                        child: const Text('No Image'))
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        )),
                                        child: Image.network(
                                          userDisplay[0].imageId.toString(),
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
    );
  }

// profile image
  GestureDetector _profileImg(BuildContext context) {
    return GestureDetector(
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
                                userDisplay[0].image.toString(),
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
            borderRadius: const BorderRadius.all(Radius.circular(100)),
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
    );
  }

// fetching and loading widget
  Center _fetchingData(AppLocalizations? local) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${local?.fetchData}'),
          const CircularProgressIndicator(
            color: kWhite,
          ),
        ],
      ),
    );
  }

// function to create new rate
  createRate() async {
    Rating rate = Rating(
      skillName: rateNameController.text,
      score: int.parse(rateScoreController.text),
      userId: widget.id,
    );
    await _rateServices.createOne(rate);
  }
}
