import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendance/individual_attendance.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import './constants.dart';
import './screens/employee/employee_list_screen.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataStore = CurrentUserStore();
  await dataStore.init();

  runApp(
    ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(dataStore),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _themeData,
      home: ValueListenableBuilder(
        valueListenable: ref.watch(currentUserProvider).currentUserListenable,
        builder: (BuildContext context, Box<User> box, Widget? child) {
          var currentUser = box.values.toList()[0];

          return currentUser.isEmpty ? const LoginScreen() : const HomeScreen();
        },
      ),
      routes: {
        IndividualAttendanceScreen.routeName: (ctx) =>
            IndividualAttendanceScreen(),
        // EmployeeEditScreen.routeName: (ctx) => EmployeeEditScreen(),
        EmployeeInfoScreen.routeName: (ctx) => EmployeeInfoScreen(),
        EmployeeListScreen.routeName: (ctx) => EmployeeListScreen(),
      },
    );
  }

  ThemeData get _themeData {
    return ThemeData.dark().copyWith(
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
        hintStyle: kSubtitle.copyWith(color: kSubtitle.color!.withOpacity(0.5)),
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
      appBarTheme: const AppBarTheme(
        backgroundColor: kBlue,
        titleTextStyle: kHeadingThree,
        elevation: 0,
      ),
    );
  }
}
