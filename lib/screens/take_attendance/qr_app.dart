import 'package:ems/constants.dart';
import 'package:ems/screens/take_attendance/qr_scanner.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRAppScreen extends StatelessWidget {
  final String type;
  const QRAppScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(type.toTitleCase()),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TabBar(
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                overlayColor: MaterialStateProperty.all(kBlue),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  color: kDarkestBlue,
                ),
                tabs: const [
                  // Text("Scan")
                  Tab(
                    // icon: Icon(Icons.code),
                    text: "QR Code",
                  ),
                  Tab(
                    // icon: Icon(Icons.camera),
                    text: "Scan",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _scan(context),
                  QRCodeScanner(
                    type: type,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scan(BuildContext context) {
    var size = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 250.0;
    return Container(
      color: kDarkestBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(30),
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
                data: "data from qr code",
                version: QrVersions.auto,
                size: size,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("Scan the code to $type"),
        ],
      ),
    );
  }
}
