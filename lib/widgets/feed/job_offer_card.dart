import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobOfferCard extends StatelessWidget {
  final String companyName;
  final String timePosted;
  final String description;
  final String bannerImageUrl;

  const JobOfferCard({
    super.key,
    required this.companyName,
    required this.timePosted,
    required this.description,
    required this.bannerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // "Promoted Tweet" / LinkedIn Post Style
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           // Company Logo (Avatar position)
           Container(
             width: 48,
             height: 48,
             decoration: BoxDecoration(
               color: Colors.grey[100],
               borderRadius: BorderRadius.circular(8),
               image: const DecorationImage(
                 image: AssetImage('assets/images/onboarding_opportunities.png'),
                 fit: BoxFit.cover,
               ),
             ),
           ),
           const SizedBox(width: 12),
           
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Header
                 Row(
                   children: [
                     Expanded(
                        child: Text(
                          companyName,
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13), // Reduced to 13
                        ),
                     ),
                     Text(
                       'Promoted',
                       style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey[500]), // Reduced to 10
                     ),
                   ],
                 ),
                 Text(
                   timePosted,
                   style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey[500]), // Reduced to 10
                 ),
                 
                 const SizedBox(height: 8),
                 // Description
                 Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.4), // Reduced to 12
                 ),
                 
                 const SizedBox(height: 12),
                 
                 // Rich Link / Banner
                 Container(
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey.withOpacity(0.3)),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       ClipRRect(
                         borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                         child: Image.asset(
                           'assets/images/onboarding_collaborate.png',
                           height: 140,
                           width: double.infinity,
                           fit: BoxFit.cover,
                         ),
                       ),
                       Container(
                         padding: const EdgeInsets.all(12),
                         color: const Color(0xFFF7F9F9),
                         width: double.infinity,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'Senior Product Designer',
                                   style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 11), // Reduced to 11
                                 ),
                                 const SizedBox(height: 2),
                                 Text(
                                   'airbnb.com/careers',
                                   style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 10), // Reduced to 10
                                 ),
                               ],
                             ),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                               decoration: BoxDecoration(
                                 color: Colors.black,
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               child: Text(
                                 'Apply',
                                 style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight. bold, fontSize: 10), // Reduced to 10
                               ),
                             )
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
        ],
      ),
    );
  }
}
