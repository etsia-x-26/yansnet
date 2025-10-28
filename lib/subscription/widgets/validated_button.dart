import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';

class ValidatedButton extends StatelessWidget {
  const ValidatedButton({required this.onTap, required this.text, super.key});
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        //width: 275,
        margin: const EdgeInsets.only(top: 24, bottom: 24, left: 50, right: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor,),
        child: Center(
            child: Text(
              text,
              style: GoogleFonts.aBeeZee(
                  color: Colors.white, fontSize: 18,),
            ),),
      ),
    );
  }
}
