import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';

typedef VoidString = dynamic Function(String);
typedef StringVoidString = String? Function(String?);

class InputCard extends StatelessWidget {
  const InputCard({
    required this.align,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.validator,
    required this.obscureText,
    required this.inputType,
    required this.borderEnabled,
    super.key,
    this.label,
    this.suffix,
    this.prefix,
  });
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign align;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool enabled;
  final bool borderEnabled;
  final VoidString onChanged;
  final StringVoidString validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 16),
      child: TextFormField(
        keyboardType: inputType,
        enabled: enabled,
        textAlign: align,
        style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12),
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        obscureText: obscureText,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          enabled: borderEnabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kSecondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kSecondaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kPrimaryColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kSecondaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kSecondaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kFourthColor,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          prefixIcon: prefix,
          suffixIcon: suffix,
          labelStyle: GoogleFonts.aBeeZee(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
