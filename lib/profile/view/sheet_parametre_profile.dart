import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/profile/view/modifier_profil.dart';

class SettingsSheetPage extends StatelessWidget {
  const SettingsSheetPage({
    required this.userId,
    required this.username,
    super.key,
  });

  final String userId;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFF3A3541), // cercle violet foncé
            radius: 16,
            child:
                Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Paramètres de @$username',
          style: GoogleFonts.jua(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //child: SearchBarWidget(),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6EAEE),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          ListTile(
            title: Text(
              'Informations du compte',
              style: GoogleFonts.aBeeZee(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ModifierProfilPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Préférences',
              style: GoogleFonts.aBeeZee(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
