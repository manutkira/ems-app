import 'package:ems/screens/attendance/individual_attendance.dart';
import 'package:ems/screens/edit_employee.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:ems/widgets/employee_info.dart';
import 'package:flutter/material.dart';

import './constants.dart';
import './models/employee.dart';
import './widgets/employee_list.dart';
import './widgets/new_employee.dart';
import './widgets/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        // dialogBackgroundColor: kBlue,
        dialogTheme: DialogTheme(
          titleTextStyle: kHeadingThree,
          backgroundColor: kDarkestBlue,
          contentTextStyle: kParagraph,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: kWhite,
          selectionColor: kBlack.withOpacity(0.25),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle:
              kSubtitle.copyWith(color: kSubtitle.color!.withOpacity(0.5)),
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: Colors.black.withOpacity(0.25),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(kBorderRadius),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(kBorderRadius),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            primary: kWhite,
            backgroundColor: kBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        colorScheme: const ColorScheme(
          primary: kBlue,
          primaryVariant: kDarkestBlue,
          secondary: kBlue,
          secondaryVariant: kLightBlue,
          surface: kBlue,
          background: kBlue,
          error: kRedText,
          onPrimary: kWhite,
          onSecondary: kWhite,
          onSurface: kWhite,
          onBackground: kWhite,
          onError: kWhite,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          headline1: kHeadingOne,
          headline2: kHeadingTwo,
          headline3: kHeadingThree,
          headline4: kHeadingFour,
          caption: kParagraph,
          bodyText1: kParagraph,
          subtitle1: kSubtitle,
        ),
        scaffoldBackgroundColor: kBlue,
        appBarTheme: AppBarTheme(
          backgroundColor: kBlue,
          titleTextStyle: kHeadingTwo,
          elevation: 0,
        ),
      ),
      home: LoginScreen(),
      routes: {
        EmployeeInfo.routeName: (ctx) => EmployeeInfo(),
        EditEmployeeScreen.routeName: (ctx) => EditEmployeeScreen(),
        IndividualAttendanceScreen.routeName: (ctx) =>
            IndividualAttendanceScreen(),
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
    Employee(
        name: 'Song',
        id: '2',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 321,
        workRate: 'normal',
        contact: 012345678,
        background: '3 months experience'),
    Employee(
        name: 'Sunny',
        id: '3',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 123,
        workRate: 'normal',
        contact: 011265895,
        background: '3 months experience'),
    Employee(
        name: 'Song',
        id: '4',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 321,
        workRate: 'normal',
        contact: 012345678,
        background: '3 months experience'),
    Employee(
        name: 'Manut',
        id: '5',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 123,
        workRate: 'normal',
        contact: 011265895,
        background: '3 months experience'),
    Employee(
        name: 'Song',
        id: '6',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 321,
        workRate: 'normal',
        contact: 012345678,
        background: '3 months experience'),
    Employee(
        name: 'Manut',
        id: '7',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 123,
        workRate: 'normal',
        contact: 011265895,
        background: '3 months experience'),
    Employee(
        name: 'Song',
        id: '8',
        date: '1-2-2001',
        skill: 'mobile app developer',
        salary: 321,
        workRate: 'normal',
        contact: 012345678,
        background: '3 months experience'),
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
