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

/// a copyWith function to easily set hour and minute. used in overtime section
///
/// https://stackoverflow.com/a/61111352
///
extension MyDateUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
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
