import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/attendances_screen.dart';
import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/screens/loan/loan_all.dart';
import 'package:ems/screens/loan/loan_record.dart';
import 'package:ems/screens/overtime/overtime_screen.dart';
import 'package:ems/screens/payroll/generate_screen.dart';
import 'package:ems/screens/payroll/payroll_list_screen.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/screens/take_attendance/qr_code_scan.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/appbar.dart';
import 'package:ems/widgets/check_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'attendances_api/attendance_info.dart';
import 'overtime/individual_overtime_screen.dart';

class HomeScreenAdmin extends ConsumerStatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends ConsumerState<HomeScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription listener;
  bool isOnline = false;

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
    if (!isOnline) {
      showOfflineSnackbar();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AttendancesInfoScreen(id: userId),
      ),
    );
  }

  void _gotoPayroll() {
    if (!isOnline) {
      showOfflineSnackbar();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PayrollListScreen(),
      ),
    );
  }

  void _goToLoan() {
    if (!isOnline) {
      showOfflineSnackbar();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoanAll(),
      ),
    );
  }

  void _goToMyOvertime(User? currentUser) {
    if (!isOnline) {
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

  void _goToMyPayroll(int id) {
    if (!isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GeneratePaymentScreen(
          id: id,
        ),
      ),
    );
  }

  void _goToMyLoan(int id) {
    if (!isOnline) {
      showOfflineSnackbar();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoanRecord(
          id: id.toString(),
        ),
      ),
    );
  }

  void _goToCheckInScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => TakeAttendanceScreen(isOnline: isOnline),
      ),
    );
  }

  void _goToAttendanceScreen() {
    if (!isOnline) {
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
    if (!isOnline) {
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
    if (!isOnline) {
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

  @override
  void initState() {
    super.initState();
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      // log('CONNECTION STATUS: $status ${status == InternetConnectionStatus.connected}');

      setState(() {
        isOnline = status == InternetConnectionStatus.connected;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await listener.cancel();
  }

  Map<String, List<dynamic>> get menuList {
    AppLocalizations? local = AppLocalizations.of(context);
    User user = ref.read(currentUserProvider).user;
    return {
      "attendanceAndOvertime": [
        {
          "text": local?.attendanceManager,
          "icon": 'assets/images/attendance.svg',
          "goto": () => _goToAttendanceScreen(),
        },
        {
          "text": local?.myAttendance,
          "icon": 'assets/images/my-attendances.svg',
          "goto": () => _goToMyAttendance(intParse(user.id)),
        },
        {
          "text": local?.overtimeManager,
          "icon": "assets/images/overtime.svg",
          "goto": () => _goToOvertimeScreen(),
        },
        {
          "text": local?.myOvertime,
          "icon": 'assets/images/my-overtime.svg',
          "goto": () => _goToMyOvertime(intParse(user.id)),
        },
      ],
      "payrollAndLoan": [
        {
          "text": local?.payroll,
          "icon": "assets/images/payroll.svg",
          "goto": () => _gotoPayroll(),
        },
        {
          "text": local?.myPayroll,
          "icon": 'assets/images/my-payroll.svg',
          "goto": () => _goToMyPayroll(intParse(user.id)),
        },
        {
          "text": local?.loan,
          "icon": "assets/images/loan.svg",
          "goto": () => _goToLoan(),
        },
        {
          "text": local?.myLoan,
          "icon": 'assets/images/my-loan.svg',
          "goto": () => _goToMyLoan(intParse(user.id)),
        },
      ],
      "employees": [
        {
          "text": local?.employeeManager,
          "icon": 'assets/images/employees.svg',
          "goto": () => _goToEmployeeManager(),
        }
      ]
    };
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
      drawer: MenuDrawer(),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            /// top
            Stack(
              children: [
                SizedBox(
                  height: 140,
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
                  children: const [
                    SizedBox(height: 20),
                    CheckStatus(),
                  ],
                ),
              ],
            ),

            /// check in/out
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(
                // vertical: 12,
                horizontal: 15,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(kBorderRadius),
                child: Material(
                  color: kLightBlue,
                  child: InkWell(
                    highlightColor: kBlue.withOpacity(0.25),
                    onTap: _goToCheckInScreen,
                    child: SizedBox(
                      width: _size.width,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          width: double.infinity,
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
              ),
            ),
            _buildSpacerVertical(),

            ValueListenableBuilder(
                valueListenable:
                    ref.watch(currentUserProvider).currentUserListenable,
                builder: (_, Box<User> box, __) {
                  final listFromBox = box.values.toList();
                  final currentUser =
                      listFromBox.isNotEmpty ? listFromBox[0] : null;
                  return ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildTitle('${local?.attendanceAndOvertime}'),
                      _buildSpacerVertical(value: 8.0),
                      _buildMenuList(menuList['attendanceAndOvertime']!),
                      _buildSpacerVertical(),
                      _buildTitle('${local?.payrollAndLoan}'),
                      _buildSpacerVertical(value: 8.0),
                      _buildMenuList(menuList['payrollAndLoan']!),
                      _buildSpacerVertical(),
                      _buildTitle('${local?.employeeManager}'),
                      _buildSpacerVertical(value: 8.0),
                      _buildMenuList(menuList['employees']!)
                    ],
                  );
                }),
            _buildSpacerVertical(),
            // grid
            // ValueListenableBuilder(
            //   valueListenable:
            //       ref.watch(currentUserProvider).currentUserListenable,
            //   builder: (_, Box<User> box, __) {
            //     final listFromBox = box.values.toList();
            //     final currentUser =
            //         listFromBox.isNotEmpty ? listFromBox[0] : null;
            //     return Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(16),
            //         child: GridView.count(
            //           shrinkWrap: true,
            //           physics: const ClampingScrollPhysics(),
            //           // padding: const EdgeInsets.symmetric(horizontal: 16),
            //           crossAxisCount: 3,
            //           crossAxisSpacing: 1,
            //           mainAxisSpacing: 1,
            //           children: [
            //             MenuItem(
            //               onTap: _goToAttendanceScreen,
            //               illustration: SvgPicture.asset(
            //                 "assets/images/calendar.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.attendanceManager}",
            //             ),
            //             MenuItem(
            //               onTap: () =>
            //                   _goToMyAttendance(currentUser?.id as int),
            //               illustration: SvgPicture.asset(
            //                 "assets/images/my-attendances.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.myAttendance}",
            //             ),
            //             MenuItem(
            //               onTap: _goToOvertimeScreen,
            //               illustration: SvgPicture.asset(
            //                 "assets/images/overtime-icon.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.overtimeManager}",
            //             ),
            //             MenuItem(
            //               onTap: () => _goToMyOvertime(currentUser),
            //               illustration: SvgPicture.asset(
            //                 "assets/images/my-overtime.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.myOvertime}",
            //             ),
            //             MenuItem(
            //               onTap: _gotoPayroll,
            //               illustration: Image.asset(
            //                 "assets/images/payroll.png",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.payroll}",
            //             ),
            //             MenuItem(
            //               onTap: () =>
            //                   _goToMyPayroll(intParse(currentUser?.id)),
            //               illustration: SvgPicture.asset(
            //                 "assets/images/my-payroll.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.myPayroll}",
            //             ),
            //             MenuItem(
            //               onTap: _goToLoan,
            //               illustration: Image.asset(
            //                 "assets/images/loan.png",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.loan}",
            //             ),
            //             MenuItem(
            //               onTap: () => _goToMyLoan(intParse(currentUser?.id)),
            //               illustration: SvgPicture.asset(
            //                 "assets/images/my-loan.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.myLoan}",
            //             ),
            //             MenuItem(
            //               onTap: _goToEmployeeManager,
            //               illustration: SvgPicture.asset(
            //                 'assets/images/employees-group.svg',
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.employeeManager}",
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // old old
            //
            // /// current user attendance
            // _buildTitle('${local?.attendance}'),
            // Container(
            //   height: 170,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 15,
            //     vertical: 12,
            //   ),
            //   child: ValueListenableBuilder(
            //       valueListenable:
            //           ref.watch(currentUserProvider).currentUserListenable,
            //       builder: (_, Box<User> box, __) {
            //         final listFromBox = box.values.toList();
            //         final currentUser =
            //             listFromBox.isNotEmpty ? listFromBox[0] : null;
            //         return Row(
            //           children: [
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: _goToAttendanceScreen,
            //                 illustration: SvgPicture.asset(
            //                   "assets/images/calendar.svg",
            //                   width: MediaQuery.of(context).size.width * 0.15,
            //                 ),
            //                 label: "${local?.attendanceManager}",
            //               ),
            //             ),
            //             const SizedBox(width: 15),
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: () =>
            //                     _goToMyAttendance(currentUser?.id as int),
            //                 illustration: SvgPicture.asset(
            //                   "assets/images/my_attendances.svg",
            //                   width: MediaQuery.of(context).size.width * 0.17,
            //                 ),
            //                 label: "${local?.myAttendance}",
            //               ),
            //             ),
            //           ],
            //         );
            //       }),
            // ),
            // _buildSpacerVertical(),
            //
            // /// current user overtime
            // _buildTitle('${local?.overtime}'),
            // Container(
            //   height: 170,
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 12,
            //     horizontal: 15,
            //   ),
            //   child: ValueListenableBuilder(
            //     valueListenable:
            //         ref.watch(currentUserProvider).currentUserListenable,
            //     builder: (_, Box<User> box, __) {
            //       final listFromBox = box.values.toList();
            //       final currentUser =
            //           listFromBox.isNotEmpty ? listFromBox[0] : null;
            //
            //       return Row(
            //         children: [
            //           Expanded(
            //             flex: 1,
            //             child: MenuItem(
            //               onTap: _goToOvertimeScreen,
            //               illustration: SvgPicture.asset(
            //                 "assets/images/overtime-icon.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.overtimeManager}",
            //             ),
            //           ),
            //           const SizedBox(width: 15),
            //           Expanded(
            //             flex: 1,
            //             child: MenuItem(
            //               onTap: () => _goToMyOvertime(currentUser),
            //               illustration: SvgPicture.asset(
            //                 "assets/images/my_attendances.svg",
            //                 width: MediaQuery.of(context).size.width * 0.17,
            //               ),
            //               label: "${local?.myOvertime}",
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            // _buildSpacerVertical(),
            //
            // /// payroll
            // _buildTitle('${local?.payroll}'),
            // Container(
            //   height: 170,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 15,
            //     vertical: 12,
            //   ),
            //   child: ValueListenableBuilder(
            //       valueListenable:
            //           ref.watch(currentUserProvider).currentUserListenable,
            //       builder: (_, Box<User> box, __) {
            //         final listFromBox = box.values.toList();
            //         final currentUser =
            //             listFromBox.isNotEmpty ? listFromBox[0] : null;
            //         return Row(
            //           children: [
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: _gotoPayroll,
            //                 illustration: Image.asset(
            //                   "assets/images/payroll.png",
            //                   width: MediaQuery.of(context).size.width * 0.25,
            //                 ),
            //                 label: "${local?.payroll}",
            //               ),
            //             ),
            //             const SizedBox(width: 15),
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: () =>
            //                     _goToMyPayroll(intParse(currentUser?.id)),
            //                 illustration: SvgPicture.asset(
            //                   "assets/images/my_attendances.svg",
            //                   width: MediaQuery.of(context).size.width * 0.17,
            //                 ),
            //                 label: "${local?.myPayroll}",
            //               ),
            //             ),
            //           ],
            //         );
            //       }),
            // ),
            // _buildSpacerVertical(),
            //
            // /// loan
            // _buildTitle('${local?.loan}'),
            // Container(
            //   height: 170,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 15,
            //     vertical: 12,
            //   ),
            //   child: ValueListenableBuilder(
            //       valueListenable:
            //           ref.watch(currentUserProvider).currentUserListenable,
            //       builder: (_, Box<User> box, __) {
            //         final listFromBox = box.values.toList();
            //         final currentUser =
            //             listFromBox.isNotEmpty ? listFromBox[0] : null;
            //         return Row(
            //           children: [
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: _goToLoan,
            //                 illustration: Image.asset(
            //                   "assets/images/loan.png",
            //                   width: MediaQuery.of(context).size.width * 0.20,
            //                 ),
            //                 label: "${local?.loan}",
            //               ),
            //             ),
            //             const SizedBox(width: 15),
            //             Expanded(
            //               flex: 1,
            //               child: MenuItem(
            //                 onTap: () => _goToMyLoan(intParse(currentUser?.id)),
            //                 illustration: SvgPicture.asset(
            //                   "assets/images/my_attendances.svg",
            //                   width: MediaQuery.of(context).size.width * 0.17,
            //                 ),
            //                 label: "${local?.myLoan}",
            //               ),
            //             ),
            //           ],
            //         );
            //       }),
            // ),
            // _buildSpacerVertical(),
            //
            // /// current user overtime
            // _buildTitle('${local?.employee}'),
            // Container(
            //   height: 170,
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 12,
            //     horizontal: 15,
            //   ),
            //   child: GestureDetector(
            //     onTap: _goToEmployeeManager,
            //     child: SizedBox(
            //       width: _size.width,
            //       child: AspectRatio(
            //         aspectRatio: 1,
            //         child: Container(
            //           width: double.infinity,
            //           decoration: const BoxDecoration(
            //             color: kLightBlue,
            //             borderRadius: BorderRadius.all(kBorderRadius),
            //           ),
            //           padding: kPaddingAll,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               SvgPicture.asset(
            //                 'assets/images/employees-group.svg',
            //                 height: 82,
            //               ),
            //               SizedBox(height: isEnglish ? 10 : 2),
            //               Text(
            //                 "${local?.employeeManager}",
            //                 style: kSubtitle.copyWith(
            //                     color: kBlack, fontWeight: FontWeight.w700),
            //                 textAlign: TextAlign.center,
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // _buildSpacerVertical(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<dynamic> menuItems) {
    bool isEnglish = isInEnglish(context);
    return SizedBox(
      height: isEnglish ? 135 : 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: int.parse(
          '${menuItems.length}',
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (builder, index) {
          var currentItem = menuItems[index];
          var text = currentItem['text'];
          var icon = currentItem['icon'];
          var goto = currentItem['goto'];
          return _buildMenuCard(text: text, icon: icon, goto: goto);
        },
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

  Widget _buildSpacerVertical({value = 16.0}) {
    return SizedBox(height: value);
  }

  Widget _buildMenuCard(
      {required String text, required String icon, required Function() goto}) {
    bool isSvg = icon.substring(icon.length - 3) == 'svg';
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: kLightBlue,
        child: InkWell(
          highlightColor: kBlue.withOpacity(0.25),
          onTap: goto,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // color: kLightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isSvg
                    ? SvgPicture.asset(
                        icon,
                        width: MediaQuery.of(context).size.width * 0.2,
                      )
                    : Image.asset(
                        icon,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Text(
                    text,
                    style: kSubtitle.copyWith(
                      fontSize: 12,
                      color: kBlack,
                      fontWeight: FontWeight.w700,
                      height: 1.7,
                      // overflow: TextOverflow.visible,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
