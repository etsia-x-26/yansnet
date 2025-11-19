import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/group_member.dart';

class GroupDialogs {
  static void showAddMembersDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter des membres'),
        content: const Text(
          'Fonctionnalité à venir ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showLeaveGroupDialog(
    BuildContext context,
    String groupName,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le groupe'),
        content: Text(
          'Êtes-vous sûr de vouloir quitter le groupe "$groupName" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              'Quitter',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static void showClearConversationDialog(
    BuildContext context,
    String groupName,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer la discussion'),
        content: Text(
          'Êtes-vous sûr de vouloir effacer tous les messages de "$groupName". ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              'Effacer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static void showPromoteToAdminDialog(
    BuildContext context,
    GroupMember member,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promouvoir en admin'),
        content: Text(
          'Voulez-vous promouvoir "${member.name}" en administrateur ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Promouvoir'),
          ),
        ],
      ),
    );
  }

  static void showRevokeAdminRightsDialog(
    BuildContext context,
    GroupMember member,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Révoquer les droits d\'admin'),
        content: Text(
          'Voulez-vous révoquer les droits d\'administrateur de "${member.name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              'Révoquer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static void showRemoveMemberDialog(
    BuildContext context,
    GroupMember member,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer du groupe'),
        content: Text(
          'Voulez-vous retirer "${member.name}" du groupe ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              'Retirer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static void showEditGroupInfoDialog(
    BuildContext context,
    String currentName,
    VoidCallback onSave,
  ) {
    final nameController = TextEditingController(text: currentName);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier les informations du groupe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du groupe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: La modification de l\'avatar sera disponible prochainement.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSave();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  static void showEditDescriptionDialog(
    BuildContext context,
    String currentDescription,
    VoidCallback onSave,
  ) {
    final descriptionController = TextEditingController(text: currentDescription);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la description'),
        content: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            hintText: 'Entrez la description du groupe',
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSave();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  static void showChangeAvatarDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'avatar du groupe'),
        content: const Text(
          'Fonctionnalité à venir .',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

