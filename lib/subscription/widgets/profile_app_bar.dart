import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(110), // Hauteur de l'AppBar
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Stack(
          clipBehavior: Clip.none, // Permet aux widgets enfants de déborder
          children: [
            // Image de fond en haut (la bande marron)
            Positioned.fill(
              child: Container(
                color: const Color(0xFF5D1225), // Couleur marron foncée
              ),
            ),

            // Avatar de profil (celui qui déborde en bas à gauche de l'AppBar)
            Positioned(
              left: 16,
              // Marge à gauche
              bottom: -35,
              // Moitié du rayon de l'avatar pour le faire déborder
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Couleur de fond du cercle blanc autour de l'avatar
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ), // Bordure blanche autour
                ),
                child: const CircleAvatar(
                  radius: 35,
                  // Rayon de l'avatar
                  backgroundColor: Colors.white,
                  // Fond de l'avatar
                  // Image du circle avatar :
                  backgroundImage: AssetImage('assets/images/test.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
