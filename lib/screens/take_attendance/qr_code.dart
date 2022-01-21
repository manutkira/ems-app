import 'dart:convert';

import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
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
  String _passcode = "";

  void fetchQrCode() async {
    User _currentUser = ref.read(currentUserProvider).user;
    setState(() {
      _passcode = jsonEncode({
        'id': _currentUser.id.toString(),
        'profile': _currentUser.image,
        'name': _currentUser.name,
      });
    });
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

    return Container(
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
                  child: QrImage(
                    data: _passcode,
                    version: QrVersions.auto,
                    size: size,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text("${local?.scanToType(type)}"),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
