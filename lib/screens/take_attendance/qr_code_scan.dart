import 'package:ems/persistence/attendances.dart';
import 'package:ems/screens/take_attendance/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'local_attendance_cache_screen.dart';

class TakeAttendanceScreen extends ConsumerStatefulWidget {
  TakeAttendanceScreen({
    Key? key,
    required this.isOnline,
  }) : super(key: key);
  bool isOnline;

  @override
  ConsumerState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends ConsumerState<TakeAttendanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${local?.takeAttendance}"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LocalAttendanceCacheScreen(),
              ),
            ),
            icon: Center(
              child: Stack(
                children: [
                  const Icon(Icons.notifications),
                  ValueListenableBuilder(
                    valueListenable: ref
                        .watch(localAttendanceCacheProvider)
                        .localCacheListenable,
                    builder: (BuildContext context, Box<List<dynamic>> box,
                        Widget? child) {
                      var list = box.get(localAttendanceCacheBoxName);
                      return Visibility(
                        visible: list!.isNotEmpty,
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: const TestScanner(),
      body: QRCodeScanner(isOnline: widget.isOnline),
    );
  }
}
