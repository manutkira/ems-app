import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';

class QRCode extends ConsumerStatefulWidget {
  const QRCode({Key? key}) : super(key: key);

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
    // String type =
    //     "${widget.type == AttendanceType.typeCheckIn ? local?.checkin : local?.checkout}";

    return Scaffold(
      appBar: AppBar(
        title: Text("${local?.qrCode}"),
        centerTitle: true,
      ),
      body: Container(
        color: kDarkestBlue,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: true,
              child: ValueListenableBuilder(
                valueListenable:
                    ref.watch(currentUserProvider).currentUserListenable,
                builder: (BuildContext context, Box<User> box, Widget? child) {
                  User? user = box.get(currentUserBoxName);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomCircleAvatar(
                        imageUrl: "${user?.image}",
                        size: size - 50,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          Text(
                            '${user?.name?.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Text(
                          //   '${user?.position ?? local?.employee}',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                          // const SizedBox(height: 16),
                          Text(
                            'ID: ${user?.id}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.all(8),
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

            // const SizedBox(height: 20),
            // Text("${local?.scanToType(type)}"),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
