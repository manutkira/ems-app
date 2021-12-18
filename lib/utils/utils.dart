import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// String format
/// https://stackoverflow.com/a/29629114
///
extension StringCasingExtension on String {
  String toCapitalized() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

/// Generates a TimeOfDay object from string
///
/// Form of string supported is hh:mm:ss i.e 12:40:21
///
/// Because this will return a TimeOfDay object, you can only get the hour and minute back.
TimeOfDay getTimeOfDayFromString(String? str) {
  if (str == null || str.isEmpty) str = '00:00:00';
  try {
    return TimeOfDay(
      hour: int.parse(str.split(":")[0]),
      minute: int.parse(str.split(":")[1]),
    );
  } catch (e) {
    str = '00:00:00';
    return TimeOfDay(
      hour: int.parse(str.split(":")[0]),
      minute: int.parse(str.split(":")[1]),
    );
  }
}

getStringFromDateTime(DateTime datetime) {
  return DateFormat('dd/MM/yyyy').format(datetime).toString();
}
