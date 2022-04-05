import 'dart:async';
import 'dart:developer';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/loan/loan_record.dart';
import 'package:ems/screens/payroll/generate_screen.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/appbar.dart';
import 'package:ems/widgets/attendance_summary.dart';
import 'package:ems/widgets/check_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'attendances_api/attendance_info.dart';
import 'overtime/individual_overtime_screen.dart';

class HomeScreenEmployee extends ConsumerStatefulWidget {
  const HomeScreenEmployee({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends ConsumerState<HomeScreenEmployee> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOnline = false;
  late StreamSubscription listener;

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
        builder: (_) => AttendancesInfoScreen(
          id: userId,
        ),
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

  @override
  void initState() {
    super.initState();
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      log('CONNECTION STATUS: $status ${status == InternetConnectionStatus.connected}');

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
          "text": local?.myAttendance,
          "icon": 'assets/images/my-attendances.svg',
          "goto": () => _goToMyAttendance(intParse(user.id)),
        },
        {
          "text": local?.myOvertime,
          "icon": 'assets/images/my-overtime.svg',
          "goto": () => _goToMyOvertime(intParse(user.id)),
        },
      ],
      "payrollAndLoan": [
        {
          "text": local?.myPayroll,
          "icon": 'assets/images/my-payroll.svg',
          "goto": () => _goToMyPayroll(intParse(user.id)),
        },
        {
          "text": local?.myLoan,
          "icon": 'assets/images/my-loan.svg',
          "goto": () => _goToMyLoan(intParse(user.id)),
        },
      ],
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
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 15),
                    CheckStatus(),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const AttendanceSummary(),
            ),
            _buildSpacerVertical(),
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                _buildSpacerVertical(),
                _buildTitle('${local?.attendanceAndOvertime}'),
                _buildSpacerVertical(value: 8.0),
                _buildMenuList(menuList['attendanceAndOvertime']!),
                _buildSpacerVertical(),
                _buildTitle('${local?.payrollAndLoan}'),
                _buildSpacerVertical(value: 8.0),
                _buildMenuList(menuList['payrollAndLoan']!),
              ],
            ),

            // /// current user attendance
            // _buildTitle('${local?.attendanceAndOvertime}'),
            // ValueListenableBuilder(
            //     valueListenable:
            //         ref.watch(currentUserProvider).currentUserListenable,
            //     builder: (_, Box<User> box, __) {
            //       final listFromBox = box.values.toList();
            //       final currentUser =
            //           listFromBox.isNotEmpty ? listFromBox[0] : null;
            //       return Container(
            //         height: 170,
            //         padding: const EdgeInsets.symmetric(
            //           vertical: 12,
            //           horizontal: 15,
            //         ),
            //         child: ClipRRect(
            //           borderRadius: const BorderRadius.all(kBorderRadius),
            //           child: Material(
            //             color: kLightBlue,
            //             child: InkWell(
            //               highlightColor: kBlue.withOpacity(0.25),
            //               onTap: () =>
            //                   _goToMyAttendance(currentUser?.id as int),
            //               child: SizedBox(
            //                 width: _size.width,
            //                 child: Container(
            //                   width: double.infinity,
            //                   padding: kPaddingAll,
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       SvgPicture.asset(
            //                         'assets/images/chart.svg',
            //                       ),
            //                       SizedBox(height: isEnglish ? 10 : 2),
            //                       Text(
            //                         "${local?.myAttendance}",
            //                         style: kSubtitle.copyWith(
            //                             color: kBlack,
            //                             fontWeight: FontWeight.w700),
            //                         textAlign: TextAlign.center,
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            // _buildSpacerVertical,
            //
            // /// current user overtime
            // _buildTitle('${local?.payrollAndLoan}'),
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
            //       return ClipRRect(
            //         borderRadius: const BorderRadius.all(kBorderRadius),
            //         child: Material(
            //           color: kLightBlue,
            //           child: InkWell(
            //             highlightColor: kBlue.withOpacity(0.25),
            //             onTap: () => _goToMyOvertime(currentUser),
            //             child: SizedBox(
            //               width: _size.width,
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                   width: double.infinity,
            //                   padding: kPaddingAll,
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       SvgPicture.asset(
            //                         'assets/images/overtime-icon.svg',
            //                         height: 82,
            //                       ),
            //                       SizedBox(height: isEnglish ? 10 : 2),
            //                       Text(
            //                         "${local?.myOvertime}",
            //                         style: kSubtitle.copyWith(
            //                             color: kBlack,
            //                             fontWeight: FontWeight.w700),
            //                         textAlign: TextAlign.center,
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // _buildSpacerVertical,
            //
            // /// payroll
            // _buildTitle('${local?.payroll}'),
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
            //       return ClipRRect(
            //         borderRadius: const BorderRadius.all(kBorderRadius),
            //         child: Material(
            //           color: kLightBlue,
            //           child: InkWell(
            //             highlightColor: kBlue.withOpacity(0.25),
            //             onTap: () => _goToMyPayroll(intParse(currentUser?.id)),
            //             child: SizedBox(
            //               width: _size.width,
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                   width: double.infinity,
            //                   padding: kPaddingAll,
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Image.asset(
            //                         "assets/images/payroll.png",
            //                         height: 82,
            //                       ),
            //                       SizedBox(height: isEnglish ? 10 : 2),
            //                       Text(
            //                         "${local?.myPayroll}",
            //                         style: kSubtitle.copyWith(
            //                             color: kBlack,
            //                             fontWeight: FontWeight.w700),
            //                         textAlign: TextAlign.center,
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // _buildSpacerVertical,
            //
            // /// loan
            // _buildTitle('${local?.loan}'),
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
            //       return ClipRRect(
            //         borderRadius: const BorderRadius.all(kBorderRadius),
            //         child: Material(
            //           color: kLightBlue,
            //           child: InkWell(
            //             highlightColor: kBlue.withOpacity(0.25),
            //             onTap: () => _goToMyLoan(intParse(currentUser?.id)),
            //             child: SizedBox(
            //               width: _size.width,
            //               child: AspectRatio(
            //                 aspectRatio: 1,
            //                 child: Container(
            //                   width: double.infinity,
            //                   padding: kPaddingAll,
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Image.asset(
            //                         "assets/images/loan.png",
            //                         height: 82,
            //                       ),
            //                       SizedBox(height: isEnglish ? 10 : 2),
            //                       Text(
            //                         "${local?.myLoan}",
            //                         style: kSubtitle.copyWith(
            //                             color: kBlack,
            //                             fontWeight: FontWeight.w700),
            //                         textAlign: TextAlign.center,
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // _buildSpacerVertical,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<dynamic> menuItems) {
    bool isEnglish = isInEnglish(context);
    return SizedBox(
      // height: isEnglish ? 135 : 120,
      height: 120,
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: menuItems.map((item) {
          var text = item['text'];
          var icon = item['icon'];
          var goto = item['goto'];
          return _buildMenuCard(text: text, icon: icon, goto: goto);
        }).toList(),
      ),
      // child: ListView.separated(
      //   padding: const EdgeInsets.symmetric(horizontal: 16),
      //   scrollDirection: Axis.horizontal,
      //   physics: const BouncingScrollPhysics(),
      //   itemCount: int.parse(
      //     '${menuItems.length}',
      //   ),
      //   separatorBuilder: (_, __) => const SizedBox(width: 8),
      //   itemBuilder: (builder, index) {
      //     var currentItem = menuItems[index];
      //     var text = currentItem['text'];
      //     var icon = currentItem['icon'];
      //     var goto = currentItem['goto'];
      //     return _buildMenuCard(text: text, icon: icon, goto: goto);
      //   },
      // ),
    );
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
            // width: MediaQuery.of(context).size.width / 2 - (16 * 2 - 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
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
}
