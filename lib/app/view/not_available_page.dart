import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotAvailablePage extends StatelessWidget {
  const NotAvailablePage({required this.pageName, super.key});
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
        children: [
          Positioned(
            top: 300,
            left: 58,
            right: 58,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/no_page.png',
                    width: 75,
                    height: 75,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cette page n’est pas encore disponible',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FloatingAddButton(
          //   onPressed: () {
          //     print('Ajout de contenu');
          //   },
          // ),
        ],
      ),
    );
  }
}
