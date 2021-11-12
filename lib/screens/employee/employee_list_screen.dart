import 'package:ems/screens/home_screen.dart';
import 'package:ems/widgets/employee/employee_list.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../constants.dart';
import '../../screens/employee/new_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  static const routeName = '/employee-list';
  final color = const Color(0xff05445E);

  final color1 = const Color(0xff3B9AAD);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => NewEmployeeScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   padding: EdgeInsets.all(10),
          //   child: Expanded(
          //       flex: 1,
          //       child: Text(
          //         'Employee List',
          //         style: kHeadingTwo,
          //       )),
          // ),
          Expanded(flex: 9, child: EmployeeList()),
        ],
      ),
    );
  }
}
