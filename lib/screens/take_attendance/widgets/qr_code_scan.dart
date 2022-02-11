import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../qr_scanner.dart';

class TakeAttendanceScreen extends ConsumerStatefulWidget {
  const TakeAttendanceScreen({
    Key? key,
  }) : super(key: key);

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
      ),
      body: const QRCodeScanner(),
    );
  }
}
