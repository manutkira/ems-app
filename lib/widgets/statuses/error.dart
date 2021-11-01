import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// this is the error status widget with nothing set.
///
/// @params String text
class StatusError extends StatusWidget {
  const StatusError({
    Key? key,
    this.backgroundColor = kRedBackground,
    this.textColor = kRedText,
    this.icon = const Icon(
      MdiIcons.alertCircleOutline,
      size: 16,
      color: kRedText,
    ),
    this.text = "an error has occurred.",
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
