import 'package:flutter/material.dart';
import 'package:yansnet/conversation/widgets/add_floating_button.dart';
import 'package:yansnet/conversation/widgets/empty_state_widget.dart';
import 'package:yansnet/conversation/widgets/messages_app_bar.dart'; // Ensure this import is correct
import 'package:yansnet/conversation/widgets/no_connection_illustration.dart';

class MessagesNoConnectionPage extends StatelessWidget {
  const MessagesNoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MessagesAppBar(
        title: 'Messages',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: const Center(
        child: EmptyStateWidget(
          illustration: NoConnectionIllustration(),
          title: "Oups !!! tu n'es pas connecté\nImpossible de charger les\nmessages",
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