import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/conversation/widgets/chat_input_bar.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({
    required this.groupName,
    required this.groupAvatar,
    required this.memberCount,
    this.isUserAdmin = false,
    super.key,
  });

  final String groupName;
  final String groupAvatar;
  final int memberCount;
  final bool isUserAdmin;

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final TextEditingController _messageController = TextEditingController();
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
      // TODO: Envoyer le message au groupe
      _messageController.clear();
      _hasText = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () {
            // Navigation vers la page de détails du groupe
            final encodedName = Uri.encodeComponent(widget.groupName);
            context.push(
              '/group/$encodedName/info',
              extra: {
                'groupAvatar': widget.groupAvatar,
                'memberCount': widget.memberCount,
                'isUserAdmin': widget.isUserAdmin,
              },
            );
          },
          child: Row(
            children: [
              // Avatar du groupe
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.groupAvatar),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.memberCount} membres',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Navigation vers la page de détails du groupe
              final encodedName = Uri.encodeComponent(widget.groupName);
              context.push(
                '/group/$encodedName/info',
                extra: {
                  'groupAvatar': widget.groupAvatar,
                  'memberCount': widget.memberCount,
                  'isUserAdmin': widget.isUserAdmin,
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Aujourd'hui",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Message de bienvenue
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Bienvenue dans le groupe de votre promotion, '
                      'vous avez été automatiquement intégré à ce groupe. '
                      'Vous pouvez désormais échanger avec les autres membres.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barre de saisie
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
