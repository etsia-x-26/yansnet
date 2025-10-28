import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifierNomPage extends StatefulWidget {
  const ModifierNomPage({super.key});

  @override
  State<ModifierNomPage> createState() => _ModifierNomPageState();
}

class _ModifierNomPageState extends State<ModifierNomPage> {
  final TextEditingController _controller = TextEditingController(text: 'Pixsellz');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFF3A3541), // cercle violet foncé
            radius: 16,
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nom du profil',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Champ nom
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),

            const Spacer(),

            // Bouton enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // logique de sauvegarde ici
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B0017), // Couleur violette
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Enregistrer',
                  style: GoogleFonts.jua(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
