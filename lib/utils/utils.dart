import 'dart:io';

import 'package:ems/l10n/l10n.dart';
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

/// returns the date as string
getDateStringFromDateTime(DateTime datetime, {String format = 'dd/MM/yyyy'}) {
  return DateFormat(format).format(datetime).toString();
}

/// date picker dialog
Future<DateTime?> buildDateTimePicker({
  required BuildContext context,
  required DateTime date,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: date,
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
    locale: const Locale('km'),
    helpText: "Pick a date",
    errorFormatText: 'Enter valid date',
    errorInvalidText: 'Enter date in valid range',
    fieldLabelText: 'Date',
    fieldHintText: 'Date/Month/Year',
  );
  return picked;
}

/// time picker dialog
Future<TimeOfDay?> buildTimePicker({
  required BuildContext context,
  required TimeOfDay time,
}) async {
  return await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.dial,
    initialTime: time,
  );
}

bool isInEnglish(BuildContext context) =>
    Localizations.localeOf(context) == L10n.all[1];

void goBack(BuildContext context) {
  Navigator.of(context).pop();
}

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');

    if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty)) {
      return true;
    } else {
      return false;
    }
  } on SocketException {
    return false;
  }
}

DateTime? convertStringToDateTime(String? str) {
  if (str == null) return null;
  return DateTime.tryParse(str);
}

String? convertDateTimeToString(DateTime? datetime) {
  if (datetime == null) return null;
  return datetime.toIso8601String();
}

convertDateToddMMy(DateTime? datetime) {
  if (datetime == null) return "00-00-0000";
  return DateFormat('dd-MM-y')
      .format(DateTime.parse(datetime.toIso8601String()));
}

TimeOfDay? convertStringToTime(String? str) {
  List<String>? list = str?.split(':');
  if (list == null) return null;

  int? hour = int.tryParse(list[0]);
  int? minute = int.tryParse(list[1]);

  return TimeOfDay(hour: hour ?? 0, minute: minute ?? 0);
}

Duration? convertStringToDuration(String? str) {
  List<String>? list = str?.split(':');
  if (list == null || str == null) return null;

  int? hour = int.tryParse(list[0]);
  int? minute = int.tryParse(list[1]);
  int? seconds = int.tryParse(list[2]);

  return Duration(
    hours: hour as int,
    minutes: minute as int,
    seconds: seconds as int,
  );
}

String convertDurationToString(Duration? duration) {
  if (duration == null) return "00:00:00";
  var arr = duration.toString().split(":");

  String hours = arr[0].padLeft(2, '0');
  String minutes = arr[1].padLeft(2, '0');
  String seconds = arr[2].split(".")[0].padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

String convertTimeToString(TimeOfDay? time) {
  if (time == null) return "00:00:00";

  String hour = time.hour.toString().padLeft(2, '0');
  String minute = time.minute.toString().padLeft(2, '0');

  return "$hour:$minute:00";
}

// parse id from json to int || null
intParse(dynamic id) {
  return int.tryParse('$id');
}

// parse number from json to double || null
doubleParse(dynamic number) {
  try {
    return double.parse('$number');
  } catch (err) {
    return 0.0;
  }
}
