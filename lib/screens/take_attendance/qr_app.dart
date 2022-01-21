import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/take_attendance/qr_code.dart';
import 'package:ems/screens/take_attendance/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRAppScreen extends ConsumerWidget {
  final String type;
  const QRAppScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLocalizations? local = AppLocalizations.of(context);
    final role = ref.read(currentUserProvider).user.role;
    final _isAdmin = role?.toLowerCase() == 'admin';
    String title =
        "${type == AttendanceType.typeCheckIn ? local?.checkin : local?.checkout}";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: _isAdmin
          ? QRCodeScanner(
              // Code scanner
              type: type,
            )
          : QRCode(
              // Code to scan
              type: type,
            ),
      // body: _isAdmin
      //     ? QRCode(
      //         // Code to scan
      //         type: type,
      //       )
      //     : QRCodeScanner(
      //         // Code scanner
      //         type: type,
      //       ),
    );
  }
}
