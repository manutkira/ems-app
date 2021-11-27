import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/take_attendance/qr_code.dart';
import 'package:ems/screens/take_attendance/qr_scanner.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRAppScreen extends ConsumerWidget {
  final String type;
  const QRAppScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.read(currentUserProvider).user.role;
    final _isAdmin = role == 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(type.toTitleCase()),
        centerTitle: true,
      ),
      body: _isAdmin
          ? QRCode(
              // Code to scan
              type: type,
            )
          : QRCodeScanner(
              // Code scanner
              type: type,
            ),
    );

    /// with tabs
    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text(type.toTitleCase()),
    //       centerTitle: true,
    //     ),
    //     body: Column(
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //           child: TabBar(
    //             labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    //             unselectedLabelStyle:
    //                 const TextStyle(fontWeight: FontWeight.w400),
    //             overlayColor: MaterialStateProperty.all(kBlue),
    //             indicator: BoxDecoration(
    //               borderRadius: BorderRadius.circular(
    //                 5,
    //               ),
    //               color: kDarkestBlue,
    //             ),
    //             tabs: const [
    //               Tab(
    //                 // icon: Icon(Icons.code),
    //                 text: "QR Code",
    //               ),
    //               Tab(
    //                 // icon: Icon(Icons.camera),
    //                 text: "Scan",
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: TabBarView(
    //             children: [
    //               _scan(context),
    //               QRCodeScanner(
    //                 type: type,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  /// qr code

}
