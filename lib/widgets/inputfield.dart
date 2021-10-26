import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String textHint;
  final Icon prefixIcon;
  final Function getValue;
  final bool isPassword;

  InputField(
      {Key? key,
      required this.labelText,
      required this.textHint,
      required this.prefixIcon,
      this.isPassword = false,
      required this.getValue})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: kParagraph.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) {
            widget.getValue(value);
          },
          obscureText: widget.isPassword & !showPassword,
          cursorColor: kWhite,
          style: kSubtitle,
          decoration: InputDecoration(
            hintStyle:
                kSubtitle.copyWith(color: kSubtitle.color!.withOpacity(0.5)),
            hintText: widget.textHint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Container(
                      child: showPassword
                          ? Icon(
                              MdiIcons.eyeOff,
                              color: kWhite,
                            )
                          : Icon(
                              MdiIcons.eye,
                              color: kWhite,
                            ),
                    ),
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            fillColor: kDarkestBlue,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(kBorderRadius),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(kBorderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
