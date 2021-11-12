import 'package:ems/screens/attendance/individual_attendance.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:flutter/material.dart';

import './constants.dart';
import './models/employee.dart';
import './widgets/new_employee.dart';
import './widgets/search.dart';
import './screens/employee/employee_list_screen.dart';

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
        IndividualAttendanceScreen.routeName: (ctx) =>
            IndividualAttendanceScreen(),
        // EmployeeEditScreen.routeName: (ctx) => EmployeeEditScreen(),
        EmployeeInfoScreen.routeName: (ctx) => EmployeeInfoScreen(),
        EmployeeListScreen.routeName: (ctx) => EmployeeListScreen(),
      },
    );
  }
}
