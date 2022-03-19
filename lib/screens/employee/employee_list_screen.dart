// ignore_for_file: use_key_in_widget_constructors

import 'package:ems/screens/employee/widgets/employee_list/employee_list.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  static const routeName = '/employee-list';
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 9, child: EmployeeList()),
        ],
      ),
    );
  }
}
