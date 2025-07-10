import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/profile/view/modifier_profil_nom.dart';
import 'package:yansnet/profile/widgets/profilListTile.dart';

class ModifierProfilPage extends StatelessWidget {
  const ModifierProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFF3A3541), // cercle violet foncé
            radius: 16,
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Informations profil',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Avatar utilisateur
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),

          // Nom
          Text(
            'Pixsellz',
            style: GoogleFonts.jua(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          // Pseudo
          const SizedBox(height: 4),
          Text(
            '@pixsellz',
            style: GoogleFonts.aBeeZee(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

          // Bloc des 3 options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: Column(
                children: [
                  ProfilListTile (title: 'Nom'),
                  const Divider(height: 1),
                  ProfilListTile(title: 'Nom de profil'),
                  const Divider(height: 1),
                  ProfilListTile(title: 'Photo de profil'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
