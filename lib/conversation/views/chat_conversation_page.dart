import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/conversation/widgets/chat_header.dart';
import 'package:yansnet/conversation/widgets/chat_input_bar.dart';
import 'package:yansnet/conversation/widgets/chat_message_bubble.dart';

class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({
    required this.userName,
    required this.userAvatar,
    required this.lastSeen,
    super.key,
  });

  final String userName;
  final String userAvatar;
  final String lastSeen;

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

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': text,
          'isMe': true,
          'time': TimeOfDay.now().format(context),
        });
      });
      _messageController.clear();
      _hasText = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ChatHeader(
        userName: widget.userName,
        userAvatar: widget.userAvatar,
        lastSeen: widget.lastSeen,
        onBackPressed: () => context.pop(),
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
            child: const Text(
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
          ChatInputBar(
            controller: _messageController,
            onSendPressed: (text) => _sendMessage(),
            hasText: _hasText,
            hintText: 'Votre message',
            onEmojiPressed: () {},
            onAddPressed: () {},
            onMicPressed: () {},
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
