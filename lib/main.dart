import 'package:ems/persistence/attendances.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/persistence/setting.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/screens/home_screen_employee.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import './constants.dart';
import 'l10n/l10n.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing local database
  final dataStore = CurrentUserStore();
  final settingsStore = SettingsStore();
  final localAttendanceStore = AttendanceDataStore();
  await dataStore.init();
  await settingsStore.init();
  await localAttendanceStore.init();

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWithValue(settingsStore),
        currentUserProvider.overrideWithValue(dataStore),
        localAttendanceCacheProvider.overrideWithValue(localAttendanceStore),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ValueListenableBuilder(
        valueListenable: ref.watch(settingsProvider).settingsListenable,
        builder: (BuildContext context, Box<int> box, Widget? child) {
          int index = box.values.toList()[0];
          return MaterialApp(
            locale: L10n.all[index],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: themeData(context),
            home: ValueListenableBuilder(
              valueListenable:
                  ref.watch(currentUserProvider).currentUserListenable,
              builder: (BuildContext context, Box<User> box, Widget? child) {
                final currentUserData = box.values.toList();
                if (box.isEmpty || currentUserData[0].isEmpty) {
                  return const LoginScreen();
                }
                if (ref.read(currentUserProvider).isAdmin) {
                  return const HomeScreenAdmin();
                } else {
                  return const HomeScreenEmployee();
                }
              },
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
          );
        });
  }
}
