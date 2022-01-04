import 'package:flutter/material.dart';

import '../../../constants.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    Key? key,
    required this.sortByValue,
    required this.dropDownItems,
    required this.onChanged,
  }) : super(key: key);
  final String sortByValue;
  final List<String> dropDownItems;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      borderRadius: const BorderRadius.all(kBorderRadius),
      dropdownColor: kDarkestBlue,
      underline: Container(),
      style: kParagraph.copyWith(),
      isDense: true,
      value: sortByValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: dropDownItems.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) => onChanged(newValue),
    );
  }
}
