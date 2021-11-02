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
    this.text = "an error has occurred.",
  }) : super(
            key: key,
            backgroundColor: kRedBackground,
            icon: const Icon(
              MdiIcons.alertCircleOutline,
              size: 16,
              color: kRedText,
            ),
            text: text,
            textColor: kRedText);

  final String text;
}
