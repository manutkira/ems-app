import 'package:ems/constants.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_afternoon.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class TapScreen extends StatefulWidget {
  @override
  _TapScreenState createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  int _selectPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  static final List<Widget> _pages = [
    AttendanceByDayScreen(),
    AttendanceByDayAfternoonScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectPageIndex),
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
          currentIndex: _selectPageIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
