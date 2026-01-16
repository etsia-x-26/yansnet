import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../network/presentation/providers/network_provider.dart';
import '../providers/chat_provider.dart';
// For User entity
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../screens/chat_detail_screen.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final List<int> _selectedUserIds = [];
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load suggestions or friends to pick from
      // Assuming we pick from 'Network Suggestions' or specific friend list.
      // For now, let's use suggestions as the pool of users.
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        context.read<NetworkProvider>().loadNetworkData(userId);
      }
    });
  }

  void _toggleSelection(int userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  Future<void> _createChat() async {
    if (_selectedUserIds.isEmpty) return;

    setState(() => _isCreating = true);

    try {
      if (_selectedUserIds.length == 1) {
        // Direct Message
        final userId = _selectedUserIds.first;
        final conversation = await context.read<ChatProvider>().startChat(userId);
        if (conversation != null && mounted) {
           final currentUserId = context.read<AuthProvider>().currentUser?.id ?? 0;
           final otherUser = conversation.getOtherUser(currentUserId);
           Navigator.pop(context); // Close the new chat screen
           Navigator.push(
             context, 
             MaterialPageRoute(
               builder: (_) => ChatDetailScreen(
                 conversation: conversation,
                 otherUser: otherUser,
               ),
             ),
           );
        }
      } else {
        // Group Chat
        final conversation = await context.read<ChatProvider>().createGroup(_selectedUserIds, "New Group");
        if (conversation != null && mounted) {
           Navigator.pop(context); // Close the new chat screen
           Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(conversation: conversation)));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using NetworkProvider's suggestions as "Users to chat with" for demo purposes
    // Ideally this should be a "Friends" list or "Search Users".
    final users = context.watch<NetworkProvider>().suggestions.map((s) => s.user).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Message',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _selectedUserIds.isEmpty ? null : _createChat,
              child: Text(
                _selectedUserIds.length > 1 ? 'Create Group' : 'Chat',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: _selectedUserIds.isEmpty ? Colors.grey : const Color(0xFF1DA1F2),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isCreating 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isSelected = _selectedUserIds.contains(user.id);

              return ListTile(
                onTap: () => _toggleSelection(user.id),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: user.profilePictureUrl != null 
                        ? NetworkImage(user.profilePictureUrl!)
                        : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
                    ),
                    if (isSelected)
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Color(0xFF1DA1F2),
                          child: Icon(Icons.check, size: 12, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  user.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '@${user.username}',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
    );
  }
}
