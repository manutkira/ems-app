import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class TextBoxCustom extends StatefulWidget {
  const TextBoxCustom({
    Key? key,
    required this.textHint,
    this.prefixIcon,
    required this.getValue,
    this.isPassword = false,
    this.defaultText = "",
  }) : super(key: key);
  final String textHint;
  final Icon? prefixIcon;
  final Function getValue;
  final bool isPassword;
  final String defaultText;

  @override
  _TextBoxCustomState createState() => _TextBoxCustomState();
}

class _TextBoxCustomState extends State<TextBoxCustom> {
  bool showPassword = false;
  final TextEditingController _controller = TextEditingController();

  void _onTextChanged() {
    widget.getValue(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _controller.text = widget.defaultText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.isPassword & !showPassword,
      cursorColor: kWhite,
      style: kSubtitle,
      decoration: InputDecoration(
        hintStyle: kSubtitle.copyWith(color: kSubtitle.color!.withOpacity(0.5)),
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
                      ? const Icon(
                          MdiIcons.eyeOff,
                          color: kWhite,
                        )
                      : const Icon(
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
    );
  }
}
