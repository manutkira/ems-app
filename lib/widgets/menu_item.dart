import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MenuItem extends StatelessWidget {
  final Widget illustration;
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
          // padding: kPaddingAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              illustration,
              const SizedBox(height: 6),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  label,
                  style: kSubtitle.copyWith(
                    fontSize: 14,
                    color: kBlack,
                    fontWeight: FontWeight.w700,
                    height: 1.7,
                    overflow: TextOverflow.visible,
                  ),
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
