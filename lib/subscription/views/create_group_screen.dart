import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/subscription/widgets/input_card.dart';
import 'package:yansnet/subscription/widgets/validated_button.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer un groupe',
          style: GoogleFonts.jua(),
        ),
      ),
      body: Column(
        children: [
          InputCard(
            align: TextAlign.start,
            controller: TextEditingController(),
            enabled: true,
            onChanged: (p0) {},
            validator: (p0) {
              return '';
            },
            obscureText: false,
            inputType: TextInputType.text,
            borderEnabled: true,
            label: 'Nom du groupe',
          ),
          InputCard(
            align: TextAlign.start,
            controller: TextEditingController(),
            enabled: true,
            onChanged: (p0) {},
            validator: (p0) {
              return '';
            },
            obscureText: false,
            inputType: TextInputType.text,
            borderEnabled: true,
            label: 'Description',
          ),
          ValidatedButton(onTap: () {}, text: 'Créer'),
        ],
      ),
    );
  }
}
