import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'enhanced_chat_detail_screen.dart';
import 'create_group_chat_screen.dart';

class SelectContactsScreen extends StatefulWidget {
  final String title;
  final bool allowMultiple;
  final List<int> excludeUserIds;

  const SelectContactsScreen({
    super.key,
    required this.title,
    this.allowMultiple = true,
    this.excludeUserIds = const [],
  });

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedUsers = <int>{};
  List<dynamic> _filteredContacts = [];
  List<dynamic> _allContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadContacts() {
    // Mock data - replace with actual contacts from your network
    _allContacts =
        List.generate(
              20,
              (index) => {
                'id': index + 1,
                'name': 'Contact ${index + 1}',
                'username': '@contact${index + 1}',
                'profilePictureUrl':
                    'https://picsum.photos/200/200?random=${index + 1}',
                'isOnline': index % 3 == 0,
                'lastSeen': DateTime.now().subtract(
                  Duration(minutes: index * 5),
                ),
              },
            )
            .where((contact) => !widget.excludeUserIds.contains(contact['id']))
            .toList();

    _filteredContacts = List.from(_allContacts);
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        final name = contact['name'].toString().toLowerCase();
        final username = contact['username'].toString().toLowerCase();
        return name.contains(query) || username.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (widget.allowMultiple && _selectedUsers.isNotEmpty)
              Text(
                '${_selectedUsers.length} selected',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          if (widget.allowMultiple && _selectedUsers.isNotEmpty)
            TextButton(
              onPressed: _proceedWithSelection,
              child: Text(
                'Next',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1313EC),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (widget.allowMultiple && _selectedUsers.isNotEmpty)
            _buildSelectedUsers(),
          Expanded(child: _buildContactsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.plusJakartaSans(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUsers() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedUsers.length,
        itemBuilder: (context, index) {
          final userId = _selectedUsers.elementAt(index);
          final contact = _allContacts.firstWhere((c) => c['id'] == userId);

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        contact['profilePictureUrl'],
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedUsers.remove(userId);
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  contact['name'].split(' ')[0],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactsList() {
    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No contacts found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final isSelected = _selectedUsers.contains(contact['id']);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleContactTap(contact),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          contact['profilePictureUrl'],
                        ),
                      ),
                      if (contact['isOnline'])
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['name'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact['username'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.allowMultiple)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1313EC)
                              : Colors.grey[400]!,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleContactTap(Map<String, dynamic> contact) {
    if (widget.allowMultiple) {
      setState(() {
        if (_selectedUsers.contains(contact['id'])) {
          _selectedUsers.remove(contact['id']);
        } else {
          _selectedUsers.add(contact['id']);
        }
      });
    } else {
      // Start direct conversation
      _startDirectConversation(contact);
    }
  }

  void _startDirectConversation(Map<String, dynamic> contact) {
    // Create or find existing conversation
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedChatDetailScreen(
          conversationId: 0, // Will be created
          otherUser: contact,
        ),
      ),
    );
  }

  void _proceedWithSelection() {
    if (_selectedUsers.isEmpty) return;

    if (_selectedUsers.length == 1) {
      // Start direct conversation
      final contact = _allContacts.firstWhere(
        (c) => c['id'] == _selectedUsers.first,
      );
      _startDirectConversation(contact);
    } else {
      // Create group chat
      final selectedContacts = _allContacts
          .where((c) => _selectedUsers.contains(c['id']))
          .toList();

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreateGroupChatScreen(preSelectedContacts: selectedContacts),
        ),
      );
    }
  }
}
