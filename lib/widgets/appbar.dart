import 'package:ems/screens/take_attendance/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class EMSAppBar extends ConsumerWidget with PreferredSizeWidget {
  const EMSAppBar({Key? key, required this.openDrawer}) : super(key: key);
  final Function() openDrawer;

  void seeQRCode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRCode(),
      ),
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: openDrawer,
        icon: SizedBox(
          width: 25,
          height: 25,
          child: SvgPicture.asset(
            'assets/images/menuburger.svg',
            semanticsLabel: "menu",
          ),
        ),
      ),
      // TODO: CHANGE NAME TO EMPLOYEE PORTAL
      title: const Text('Internal EMS'),
      actions: [
        IconButton(
          onPressed: () => seeQRCode(context),
          icon: SizedBox(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              "assets/images/qr-code-icon.svg",
              height: 50,
              color: kWhite,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
