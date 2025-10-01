import 'package:flutter/material.dart';
import 'package:yansnet/conversation/widgets/empty_state_widget.dart';
import 'package:yansnet/conversation/widgets/messages_app_bar.dart'; // Ensure this import is correct

class MessagesEmptyPage extends StatelessWidget {
  const MessagesEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MessagesAppBar(
        title: 'Messages',
        onBackPressed: () => Navigator.of(context).pop(),
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
                title: "Oups !!! Tu n'as pas\nencore de message",
                subtitle: 'Tes messages apparaîtront ici une\nfois que tu les auras reçus.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}