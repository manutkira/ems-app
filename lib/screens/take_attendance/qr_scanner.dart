import 'dart:convert';
import 'dart:io';

import 'package:ems/constants.dart';
import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/attendances.dart';
import 'package:ems/screens/take_attendance/widgets/employee_confirmation.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/widgets/statuses/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends ConsumerStatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

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
  String note = '';

  /// helps with hot reload
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  /// reset loading states to normal
  void resetLoading() {
    setState(() {
      note = "";
      result = null;
      _loadingMessage = '';
      _isLoading = false;
    });
  }

  /// add attendance to the api or to the local cache depending on the connection status.
  addAttendance(Barcode _result) async {
    AppLocalizations? local = AppLocalizations.of(context);

    // confirmation screen
    bool confirmed = await confirmEmployee("${result?.code}");
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
      bool isOnline = await InternetConnectionChecker().hasConnection;
      if (isOnline) {
        // if online
        await _attService.createOneRecord(
          userId: attendance?.userId as int,
          date: attendance?.date as DateTime,
          note: note,
          // attendance: attendance as Attendance,
        );
      } else {
        // if offline
        Map<String, dynamic> userFromQR = decodeQR("${result?.code}");
        Map<String, dynamic> att = {
          "user": {
            "id": userFromQR['id'],
            "profile": "${userFromQR['profile']}",
            "name": userFromQR['name'],
          },
          "user_id": userFromQR['id'],
          "time": attendance?.date?.toIso8601String(),
          "note": note,
        };

        await ref.read(localAttendanceCacheProvider).add(att);
      }
    } catch (err) {
      // if fails show fail panel
      _buildScanFailed();
    } finally {
      // finally, reset things
      resetLoading();
    }
  }

  /// Full screen snackbar widget
  SnackBar _buildSnackBar({
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required String message,
  }) {
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

  /// decodes the QR code result then returns user obj.
  ///
  /// ```dart
  /// {
  ///   "id": int,
  ///   "profile": String,
  ///   "name": String,
  /// }
  /// ```
  Map<String, dynamic> decodeQR(String code) {
    var json = jsonDecode(code);
    int? id = int.tryParse(json['id']);
    String? profile = json['profile'];
    String? name = json['name'];
    if (id == null || name == null) {
      return {};
    }
    return {
      "id": id,
      "profile": profile,
      "name": name,
    };
  }

  /// confirm screen, create attendance object
  Future<bool> confirmEmployee(String code) async {
    AppLocalizations? local = AppLocalizations.of(context);
    var json = jsonDecode(code);
    int? id = int.tryParse(json['id']);
    String? profile = json['profile'];
    String? name = json['name'];
    if (id == null || name == null) {
      return false;
    }

    Map<String, dynamic> userFromQR = decodeQR(code);
    if (userFromQR.isEmpty) return false;
    bool confirmation = false;

    // use to set note from confirmation panel before registering the record
    // confirmation to true
    void ok(String attendanceNote) {
      setState(() {
        attendance = Attendance(
          userId: id,
          // type: widget.type,
          date: DateTime.now(),
        );
      });

      if (attendanceNote.isNotEmpty || attendanceNote != 'null') {
        setState(() {
          note = attendanceNote;
        });
      }
      confirmation = true;
    }

    await showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: kBlue,
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Text(
                  '${local?.confirm}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: kBlue,
                  ),
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: EmployeeConfirmScreen(
                      name: name,
                      profile: '$profile',
                      ok: (note) => ok(note),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          : _buildScanner(context),
    );
  }

  /// builds scanner ui.
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

  /// builds the qr code scanner.
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

  /// sets controller and listens to events
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

        // stops the camera after app scanned the qr code
        if (Platform.isAndroid) {
          await this.controller!.stopCamera();
        }
        if (Platform.isIOS) {
          await this.controller!.pauseCamera();
        }

        // adds attendance
        await addAttendance(scanData);

        // then resumes camera again
        await this.controller!.resumeCamera();
      }
    });
  }

  /// checks permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    AppLocalizations? local = AppLocalizations.of(context);

    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
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

  /// builds the loading widget
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

  /// builds scan failed screen
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _buildScanFailed() {
    AppLocalizations? local = AppLocalizations.of(context);
    return ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        icon: Icons.close,
        textColor: kRedText,
        backgroundColor: kRedBackground,
        message: '${local?.scanFailed}',
      ),
    );
  }
}
