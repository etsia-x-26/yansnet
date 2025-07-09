import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

const kPrimaryColor = Color(0xff420C18);
const kSecondaryColor = Color(0xff999999);
const kThirdColor = Color(0xff4C9EEB);
const kFourthColor = Color(0xffDE0046);

class AppTheme{
  static ThemeData getLightTheme(){
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: kPrimaryColor,
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: kPrimaryColor,
          onPrimary: Colors.white,
          secondary: kSecondaryColor,
          onSecondary: Colors.white,
          error: kFourthColor,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black),
      extensions: const [SkeletonizerConfigData()]
    );
  }
}
