import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';

class NotAvailablePage extends StatelessWidget {
  const NotAvailablePage({required this.pageName, super.key});
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$pageName is not avaible yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28.spMax,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor, // Couleur sombre du logo
                  letterSpacing: 0.5,
                  fontFamily: GoogleFonts.jua().fontFamily
              ),
            )
          ],
        ),
      ),
    );
  }
}
