import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatConversationPage extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final String lastSeen;

  const ChatConversationPage({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.lastSeen,
  }) : super(key: key);

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Bonjour',
      'isMe': false,
      'time': '14:30',
    },
    {
      'text': 'Ça va ?',
      'isMe': false,
      'time': '14:31',
    },
    {
      'text': 'Oui',
      'isMe': true,
      'time': '14:32',
    },
    {
      'text': 'Et toi ?',
      'isMe': true,
      'time': '14:32',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ChatHeader(
        userName: widget.userName,
        userAvatar: widget.userAvatar,
        lastSeen: widget.lastSeen,
        onBackPressed: () => Navigator.of(context).pop(),
        onCallPressed: () {
          // Action pour appel audio
        },
        onVideoCallPressed: () {
          // Action pour appel vidéo
        },
        onMorePressed: () {
          // Action pour plus d'options
        },
      ),
      body: Column(
        children: [
          // Séparateur de date
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Aujourd'hui",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Liste des messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessageBubble(
                  text: message['text'] as String,
                  isMe: message['isMe'] as bool,
                  time: message['time'] as String,
                );
              },
            ),
          ),
          // Champ de saisie de message avec design similaire à GroupChatPage
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4), // Padding pour la bordure
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF5D1A1A), // Couleur violet/marron de la bordure
                width: 2, // Épaisseur de la bordure
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Icône Instagram-like
                  IconButton(
                    // icon: const FaIcon(FontAwesomeIcons.instagram, size: 24, color: Colors.grey),
                    icon: const Icon(Iconsax.instagram),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Action pour Instagram
                    },
                  ),
                  const SizedBox(width: 8),
                  // Champ de texte
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Votre message",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 15),
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          setState(() {
                            _messages.add({
                              'text': text,
                              'isMe': true,
                              'time': TimeOfDay.now().format(context),
                            });
                          });
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bouton "+"
                  IconButton(
                    icon: const Icon(Icons.add, size: 24, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Action pour ajouter une pièce jointe
                    },
                  ),
                  const SizedBox(width: 8),
                  // Bouton micro
                  IconButton(
                    icon: const Icon(Icons.mic, size: 24, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Action pour enregistrer un message vocal
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}