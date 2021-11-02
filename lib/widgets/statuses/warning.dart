import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// this is the error status widget with nothing set.
///
/// @params String text
class StatusWarning extends StatusWidget {
  const StatusWarning({
    Key? key,
    this.text = "this is a warning.",
  }) : super(
            key: key,
            backgroundColor: kYellowBackground,
            icon: const Icon(
              MdiIcons.alertOutline,
              size: 16,
              color: kYellowText,
            ),
            text: text,
            textColor: kYellowText);

  final String text;
}
