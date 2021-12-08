import 'package:ems/screens/attendance/attendance_by_alltime_screen.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_all_time_afternoon.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class TapScreenAlltime extends StatefulWidget {
  @override
  _TapScreenAlltimeState createState() => _TapScreenAlltimeState();
}

class _TapScreenAlltimeState extends State<TapScreenAlltime> {
  int selectPageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onTapPageIndex(int index) {
    setState(() {
      selectPageIndex = index;
    });
  }

  static final List<Widget> _pages = [
    AttendanceAllTimeScreen(),
    AttendanceAllTimeScreenAfternoon(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(selectPageIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BottomNavigationBar(
          elevation: 15,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.sunrise,
              ),
              title: Text(
                'Morning',
                style: TextStyle(color: kWhite),
              ),
            ),
            BottomNavigationBarItem(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        TablerIcons.sun,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                'Afternoon',
                style: TextStyle(color: kWhite),
              ),
            ),
          ],
          currentIndex: selectPageIndex,
          onTap: _onTapPageIndex,
        ),
      ),
    );
  }
}
