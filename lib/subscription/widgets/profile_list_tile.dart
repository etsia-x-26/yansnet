import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/subscription/views/modifier_profil_nom.dart';


class ProfileListTile extends StatelessWidget {

  const ProfileListTile({required this.title, super.key});
  final String title;

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
