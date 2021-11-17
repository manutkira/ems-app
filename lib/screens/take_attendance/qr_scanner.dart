import 'dart:developer';
import 'dart:io';

import 'package:ems/constants.dart';
import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/widgets/statuses/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  bool isAddingAttendance = false;

  final AttendanceService _attService = AttendanceService.instance;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  addAttendance(Barcode _result) async {
    // maybe check password from qr code?
    setState(() {
      isAddingAttendance = true;
    });

    User _currentUser = ref.read(currentUserProvider);

    try {
      await _attService.createOne(
        attendance: Attendance(
          userId: _currentUser.id,
          type: widget.type,
        ),
      );
      setState(() {
        isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: kGreenBackground,
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check,
                  size: 80,
                  color: kGreenText,
                ),
                Text(
                  '${widget.type} successfully!',
                  style: kParagraph.copyWith(color: kGreenText),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (err) {
      setState(() {
        isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: kRedBackground,
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.close,
                  size: 80,
                  color: kRedText,
                ),
                Text(
                  '${widget.type} failed! $err',
                  style: kParagraph.copyWith(color: kRedText),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: isAddingAttendance
          ? _loading(context)
          : Container(
              color: kDarkestBlue,
              child: Stack(
                children: <Widget>[
                  _buildQrView(context),
                  Positioned(
                    bottom: 80,
                    child: SizedBox(
                      width: _size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                            },
                            child: const Text(
                              'Flash',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 80,
                    child: StatusInfo(text: "Keep the QR code in the center"),
                  ),
                ],
              ),
            ),
    );
  }

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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    // if (this.controller?.hasPermissions as bool) {
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code.toString().isNotEmpty) {
        setState(() {
          result = scanData;
        });

        if (Platform.isAndroid) {
          await this.controller!.stopCamera();
        }
        if (Platform.isIOS) {
          await this.controller!.pauseCamera();
        }
        await addAttendance(scanData);
      }
    });

    // }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      setState(() {
        noPermission = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: kRedBackground,
            content: Text(
              'Please allow camera permission to use this feature.',
              style: kParagraph.copyWith(color: kRedText),
            )),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

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
