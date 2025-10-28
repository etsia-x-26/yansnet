import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure this is imported
import '../widgets/messages_app_bar.dart'; // Ensure this import is correct
import '../widgets/empty_state_widget.dart';
import '../widgets/no_connection_illustration.dart';
import '../widgets/add_floating_button.dart';

class MessagesNoConnectionPage extends StatelessWidget {
  const MessagesNoConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MessagesAppBar(
        title: 'Messages',
        onBackPressed: () => Navigator.of(context).pop(),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: EmptyStateWidget(
          illustration: NoConnectionIllustration(),
          title: 'Oups !!! tu n\'es pas connecté\nImpossible de charger les\nmessages',
          subtitle: null,
        ),
      ),
      floatingActionButton: AddFloatingButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tentative de reconnexion...')),
          );
        },
      ),
    );
  }
}