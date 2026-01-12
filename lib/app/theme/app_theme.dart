import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0xff420C18);
const kSecondaryColor = Color(0xff999999);
const kThirdColor = Color(0xff4C9EEB);
const kFourthColor = Color(0xffDE0046);

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: kPrimaryColor,
      textTheme: GoogleFonts.notoSansTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: kPrimaryColor,
        onPrimary: Colors.white,
        secondary: kSecondaryColor,
        onSecondary: Colors.white,
        error: kFourthColor,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
    );
  }
}
