import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts'; // Import Google Fonts
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String? subtitle;

  const EmptyStateWidget({
    Key? key,
    required this.illustration,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Illustration with minimal padding
        Container(
          padding: const EdgeInsets.all(0.0), // Removed padding to avoid hiding the image
          child: illustration, // Renders the NoConnectionIllustration
        ),
        // No SizedBox to ensure title is directly after image
        // Titre
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.jua(
            fontSize: subtitle != null ? 22 : 16,
            fontWeight: subtitle != null ? FontWeight.bold : FontWeight.normal,
            color: subtitle != null ? Colors.black : Colors.grey,
            height: 1.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          // Sous-titre
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: GoogleFonts.jua(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}