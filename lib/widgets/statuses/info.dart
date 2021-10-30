import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// this is the error status widget with nothing set.
///
/// @params String text
class StatusInfo extends StatusWidget {
  const StatusInfo({
    Key? key,
    this.backgroundColor = kBlueBackground,
    this.textColor = kBlueText,
    this.icon = const Icon(
      MdiIcons.alertOutline,
      size: 16,
      color: kBlueText,
    ),
    this.text = "this is an information status.",
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
