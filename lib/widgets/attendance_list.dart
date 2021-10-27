import 'package:ems/widgets/attendance_item.dart';
import 'package:flutter/material.dart';

import '../dummy_data.dart';

class AttendanceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
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
                    Image.asset(
                      'assets/images/profile-icon-png-910.png',
                      width: 85,
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: attendanceHistory[index].bgColor),
                  alignment: Alignment.center,
                  width: 98,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    attendanceHistory[index].status,
                    style: TextStyle(
                        color: attendanceHistory[index].textColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        });
  }
}
