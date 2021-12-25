import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/overtime/overtime_screen.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/screens/take_attendance/check_in_screen.dart';
import 'package:ems/screens/take_attendance/check_out_screen.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/widgets/check_status.dart';
import 'package:ems/widgets/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'attendances_api/attendance_info.dart';
import 'overtime/individual_overtime_screen.dart';

class HomeScreenEmployee extends ConsumerStatefulWidget {
  const HomeScreenEmployee({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends ConsumerState<HomeScreenEmployee> {
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
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time = DateFormat('jm').format(DateTime.now());
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCount();
    getTime();
  }

  @override
  void dispose() {
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
        child: ListView(
          children: [
            // top
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 25),
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
                              final listFromBox = box.values.toList();
                              final currentUser = listFromBox.isNotEmpty
                                  ? listFromBox[0]
                                  : null;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const OvertimeScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Hello, ${currentUser?.name}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "It's $time on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}.",
                            style: kSubtitleTwo,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    CheckStatus(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),

            // check in/out
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                'Check In/Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
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
                      illustration: SvgPicture.asset("assets/images/tick.svg"),
                      label: "Check In",
                    ),
                  ),
                  const SizedBox(width: 15),
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
                      illustration: SvgPicture.asset("assets/images/close.svg"),
                      label: "Check out",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // current user attendance
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable:
                    ref.watch(currentUserProvider).currentUserListenable,
                builder: (_, Box<User> box, __) {
                  final listFromBox = box.values.toList();
                  final currentUser =
                      listFromBox.isNotEmpty ? listFromBox[0] : null;
                  return Container(
                    height: 170,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AttendancesInfoScreen(currentUser?.id as int),
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
                                  "My Attendance",
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
                  );
                }),
            const SizedBox(height: 15),

            // current user overtime
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                'Overtime',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: ValueListenableBuilder(
                valueListenable:
                    ref.watch(currentUserProvider).currentUserListenable,
                builder: (_, Box<User> box, __) {
                  final listFromBox = box.values.toList();
                  final currentUser =
                      listFromBox.isNotEmpty ? listFromBox[0] : null;

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IndividualOvertimeScreen(
                          user: currentUser as User,
                        ),
                      ),
                    ),
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
                                'assets/images/overtime-icon.svg',
                                height: 82,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "My Overtime",
                                style: kSubtitle.copyWith(
                                    color: kBlack, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
