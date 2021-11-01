import 'package:flutter/material.dart';

import '../../dummy_data.dart';
import '../../constants.dart';
import '../../screens/attendance/individual_attendance.dart';

class AttendanceAllTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: attendanceHistory.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(bottom: 20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            IndividualAttendanceScreen.routeName,
                            arguments: {'id': attendanceHistory[index].id});
                      },
                      child: Image.asset(
                        'assets/images/profile-icon-png-910.png',
                        width: 85,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              attendanceHistory[index].name,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'ID: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(attendanceHistory[index].id),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 125,
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'P: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  attendanceHistory[index]
                                      .totalPresent
                                      .toString(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'PM: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  attendanceHistory[index]
                                      .totalPermission
                                      .toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'A: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  attendanceHistory[index]
                                      .totalAbsent
                                      .toString(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'L: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  attendanceHistory[index].totalLate.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
