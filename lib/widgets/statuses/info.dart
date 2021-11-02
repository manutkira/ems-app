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
    this.text = "this is an information status.",
  }) : super(
            key: key,
            backgroundColor: kBlueBackground,
            icon: const Icon(
              MdiIcons.informationOutline,
              size: 16,
              color: kBlueText,
            ),
            text: text,
            textColor: kBlueText);

  final String text;
}
