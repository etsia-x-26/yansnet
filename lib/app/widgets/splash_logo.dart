import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'YansNet',
      style: TextStyle(
        fontSize: 48.spMax,
        fontWeight: FontWeight.w400,
        color: kPrimaryColor, // Couleur sombre du logo
        letterSpacing: 0.5,
        fontFamily: GoogleFonts.jua().fontFamily
      ),
    );
  }
}