import 'dart:convert';

import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/screens/take_attendance/widgets/confirmation.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/widgets/statuses/error.dart';
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
  final AttendanceService _attService = AttendanceService.instance;
  bool _isAddingAttendance = false;
  String _passcode = "";
  String _error = "";
  Attendance? attendance;

  /// add attendance record
  addAttendance() async {
    // TODO:
    // maybe check password from qr code?

    User _currentUser = ref.read(currentUserProvider).user;

    setState(() {
      attendance = Attendance(
        userId: _currentUser.id,
        type: widget.type,
        date: DateTime.now(),
      );
    });

    bool confirmed = await confirmScan();

    if (!confirmed) {
      return;
    }

    setState(() {
      _isAddingAttendance = true;
    });

    AppLocalizations? local = AppLocalizations.of(context);
    String localType = widget.type == AttendanceType.typeCheckIn
        ? "${local?.checkin}"
        : "${local?.checkout}";
    try {
      await _attService.createOne(
        attendance: attendance as Attendance,
      );
      setState(() {
        _isAddingAttendance = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          textColor: kGreenText,
          backgroundColor: kGreenBackground,
          type: widget.type,
          message: '$localType ${local?.successfully}!',
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
          message: '$localType ${local?.failed}!',
        ),
      );
    }
  }

  /// Full screen snackbar widget
  SnackBar _buildSnackBar(
      {required backgroundColor,
      required Color textColor,
      required String type,
      required String message}) {
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
              message,
              style: kParagraph.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> confirmScan() async {
    bool confirmation = false;
    void ok(String str) {
      if (str.isNotEmpty) {
        setState(() {
          attendance = attendance?.copyWith(note: str);
        });
      }
      confirmation = true;
    }

    await modalBottomSheetBuilder(
      isDismissible: false,
      isScrollControlled: false,
      context: context,
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      minHeight: MediaQuery.of(context).size.height * 0.4,
      child: ScanConfirmation(attendance: attendance as Attendance, ok: ok),
    );

    return confirmation;
  }

  void fetchQrCode() async {
    User _currentUser = ref.read(currentUserProvider).user;
    setState(() {
      _passcode = jsonEncode({
        'id': _currentUser.id.toString(),
        'profile': _currentUser.image,
        'name': _currentUser.name,
      });
      // verifyQrCode();
    });
    // try {
    //   // String code = await _attService.generateQRCode();
    //   // print(code);
    //   User _currentUser = ref.read(currentUserProvider).user;
    //   setState(() {
    //     _passcode = _currentUser.id.toString();
    //     // verifyQrCode();
    //   });
    // } catch (e) {
    //   setState(() {
    //     _error = 'Error fetching new QR code';
    //   });
    // }
  }

  void verifyQrCode() async {
    try {
      bool isVerified = await _attService.verifyQRCode(_passcode);
    } catch (e) {
      setState(() {
        _error = 'Error verifying qr code.';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    /// creating qr code
    fetchQrCode();
  }

  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 250.0;

    AppLocalizations? local = AppLocalizations.of(context);
    String type =
        "${widget.type == AttendanceType.typeCheckIn ? local?.checkin : local?.checkout}";

    return _isAddingAttendance
        ? _loading(context)
        : Container(
            color: kDarkestBlue,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: _passcode.isNotEmpty
                            ? QrImage(
                                data: _passcode,
                                version: QrVersions.auto,
                                size: size,
                              )
                            : _fetchingQrCode(size),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("${local?.scanToType(type)}"),
                    const SizedBox(height: 20),
                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //     padding: kPadding.copyWith(top: 10, bottom: 10),
                    //     primary: Colors.white,
                    //     textStyle: kParagraph,
                    //     backgroundColor: kBlue,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.all(kBorderRadius),
                    //     ),
                    //   ),
                    //   onPressed: addAttendance,
                    //   child: Text(
                    //     '${local?.checkMyself(type)}',
                    //     style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
                Visibility(
                  visible: _error.isNotEmpty,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 50,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: StatusError(text: _error),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _fetchingQrCode(double size) {
    AppLocalizations? local = AppLocalizations.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: kBlack,
          ),
          const SizedBox(height: 12),
          Text(
            '${local?.loading}',
            style: const TextStyle(
              color: kBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// loading widget
  Widget _loading(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      width: _size.width,
      height: _size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 4,
            ),
            const SizedBox(
              height: 15,
            ),
            Text("${local?.savingAttendance}")
          ],
        ),
      ),
      color: kDarkestBlue,
    );
  }
}
