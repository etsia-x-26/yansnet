import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/auth/domain/auth_domain.dart';
import 'instagram_chat_screen.dart';

class InstagramGroupNameScreen extends StatefulWidget {
  final List<User> selectedUsers;

  const InstagramGroupNameScreen({super.key, required this.selectedUsers});

  @override
  State<InstagramGroupNameScreen> createState() =>
      _InstagramGroupNameScreenState();
}

class _InstagramGroupNameScreenState extends State<InstagramGroupNameScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _createGroup() {
    if (_groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a group name',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramChatScreen(
          recipientUser: widget.selectedUsers.first,
          isGroup: true,
          groupName: _groupNameController.text.trim(),
          groupMembers: widget.selectedUsers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Name this group',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createGroup,
            child: Text(
              'Create',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1313EC),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Avatars des membres
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.selectedUsers.length,
              itemBuilder: (context, index) {
                final user = widget.selectedUsers[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: user.profilePictureUrl != null
                            ? NetworkImage(user.profilePictureUrl!)
                            : null,
                        child: user.profilePictureUrl == null
                            ? Text(
                                user.name[0].toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Champ de saisie du nom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _groupNameController,
              autofocus: true,
              style: GoogleFonts.plusJakartaSans(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Group name (required)',
                hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose a name that describes what the group is about',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
