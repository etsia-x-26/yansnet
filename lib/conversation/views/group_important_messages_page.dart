import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupImportantMessagesPage extends StatelessWidget {
  GroupImportantMessagesPage({
    required this.groupName,
    super.key,
  });

  final String groupName;

  // Données mockées pour les messages marqués importants par l'utilisateur
  final List<ImportantMessage> _importantMessages = [
    const ImportantMessage(
      id: '1',
      text: 'Rappel : Réunion importante demain à 14h',
      senderName: 'Axelle Bakery',
      date: '15/01/2025',
      time: '10:30',
    ),
    const ImportantMessage(
      id: '2',
      text: 'Le rapport final doit être soumis avant vendredi',
      senderName: 'Emmy',
      date: '14/01/2025',
      time: '16:45',
    ),
    const ImportantMessage(
      id: '3',
      text: 'N\'oubliez pas de mettre à jour vos tâches sur le tableau de bord',
      senderName: 'Victoire',
      date: '13/01/2025',
      time: '09:15',
    ),
    const ImportantMessage(
      id: '4',
      text: 'Les documents sont disponibles dans le dossier partagé',
      senderName: 'Passi',
      date: '12/01/2025',
      time: '11:20',
    ),
    const ImportantMessage(
      id: '5',
      text: 'Deadline reportée au lundi prochain',
      senderName: 'Pixsie',
      date: '11/01/2025',
      time: '14:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Messages importants - $groupName',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _importantMessages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun message important',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les messages que vous marquez comme importants\napparaîtront ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _importantMessages.length,
              itemBuilder: (context, index) {
                final message = _importantMessages[index];
                return _buildMessageItem(context, message);
              },
            ),
    );
  }

  Widget _buildMessageItem(BuildContext context, ImportantMessage message) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message.senderName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${message.date} ${message.time}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message.text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Action pour retirer l'étoile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message retiré des messages importants'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star_border, size: 18),
                  label: const Text('Retirer'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImportantMessage {
  const ImportantMessage({
    required this.id,
    required this.text,
    required this.senderName,
    required this.date,
    required this.time,
  });

  final String id;
  final String text;
  final String senderName;
  final String date;
  final String time;
}

