import 'dart:async';

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

  // menu map used to populate the menu lists
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
          "goto": () => _goToMyOvertime(user),
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: EMSAppBar(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const MenuDrawer(),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            // status
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

            // stats
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const AttendanceSummary(),
            ),
            _buildSpacerVertical(),

            // menu
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
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<dynamic> menuItems) {
    return SizedBox(
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
