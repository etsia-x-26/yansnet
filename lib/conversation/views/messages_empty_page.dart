import 'package:flutter/material.dart';
import 'package:yansnet/conversation/widgets/empty_state_widget.dart';

class MessagesEmptyPage extends StatelessWidget {
  const MessagesEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                title: "Oups !!! Tu n'as pas \n encore de message",
                subtitle: 'Tes messages apparaîtront ici une \n'
                    'fois que tu les auras reçus.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
