import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlumniSpotlightCard extends StatelessWidget {
  final String name;
  final String headline;
  final String classInfo;
  final String quote;

  const AlumniSpotlightCard({
    super.key,
    required this.name,
    required this.headline,
    required this.classInfo,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    // Single Dark Block - keeping this as a variety element
    return Container(
      color: Colors.black, // Full width dark block
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
           Text(
             'ALUMNI SPOTLIGHT',
             style: GoogleFonts.outfit(
               color: Colors.grey[400],
               fontSize: 12,
               letterSpacing: 2,
               fontWeight: FontWeight.bold,
             ),
           ),
           const SizedBox(height: 16),
           const CircleAvatar(
             radius: 32,
             backgroundImage: AssetImage('assets/images/onboarding_welcome.png'),
           ),
           const SizedBox(height: 12),
           Text(
             name,
             style: GoogleFonts.plusJakartaSans(
               color: Colors.white,
               fontSize: 14, // Reduced to 14
               fontWeight: FontWeight.bold,
             ),
           ),
           Text(
             headline,
             style: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 11), // Reduced to 11
           ),
           const SizedBox(height: 16),
           Text(
             '"$quote"',
             textAlign: TextAlign.center,
             style: GoogleFonts.plusJakartaSans(
               color: Colors.white,
               fontSize: 13, // Reduced to 13
               fontStyle: FontStyle.italic,
               height: 1.4,
             ),
           ),
        ],
      ),
    );
  }
}
