import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/domain/auth_domain.dart';
import 'instagram_chat_screen.dart';
import 'instagram_group_name_screen.dart';

class InstagramContactSelectorScreen extends StatefulWidget {
  const InstagramContactSelectorScreen({super.key});

  @override
  State<InstagramContactSelectorScreen> createState() =>
      _InstagramContactSelectorScreenState();
}

class _InstagramContactSelectorScreenState
    extends State<InstagramContactSelectorScreen> {
  final Set<User> _selectedUsers = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Charger les données réseau au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = context.read<AuthProvider>().currentUser;
      if (currentUser != null) {
        context.read<NetworkProvider>().loadNetworkData(currentUser.id);
      }
    });
  }

  @override
  void dispose() {
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

  void _handleNext() {
    if (_selectedUsers.isEmpty) return;

    if (_selectedUsers.length == 1) {
      // Conversation 1-to-1
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstagramChatScreen(
            recipientUser: _selectedUsers.first,
            isGroup: false,
          ),
        ),
      );
    } else {
      // Groupe - demander le nom
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InstagramGroupNameScreen(selectedUsers: _selectedUsers.toList()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final networkProvider = context.watch<NetworkProvider>();

    // Filtrer pour obtenir uniquement les utilisateurs connectés
    final connectedUsers = networkProvider.suggestions
        .where(
          (suggestion) =>
              networkProvider.isUserConnected(suggestion.user.id) &&
              suggestion.user.id != currentUser?.id,
        )
        .map((suggestion) => suggestion.user)
        .where(
          (user) =>
              _searchQuery.isEmpty ||
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (user.username?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();

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
          'New message',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_selectedUsers.isNotEmpty)
            TextButton(
              onPressed: _handleNext,
              child: Text(
                'Next',
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
          // Barre de recherche
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Text(
                  'To:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                // Chips des utilisateurs sélectionnés
                if (_selectedUsers.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _selectedUsers.map((user) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Chip(
                              backgroundColor: const Color(0xFFE8F5E9),
                              deleteIconColor: const Color(0xFF1313EC),
                              label: Text(
                                user.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: const Color(0xFF1313EC),
                                ),
                              ),
                              onDeleted: () => _toggleUserSelection(user),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Liste des contacts
          Expanded(
            child: connectedUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No connections yet'
                              : 'No results found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connect with people to start messaging',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: connectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = connectedUsers[index];
                      final isSelected = _selectedUsers.contains(user);

                      return InkWell(
                        onTap: () => _toggleUserSelection(user),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Checkbox circulaire
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF1313EC)
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFF1313EC)
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              // Avatar
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
                              const SizedBox(width: 12),
                              // Nom et username
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (user.username != null)
                                      Text(
                                        '@${user.username}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
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
