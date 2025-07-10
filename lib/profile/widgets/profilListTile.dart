import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/profile/view/modifier_profil_nom.dart';


class ProfilListTile extends StatelessWidget {
  final String title;

  const ProfilListTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.aBeeZee(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: () {
        _navigateToPage(context, title);
      },
    );
  }

  void _navigateToPage(BuildContext context, String title) {
    Widget? destination;

    switch (title) {
      case 'Nom':
        destination = const ModifierNomPage();
        break;
      case 'Nom de profil':
        //destination = const ModifierPseudoPage();
        break;
      case 'Photo de profil':
        //destination = const ModifierPhotoPage();
        break;
      default:
        return; // Rien ne se passe si le titre ne correspond pas
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination!),
    );
  }
}
