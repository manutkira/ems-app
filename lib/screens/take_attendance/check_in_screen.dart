import 'package:ems/models/attendance.dart';
import 'package:flutter/material.dart';

import 'qr_app.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRAppScreen(
      type: AttendanceType.typeCheckIn,
    );
  }
}
