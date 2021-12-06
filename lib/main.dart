import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendance/individual_attendance.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import './constants.dart';
import './screens/employee/employee_list_screen.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing local database
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
      theme: themeData,
      home: ValueListenableBuilder(
        valueListenable: ref.watch(currentUserProvider).currentUserListenable,
        builder: (BuildContext context, Box<User> box, Widget? child) {
          final currentUserData = box.values.toList();
          return box.isEmpty || currentUserData[0].isEmpty
              ? const LoginScreen()
              : const HomeScreen();
        },
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('km', 'KH'),
        Locale('en', 'US'),
      ],
      locale: const Locale('en'),
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
