import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/screens/take_attendance/check_in_screen.dart';
import 'package:ems/screens/take_attendance/check_out_screen.dart';
import 'package:ems/screens/test_attendances.dart';
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
  late Timer _timer;

  getTime() async {
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time = DateFormat('jm').format(DateTime.now());
        });
      });
    }
  }

  void _goToMyAttendance(int userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AttendancesInfoScreen(userId),
      ),
    );
  }

  void _goToMyOvertime(User? currentUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndividualOvertimeScreen(
          user: currentUser as User,
        ),
      ),
    );
  }

  void _goToCheckoutScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const CheckOutScreen(),
      ),
    );
  }

  void _goToCheckInScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const CheckInScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

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
                            "${local?.timeText(time, getDateStringFromDateTime(DateTime.now()))}",
                            style: kSubtitleTwo,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isEnglish ? 30 : 25),
                    const CheckStatus(),
                  ],
                ),
              ],
            ),
            _buildSpacerVertical,

            /// check in/out
            _buildTitle('${local?.checkInOut}'),
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MenuItem(
                      onTap: _goToCheckInScreen,
                      illustration: SvgPicture.asset(
                        "assets/images/tick.svg",
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      label: "${local?.checkin}",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: MenuItem(
                      onTap: _goToCheckoutScreen,
                      illustration: SvgPicture.asset(
                        "assets/images/close.svg",
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      label: "${local?.checkout}",
                    ),
                  ),
                ],
              ),
            ),
            _buildSpacerVertical,

            /// current user attendance
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => TestAttendances()));
              },
              child: _buildTitle('${local?.attendance}'),
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
                      vertical: 12,
                      horizontal: 15,
                    ),
                    child: GestureDetector(
                      onTap: () => _goToMyAttendance(currentUser?.id as int),
                      child: SizedBox(
                        width: _size.width,
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
                              SizedBox(height: isEnglish ? 10 : 2),
                              Text(
                                "${local?.myAttendance}",
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
                }),
            _buildSpacerVertical,

            /// current user overtime
            _buildTitle('${local?.overtime}'),
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

                  return GestureDetector(
                    onTap: () => _goToMyOvertime(currentUser),
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
                                'assets/images/overtime-icon.svg',
                                height: 82,
                              ),
                              SizedBox(height: isEnglish ? 10 : 2),
                              Text(
                                "${local?.myOvertime}",
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
