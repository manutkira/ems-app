import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../constants.dart';

/// custom modal bottom sheet builder
///
/// returns Future<void>
Future<void> modalBottomSheetBuilder({
  required BuildContext context,
  double maxHeight = 440.0,
  double minHeight = 400.0,
  bool isDismissible = true,
  bool isScrollControlled = true,
  required Widget child,
}) async {
  return showMaterialModalBottomSheet(
    // constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
    backgroundColor: Colors.transparent,
    // isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: isScrollControlled,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: maxHeight,
        decoration: const BoxDecoration(
          color: kBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // top center panel thingy
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 75,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child,
          ],
        ),
      );
    },
  );
}
