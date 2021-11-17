import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

/// this is the base status widget with nothing set.
class StatusWidget extends StatelessWidget {
  const StatusWidget(
      {Key? key,
      required this.backgroundColor,
      required this.icon,
      required this.text,
      required this.textColor})
      : super(key: key);
  final Color backgroundColor;
  final Icon icon;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: kSubtitle.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
