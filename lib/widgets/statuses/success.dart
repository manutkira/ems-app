import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// this is the error status widget with nothing set.
///
/// @params String text
class StatusSuccess extends StatusWidget {
  const StatusSuccess({
    Key? key,
    this.backgroundColor = kGreenBackground,
    this.textColor = kGreenText,
    this.icon = const Icon(
      MdiIcons.checkCircleOutline,
      size: 16,
      color: kGreenText,
    ),
    this.text = "task has been done successfully.",
  }) : super(
            key: key,
            backgroundColor: backgroundColor,
            icon: icon,
            text: text,
            textColor: textColor);

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Icon icon;
}
