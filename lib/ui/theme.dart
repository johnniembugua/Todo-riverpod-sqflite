import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/theme_services.dart';

class Themes {
  static final light = ThemeData(
    //primaryColor: white,
    colorSchemeSeed: primaryClr,
    //colorScheme: ColorScheme(brightness: Brightness.light, primary: white, onPrimary: onPrimary, secondary: secondary, onSecondary: onSecondary, error: error, onError: onError, background: background, onBackground: onBackground, surface: surface, onSurface: onSurface),
    backgroundColor: white,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    colorSchemeSeed: darkGreyClr,
    backgroundColor: darkGreyClr,
    //primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xff1221212);
Color darkHeaderClr = Colors.grey.shade800;

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ));
}
