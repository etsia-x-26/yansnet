import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure this is imported
import '../widgets/messages_app_bar.dart'; // Ensure this import is correct
import '../widgets/empty_state_widget.dart';

class MessagesEmptyPage extends StatelessWidget {
  const MessagesEmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MessagesAppBar(
        title: 'Messages',
        onBackPressed: () => Navigator.of(context).pop(),
        backgroundColor: Colors.white, // Clean background
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keeps content compact
            children: [
              Image.asset(
                'assets/images/Empty-bro 1.png', // Ensure this path is correct
                width: 500,
                height: 450,
                fit: BoxFit.contain,
              ),
              const EmptyStateWidget(
                illustration: SizedBox.shrink(),
                title: 'Oups !!! Tu n\'as pas\nencore de message',
                subtitle: 'Tes messages apparaîtront ici une\nfois que tu les auras reçus.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}