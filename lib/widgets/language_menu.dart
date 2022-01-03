import 'package:ems/models/language.dart';
import 'package:ems/persistence/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class LanguageMenu extends ConsumerStatefulWidget {
  const LanguageMenu({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LanguageMenuState();
}

class _LanguageMenuState extends ConsumerState<LanguageMenu> {
  final List<Languages> supportedLanguages = Languages.supported;
  String defaultLanguage = '';

  void switchLanguage(String? language) async {
    await ref.read(settingsProvider).switchLanguage("$language");
    if (mounted) {
      setState(() {
        defaultLanguage = ref.read(settingsProvider).getLanguage();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    defaultLanguage = ref.read(settingsProvider).getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton(
        isDense: true,
        iconSize: 0,
        elevation: 4,
        itemHeight: 50,
        dropdownColor: kDarkestBlue,
        underline: Container(),
        borderRadius: BorderRadius.circular(6),
        value: defaultLanguage,
        items: [
          ...supportedLanguages.map(
            (e) {
              String flag = e.flag;
              String name = e.name;
              return DropdownMenuItem(
                value: name,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      flag,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        onChanged: (String? language) => switchLanguage(language),
      ),
    );
  }
}
