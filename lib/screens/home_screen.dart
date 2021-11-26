import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/attendances_screen.dart';
import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/screens/take_attendance/check_in_screen.dart';
import 'package:ems/screens/take_attendance/check_out_screen.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/widgets/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var time = 'calculating';
  dynamic employeeCount = "loading...";
  late Timer _timer;
  final UserService _userService = UserService.instance;

  // Get total employee counts
  getCount() async {
    var c = await _userService.count();
    if (mounted) {
      setState(() {
        employeeCount = c;
      });
    }
  }

  getTime() async {
    if (!mounted) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time = DateFormat('jm').format(DateTime.now());
      });
    });
  }

  @override
  void initState() {
    // "It's ${DateFormat('jm').format(DateTime.now())} on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
    super.initState();
    getCount();
    getTime();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar,
      drawer: MenuDrawer(),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _size.height,
          child: ListView(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: _size.width,
                    child: SvgPicture.asset(
                      'assets/images/graph.svg',
                      semanticsLabel: "menu",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: ref
                                  .watch(currentUserProvider)
                                  .currentUserListenable,
                              builder: (_, Box<User> box, __) {
                                final currentUser = box.values.toList()[0];
                                return Text(
                                  "Hello, ${currentUser.name}",
                                  style: kHeadingFour,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "It's $time on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}.",
                              style: kSubtitleTwo,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EmployeeListScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: kPaddingAll.copyWith(top: 30, bottom: 30),
                          margin: kPaddingAll,
                          width: _size.width,
                          decoration: const BoxDecoration(
                            color: kLightBlue,
                            borderRadius: BorderRadius.all(kBorderRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 75,
                                child: Image.asset(
                                  "assets/images/profile-icon-png-910.png",
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$employeeCount',
                                    style: kHeadingOne.copyWith(
                                        color: kBlack, fontSize: 32),
                                  ),
                                  Text(
                                    'employees',
                                    style: kSubtitle.copyWith(color: kBlack),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: kPaddingAll,
                width: double.infinity,
                height: _size.height * .60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kDarkestBlue,
                      kDarkestBlue,
                      kBlue,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Check in / Checkout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: () {
                              getCount();
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const CheckInScreen(),
                                ),
                              );
                            },
                            illustration:
                                SvgPicture.asset("assets/images/tick.svg"),
                            label: "Check In",
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const CheckOutScreen(),
                                ),
                              );
                            },
                            illustration:
                                SvgPicture.asset("assets/images/close.svg"),
                            label: "Check out",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Attendance history
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AttendancesScreen(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: _size.width,
                        height: 175,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: kLightBlue,
                              borderRadius: BorderRadius.all(kBorderRadius),
                            ),
                            padding: kPaddingAll,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/chart.svg',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Attendance History",
                                  style: kSubtitle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      leading: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        child: Container(
          padding: kPaddingAll,
          child: SvgPicture.asset(
            'assets/images/menuburger.svg',
            semanticsLabel: "menu",
          ),
        ),
      ),
      title: const Text('Internal EMS'),
    );
  }
}
