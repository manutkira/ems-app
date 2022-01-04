import 'package:flutter/material.dart';

PopupMenuEntry<String> buildMoreMenu(String option) {
  return PopupMenuItem<String>(
    height: 42,
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
    ),
    value: option,
    child: Text(
      option,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
  );
}
