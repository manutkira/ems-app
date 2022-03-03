import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/attendances_screen.dart';
import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/screens/overtime/overtime_screen.dart';
import 'package:ems/screens/payroll/loan/loan_all.dart';
import 'package:ems/screens/payroll/loan/new_loan.dart';
import 'package:ems/screens/payroll/payroll_list_screen.dart';
import 'package:ems/screens/payroll/payroll_screen.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/screens/take_attendance/qr_code_scan.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/appbar.dart';
import 'package:ems/widgets/check_status.dart';
import 'package:ems/widgets/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import 'attendances_api/attendance_info.dart';
import 'overtime/individual_overtime_screen.dart';

class HomeScreenAdmin extends ConsumerStatefulWidget {
  HomeScreenAdmin({Key? key, required this.isOnline}) : super(key: key);
  bool isOnline;
  @override
  ConsumerState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends ConsumerState<HomeScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var time = 'calculating';
  late Timer _timer;

  bool isConnected = false;

  getTime() async {
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time = DateFormat('jm').format(DateTime.now());
        });
      });
    }
  }

  showOfflineSnackbar() {
    AppLocalizations? local = AppLocalizations.of(context);
    SnackBar snackBar = SnackBar(
      backgroundColor: kRedBackground,
      // margin: const EdgeInsets.only(bottom: 16),

      width: MediaQuery.of(context).size.width * 0.92,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Text('${local?.noInternetConnection}'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _goToMyAttendance(int userId) {
    if (!widget.isOnline) {
      showOfflineSnackbar();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AttendancesInfoScreen(id: userId),
      ),
    );
  }

  void _goToMyOvertime(User? currentUser) {
    if (!widget.isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndividualOvertimeScreen(
          user: currentUser as User,
        ),
      ),
    );
  }

  void _goToCheckInScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => TakeAttendanceScreen(isOnline: widget.isOnline),
      ),
    );
  }

  void _goToAttendanceScreen() {
    if (!widget.isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AttendancesScreen(),
      ),
    );
  }

  void _goToOvertimeScreen() {
    if (!widget.isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const OvertimeScreen(),
      ),
    );
  }

  void _goToEmployeeManager() {
    if (!widget.isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EmployeeListScreen(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  checkInternet() async {
    bool status = await InternetConnectionChecker().hasConnection;
    return status;
  }

  @override
  void initState() {
    super.initState();
    getTime();

    // checkConnection();
    // isConnected = ref.watch(connectionStatusProvider);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: EMSAppBar(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: MenuDrawer(isOnline: widget.isOnline),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            /// top
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

                              return Text(
                                "${local?.hello("${currentUser?.name}")}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: isEnglish,
                            child: const SizedBox(height: 5),
                          ),
                          Text(
                            "${local?.timeText(
                              time,
                              getDateStringFromDateTime(
                                DateTime.now(),
                              ),
                            )}",
                            style: kSubtitleTwo,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isEnglish ? 30 : 25),
                    CheckStatus(isOnline: widget.isOnline),
                  ],
                ),
              ],
            ),

            /// check in/out
            // _buildTitle('${local?.checkInOut}'),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
              child: GestureDetector(
                onTap: _goToCheckInScreen,
                child: SizedBox(
                  width: _size.width,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: kLightBlue,
                        borderRadius: BorderRadius.all(kBorderRadius),
                      ),
                      padding: kPaddingAll,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/scan-qr-code-icon.svg",
                            height: 100,
                          ),
                          Text(
                            "${local?.checkInOut}",
                            style: kSubtitle.copyWith(
                              color: kBlack,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildSpacerVertical,

            /// current user attendance
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PayrollListScreen()));
              },
              child: _buildTitle(
                '${local?.attendance}',
              ),
            ),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: ValueListenableBuilder(
                  valueListenable:
                      ref.watch(currentUserProvider).currentUserListenable,
                  builder: (_, Box<User> box, __) {
                    final listFromBox = box.values.toList();
                    final currentUser =
                        listFromBox.isNotEmpty ? listFromBox[0] : null;
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: _goToAttendanceScreen,
                            illustration: SvgPicture.asset(
                              "assets/images/calendar.svg",
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            label: "${local?.attendanceManager}",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: () =>
                                _goToMyAttendance(currentUser?.id as int),
                            illustration: SvgPicture.asset(
                              "assets/images/user.svg",
                              width: MediaQuery.of(context).size.width * 0.17,
                            ),
                            label: "${local?.myAttendance}",
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            _buildSpacerVertical,

            /// current user overtime
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoanAll(),
                ),
              ),
              child: _buildTitle('${local?.overtime}'),
            ),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
              child: ValueListenableBuilder(
                valueListenable:
                    ref.watch(currentUserProvider).currentUserListenable,
                builder: (_, Box<User> box, __) {
                  final listFromBox = box.values.toList();
                  final currentUser =
                      listFromBox.isNotEmpty ? listFromBox[0] : null;

                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: MenuItem(
                          onTap: _goToOvertimeScreen,
                          illustration: SvgPicture.asset(
                            "assets/images/overtime-icon.svg",
                            width: MediaQuery.of(context).size.width * 0.17,
                          ),
                          label: "${local?.overtimeManager}",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: MenuItem(
                          onTap: () => _goToMyOvertime(currentUser),
                          illustration: SvgPicture.asset(
                            "assets/images/user.svg",
                            width: MediaQuery.of(context).size.width * 0.17,
                          ),
                          label: "${local?.myOvertime}",
                        ),
                      ),
                    ],
                  );
                  // return GestureDetector(
                  //   onTap: () => _goToMyOvertime(currentUser),
                  //   child: SizedBox(
                  //     width: _size.width,
                  //     child: AspectRatio(
                  //       aspectRatio: 1,
                  //       child: Container(
                  //         width: double.infinity,
                  //         decoration: const BoxDecoration(
                  //           color: kLightBlue,
                  //           borderRadius: BorderRadius.all(kBorderRadius),
                  //         ),
                  //         padding: kPaddingAll,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             SvgPicture.asset(
                  //               'assets/images/overtime-icon.svg',
                  //               height: 82,
                  //             ),
                  //             SizedBox(height: isEnglish ? 10 : 2),
                  //             Text(
                  //               "${local?.myOvertime}",
                  //               style: kSubtitle.copyWith(
                  //                   color: kBlack, fontWeight: FontWeight.w700),
                  //               textAlign: TextAlign.center,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
            _buildSpacerVertical,

            /// current user overtime
            _buildTitle('${local?.employee}'),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
              child: GestureDetector(
                onTap: _goToEmployeeManager,
                child: SizedBox(
                  width: _size.width,
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
                            'assets/images/employees-group.svg',
                            height: 82,
                          ),
                          SizedBox(height: isEnglish ? 10 : 2),
                          Text(
                            "${local?.employeeManager}",
                            style: kSubtitle.copyWith(
                                color: kBlack, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildSpacerVertical,
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget get _buildSpacerVertical {
    return const SizedBox(height: 10);
  }
}
