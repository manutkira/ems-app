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
    return Material(
      color: kLightBlue,
      child: InkWell(
        highlightColor: kBlue.withOpacity(0.25),
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                illustration,
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    label,
                    style: kSubtitle.copyWith(
                      fontSize: 12,
                      color: kBlack,
                      fontWeight: FontWeight.w700,
                      height: 1.7,
                      // overflow: TextOverflow.visible,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
