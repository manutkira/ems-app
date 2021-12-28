import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MenuItem extends StatelessWidget {
  final illustration;
  final String label;
  final Function() onTap;
  const MenuItem(
      {Key? key,
      required this.onTap,
      required this.illustration,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: kLightBlue, borderRadius: BorderRadius.all(kBorderRadius)),
          padding: kPaddingAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              illustration,
              const SizedBox(height: 6),
              Text(
                label,
                style: kSubtitle.copyWith(
                    color: kBlack, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
