import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';

class QRCode extends ConsumerStatefulWidget {
  final String type;
  const QRCode({Key? key, required this.type}) : super(key: key);

  @override
  ConsumerState<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends ConsumerState<QRCode> {
  final AttendanceService _attendanceService = AttendanceService.instance;
  bool _isAddingAttendance = false;
  final String _passcode = "data from qr code";

  /// add attendance record
  addAttendance() async {
    // TODO:
    // maybe check password from qr code?
    setState(() {
      _isAddingAttendance = true;
    });

    /// _passcode verification here

    int _currentUserId = ref.read(currentUserProvider).user.id as int;

    try {
      await _attendanceService.createOne(
        attendance: Attendance(
          userId: _currentUserId,
          type: widget.type,
        ),
      );
      setState(() {
        _isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          textColor: kGreenText,
          backgroundColor: kGreenBackground,
          type: widget.type,
        ),
      );
    } catch (err) {
      setState(() {
        _isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          textColor: kRedText,
          backgroundColor: kRedBackground,
          type: widget.type,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 250.0;

    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    String type =
        "${widget.type == AttendanceType.typeCheckIn ? local?.checkin : local?.checkout}";

    return _isAddingAttendance
        ? _loading(context)
        : Container(
            color: kDarkestBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: QrImage(
                      // embeddedImage: NetworkImage(
                      //     "https://seeklogo.com/images/F/flutter-logo-5086DD11C5-seeklogo.com.png"),
                      // embeddedImageStyle: QrEmbeddedImageStyle(
                      //   size: Size(40, 40),
                      // ),
                      data: _passcode,
                      version: QrVersions.auto,
                      size: size,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("${local?.scanToType(type)}"),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(top: 10, bottom: 10),
                    primary: Colors.white,
                    textStyle: kParagraph,
                    backgroundColor: kBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: addAttendance,
                  child: Text(
                    '${local?.checkMyself(type)}',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
  }

  /// Full screen snackbar widget
  SnackBar _buildSnackBar(
      {required backgroundColor,
      required Color textColor,
      required String type}) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 80,
              color: textColor,
            ),
            Text(
              '$type successfully!',
              style: kParagraph.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  /// loading widget
  Widget _loading(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: _size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 4,
            ),
            SizedBox(
              height: 15,
            ),
            Text("Creating Attendance")
          ],
        ),
      ),
      color: kDarkestBlue,
    );
  }
}
