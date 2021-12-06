import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// COLORS
const kBlue = Color(0xFF05445E);
const kDarkestBlue = Color(0xff043347);
const kLightBlue = Color(0xffffffff);
const kWhite = Color(0xffffffff);
const kBlack = Color(0xff000000);
const kRedText = Color(0xffa03e3e);
const kRedBackground = Color(0xffffcbce);
const kGreenText = Color(0xff334732);
const kGreenBackground = Color(0xff9ce29b);
const kYellowText = Color(0xff4E5133);
const kYellowBackground = Color(0xffF2E572);
const kBlueText = Color(0xff334D51);
const kBlueBackground = Color(0xff72CCF2);

// TEXT
const kHeadingOne =
    TextStyle(fontSize: 26, color: kWhite, fontWeight: FontWeight.w700);
const kHeadingTwo =
    TextStyle(fontSize: 24, color: kWhite, fontWeight: FontWeight.w700);
const kHeadingThree =
    TextStyle(fontSize: 20, color: kWhite, fontWeight: FontWeight.w700);
const kHeadingFour =
    TextStyle(fontSize: 18, color: kWhite, fontWeight: FontWeight.w700);
const kParagraph =
    TextStyle(fontSize: 16, color: kWhite, fontWeight: FontWeight.w400);
const kSubtitle =
    TextStyle(fontSize: 14, color: kWhite, fontWeight: FontWeight.w400);
var kSubtitleTwo = TextStyle(
    fontSize: 12, color: kWhite.withOpacity(0.5), fontWeight: FontWeight.w400);

// Spacing
const kPadding = EdgeInsets.symmetric(horizontal: 20);
const kPaddingAll = EdgeInsets.all(15);
const kBorderRadius = Radius.circular(10);

ThemeData get themeData {
  return ThemeData.dark().copyWith(
    // dialogBackgroundColor: kBlue,
    dialogTheme: DialogTheme(
      titleTextStyle: kHeadingThree,
      backgroundColor: kDarkestBlue,
      contentTextStyle: kParagraph,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kWhite,
      selectionColor: kBlack.withOpacity(0.25),
    ),
    timePickerTheme: TimePickerThemeData(
      hourMinuteTextColor: kWhite,
      hourMinuteColor: kDarkestBlue,
      dayPeriodTextColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected) ? kWhite : kBlue,
      ),
      dayPeriodColor: kDarkestBlue,
      dialHandColor: kWhite.withOpacity(0.75),
      dialBackgroundColor: kDarkestBlue,
      dialTextColor: kWhite,
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      // helpTextStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: kSubtitle.copyWith(color: kSubtitle.color!.withOpacity(0.5)),
      contentPadding: const EdgeInsets.all(15),
      filled: true,
      fillColor: Colors.black.withOpacity(0.25),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(kBorderRadius),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(kBorderRadius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        primary: kWhite,
        backgroundColor: kBlue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    ),
    colorScheme: const ColorScheme(
      primary: kBlue,
      primaryVariant: kDarkestBlue,
      secondary: kBlue,
      secondaryVariant: kLightBlue,
      surface: kBlue,
      background: kBlue,
      error: kRedText,
      onPrimary: kWhite,
      onSecondary: kWhite,
      onSurface: kWhite,
      onBackground: kWhite,
      onError: kWhite,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      headline1: kHeadingOne,
      headline2: kHeadingTwo,
      headline3: kHeadingThree,
      headline4: kHeadingFour,
      caption: kParagraph,
      bodyText1: kParagraph,
      subtitle1: kSubtitle,
    ),
    scaffoldBackgroundColor: kBlue,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: kBlue,
      titleTextStyle: kHeadingThree,
      elevation: 0,
    ),
  );
}
