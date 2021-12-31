import 'package:flutter/material.dart';

class BaselineRow extends StatelessWidget {
  const BaselineRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
  }) : super(key: key);
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      children: children,
    );
  }
}
