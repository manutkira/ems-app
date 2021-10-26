import 'dart:math';

import 'package:ems/widgets/employee_info.dart';
import 'package:flutter/material.dart';

import './models/employee.dart';
import './widgets/employee_list.dart';
import './widgets/search.dart';
import './widgets/new_employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        EmployeeInfo.routeName: (ctx) => EmployeeInfo(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final color = const Color(0xff05445E);
  final List<Employee> _employeeList = [
    Employee(
        name: 'Manut',
        id: '1',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 123,
        workRate: 'normal',
        contact: 011265895,
        background: '3 months experience'),
    // Employee(
    //     name: 'Song',
    //     id: '2',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 321,
    //     workRate: 'normal',
    //     contact: 012345678,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Sunny',
    //     id: '3',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 123,
    //     workRate: 'normal',
    //     contact: 011265895,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Song',
    //     id: '4',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 321,
    //     workRate: 'normal',
    //     contact: 012345678,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Manut',
    //     id: '5',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 123,
    //     workRate: 'normal',
    //     contact: 011265895,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Song',
    //     id: '6',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 321,
    //     workRate: 'normal',
    //     contact: 012345678,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Manut',
    //     id: '7',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 123,
    //     workRate: 'normal',
    //     contact: 011265895,
    //     background: '3 months experience'),
    // Employee(
    //     name: 'Song',
    //     id: '8',
    //     date: '1-2-2001',
    //     skill: 'mobile app developer',
    //     salary: 321,
    //     workRate: 'normal',
    //     contact: 012345678,
    // background: '3 months experience'),
  ];

  void _addNewEmployee(
    String eName,
    String eId,
    String eDate,
    String eSkill,
    double eSalary,
    String eworkRate,
    int eContact,
    String eBackground,
  ) {
    final newEm = Employee(
      name: eName,
      id: eId,
      date: eDate,
      skill: eSkill,
      salary: eSalary,
      workRate: eworkRate,
      contact: eContact,
      background: eBackground,
    );
    setState(() {
      _employeeList.add(newEm);
    });
  }

  void _startAddNewEmployee(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return GestureDetector(
            child: NewEmployee(_addNewEmployee),
            onTap: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: color,
          actions: [
            IconButton(
                onPressed: () => _startAddNewEmployee(context),
                icon: Icon(Icons.add_circle_outline))
          ],
          title: Text('Employee'),
        ),
        body: Stack(
          children: [
            Container(child: animationSearchBar()),
            EmployeeList(_employeeList)
          ],
        ));
  }
}
