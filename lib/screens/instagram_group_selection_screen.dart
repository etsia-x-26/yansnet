import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/domain/auth_domain.dart';
import 'instagram_chat_screen.dart';

class InstagramGroupSelectionScreen extends StatefulWidget {
  const InstagramGroupSelectionScreen({super.key});

  @override
  State<InstagramGroupSelectionScreen> createState() => _InstagramGroupSelectionScreenState();
}

class _InstagramGroupSelectionScreenState extends State<InstagramGroupSelectionScreen> {
  final Set<User> _selectedUsers = {};
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = context.read<AuthProvider>().currentUser;
      if (currentUser != null) {
        context.read<NetworkProvider>().loadNetworkData(currentUser.id);
      }
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleUserSelection(User user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  void _createGroup() {
    if (_selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sélectionnez au moins une personne', style: GoogleFonts.plusJakartaSans()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final groupName = _groupNameController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramChatScreen(
          recipientUser: _selectedUsers.first,
          isGroup: _selectedUsers.length > 1,
          groupName: _selectedUsers.length > 1 ? (groupName.isEmpty ? 'Groupe' : groupName) : null,
          groupMembers: _selectedUsers.length > 1 ? _selectedUsers.toList() : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final networkProvider = context.watch<NetworkProvider>();

    final allUsers = networkProvider.suggestions
        .where((suggestion) => suggestion.user.id != currentUser?.id)
        .map((suggestion) => suggestion.user)
        .where((user) =>
    _searchQuery.isEmpty ||
        user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (user.username?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .toList();

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
          'Nouvelle discussion de groupe',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _selectedUsers.isEmpty ? null : _createGroup,
            child: Text(
              'Créer',
              style: GoogleFonts.plusJakartaSans(
                color: _selectedUsers.isEmpty ? Colors.grey : const Color(0xFF1313EC),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                hintText: 'Nom du groupe (facultatif)',
                hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher',
                hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Suggestions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: allUsers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Aucun utilisateur trouvé', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            )
                : ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, index) {
                final user = allUsers[index];
                final isSelected = _selectedUsers.contains(user);

                return InkWell(
                  onTap: () => _toggleUserSelection(user),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: user.profilePictureUrl != null ? NetworkImage(user.profilePictureUrl!) : null,
                          backgroundColor: Colors.grey[300],
                          child: user.profilePictureUrl == null
                              ? Text(user.name[0].toUpperCase(), style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600)),
                              if (user.username != null)
                                Text(user.username!, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: isSelected ? const Color(0xFF1313EC) : Colors.grey[400]!, width: 2),
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected ? const Color(0xFF1313EC) : Colors.transparent,
                          ),
                          child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
