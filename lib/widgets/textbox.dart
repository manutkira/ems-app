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
    _controller.text = widget.defaultText;
    _controller.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        cursorHeight: 14,
        controller: _controller,
        obscureText: widget.isPassword & !showPassword,
        cursorColor: kWhite,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(top: 16, bottom: 0, left: 12, right: 12),
          hintText: widget.textHint,

          /// this seems to fix the misalignment issue
          hintStyle: const TextStyle(fontSize: 0),
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
        ),
      ),
    );
  }
}
