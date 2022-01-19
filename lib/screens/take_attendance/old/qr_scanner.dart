import 'dart:developer';
import 'dart:io';

import 'package:ems/constants.dart';
import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/screens/take_attendance/widgets/confirmation.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/widgets/statuses/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends ConsumerStatefulWidget {
  final String type;
  const QRCodeScanner({Key? key, required this.type}) : super(key: key);

  @override
  ConsumerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends ConsumerState<QRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool noPermission = false;
  bool _isLoading = false;
  final AttendanceService _attService = AttendanceService.instance;
  Attendance? attendance;
  String _loadingMessage = '';

  /// helps with hotreload
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _closePanel() {
    Navigator.of(context).pop();
  }

  /// reset loading states to normal
  void resetLoading() {
    setState(() {
      _loadingMessage = '';
      _isLoading = false;
    });
  }

  Future<bool> verifyQRCode(String code) async {
    // localization
    AppLocalizations? local = AppLocalizations.of(context);

    // loading screen and message
    setState(() {
      _loadingMessage = "${local?.verifyingQRCode}";
      _isLoading = true;
    });

    // verifying qr code
    bool isVerified = false;
    try {
      isVerified = await _attService.verifyQRCode(code);
    } catch (e) {
      // if service fails, return verification error
      _buildQRCodeError();
    }

    resetLoading();

    return isVerified;
  }

  addAttendance(Barcode _result) async {
    AppLocalizations? local = AppLocalizations.of(context);

    bool isVerified = await verifyQRCode("${_result.code}");
    // if not verified(most likely, wrong code), return verification error
    if (!isVerified) {
      _buildQRCodeError();
      return;
    }

    int _currentUserId = ref.read(currentUserProvider).user.id as int;

    setState(() {
      attendance = Attendance(
        userId: _currentUserId,
        type: widget.type,
        date: DateTime.now(),
      );
    });

    // confirmation screen
    bool confirmed = await confirmScan();
    // if cancel, stop the process
    if (!confirmed) {
      return;
    }

    // else set new loading message
    setState(() {
      _loadingMessage = "${local?.savingAttendance}";
      _isLoading = true;
    });

    // registering record
    try {
      await _attService.createOne(
        attendance: attendance as Attendance,
      );
      // if not error
      resetLoading();
      _buildScanSuccessful();
      _closePanel();
    } catch (err) {
      resetLoading();
      _buildScanFailed();
    }
  }

  /// Full screen snackbar widget
  SnackBar _buildSnackBar(
      {required IconData icon,
      required Color backgroundColor,
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
              icon,
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

    /// use to set note from confirmation panel before registering the record
    /// confirmation to true
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
      maxHeight: MediaQuery.of(context).size.height * 0.6,
      minHeight: MediaQuery.of(context).size.height * 0.4,
      child: ScanConfirmation(attendance: attendance as Attendance, ok: ok),
    );

    return confirmation;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? _loading(context, _loadingMessage)
            : _buildScanner(context));
  }

  Widget _buildScanner(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      color: kDarkestBlue,
      child: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            bottom: 80,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                    },
                    child: Text(
                      '${local?.flash}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.9,
              child: StatusInfo(text: "${local?.scanInstruction}"),
            ),
          ),
        ],
      ),
    );
  }

  /// qr scanner
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: kBlue,
        borderRadius: 10,
        borderLength: 25,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  /// set controller and listen to events
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code.toString().isNotEmpty) {
        // set scanning result
        setState(() {
          result = scanData;
        });

        // stop the camera to let user know that the app got the data
        if (Platform.isAndroid) {
          await this.controller!.stopCamera();
        }
        if (Platform.isIOS) {
          await this.controller!.pauseCamera();
        }
        // add attendance
        await addAttendance(scanData);
        await this.controller!.resumeCamera();
      }
    });
  }

  /// check permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    AppLocalizations? local = AppLocalizations.of(context);

    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      setState(() {
        noPermission = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: kRedBackground,
            content: Text(
              '${local?.allowCamera}',
              style: kParagraph.copyWith(color: kRedText),
            )),
      );
    }
  }

  /// dispose the controller to avoid memory leak
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// loading widget
  Widget _loading(BuildContext context, String message) {
    Size _size = MediaQuery.of(context).size;

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
            Text(message)
          ],
        ),
      ),
      color: kDarkestBlue,
    );
  }

  /// build qr code error
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      _buildQRCodeError() {
    AppLocalizations? local = AppLocalizations.of(context);
    return ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        icon: Icons.close,
        textColor: kRedText,
        backgroundColor: kRedBackground,
        type: widget.type,
        message: '${local?.verifyingQRCodeFailed}',
      ),
    );
  }

  /// build scan successful
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      _buildScanSuccessful() {
    AppLocalizations? local = AppLocalizations.of(context);
    String localType = widget.type == AttendanceType.typeCheckIn
        ? "${local?.checkin}"
        : "${local?.checkout}";

    return ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        icon: Icons.check,
        textColor: kGreenText,
        backgroundColor: kGreenBackground,
        type: widget.type,
        message: '$localType ${local?.successfully}!',
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _buildScanFailed() {
    AppLocalizations? local = AppLocalizations.of(context);
    String localType = widget.type == AttendanceType.typeCheckIn
        ? "${local?.checkin}"
        : "${local?.checkout}";
    return ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        icon: Icons.close,
        textColor: kRedText,
        backgroundColor: kRedBackground,
        type: widget.type,
        message: '$localType ${local?.failed}!',
      ),
    );
  }
}
