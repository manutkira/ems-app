import 'package:ems/widgets/employee_list.dart';
import 'package:flutter/material.dart';

import '../widgets/indi_employee.dart';
import '../main.dart';
import '../dummy_data.dart';

class EmployeeInfo extends StatelessWidget {
  static const routeName = '/employee-info';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final employeeId = routeArgs['id'];
    final employeeName = routeArgs['name'];
    final employeeInfo = indiEmployee.where((info) {
      return info.id.contains(employeeId);
    }).toList();
    final color = const Color(0xff05445E);
    final bColor = const Color(0xff05445E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bColor,
        title: Text('Employee'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: Container(
        color: color,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return IndiEmployee(
              name: employeeInfo[index].name,
              id: employeeInfo[index].id,
              date: employeeInfo[index].date,
              skill: employeeInfo[index].skill,
              workRate: employeeInfo[index].workRate,
              contact: employeeInfo[index].contact,
              background: employeeInfo[index].background,
            );
          },
          itemCount: employeeInfo.length,
        ),
      ),
    );
  }
}
