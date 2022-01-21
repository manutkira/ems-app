import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class EMSAppBar extends ConsumerWidget with PreferredSizeWidget {
  const EMSAppBar({Key? key, required this.openDrawer}) : super(key: key);
  final Function() openDrawer;

  @override
  PreferredSizeWidget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: GestureDetector(
        onTap: openDrawer,
        child: Container(
          padding: kPaddingAll,
          child: SvgPicture.asset(
            'assets/images/menuburger.svg',
            semanticsLabel: "menu",
          ),
        ),
      ),
      title: const Text('Internal EMS'),
      actions: const [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
