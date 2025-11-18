import 'package:flutter/material.dart';

class GroupActionsSection extends StatelessWidget {
  const GroupActionsSection({
    required this.onLeaveGroup,
    required this.onClearConversation,
    super.key,
  });

  final VoidCallback onLeaveGroup;
  final VoidCallback onClearConversation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Bouton Quitter le groupe
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onLeaveGroup,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Quitter le groupe',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Bouton Effacer la discussion
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onClearConversation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Effacer la discussion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

