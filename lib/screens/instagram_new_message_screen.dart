import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/network/api_client.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/domain/auth_domain.dart';
import 'instagram_chat_screen.dart';
import 'instagram_group_selection_screen.dart';
import 'instagram_create_channel_screen.dart';

class InstagramNewMessageScreen extends StatefulWidget {
  const InstagramNewMessageScreen({super.key});

  @override
  State<InstagramNewMessageScreen> createState() =>
      _InstagramNewMessageScreenState();
}

class _InstagramNewMessageScreenState extends State<InstagramNewMessageScreen> {
  final Set<User> _selectedUsers = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<User> _searchResults = [];
  bool _isSearching = false;

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final apiClient = ApiClient();
      final response = await apiClient.dio.get('/search/users', queryParameters: {'q': query});

      print('🔍 SEARCH RESPONSE: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<User> users = [];

        if (data is Map && data.containsKey('content')) {
          final List<dynamic> content = data['content'];
          print('🔍 Found ${content.length} users in content');

          for (var json in content) {
            print('🔍 USER JSON: $json');
            print('🔍 Keys: ${json.keys}');

            // Le format de recherche est: {id, type, title, description, imageUrl, metadata}
            final metadata = json['metadata'] as Map<String, dynamic>? ?? {};

            users.add(User(
              id: json['id'] ?? 0,
              email: '', // Not provided in search results
              name: json['title'] ?? 'Utilisateur', // title is the display name
              username: metadata['username'] ?? json['title'],
              bio: json['description'] ?? '',
              profilePictureUrl: json['imageUrl'], // imageUrl instead of profilePictureUrl
              isMentor: metadata['isMentor'] ?? false,
            ));
          }
        } else if (data is List) {
          print('🔍 Found ${data.length} users in list');

          for (var json in data) {
            print('🔍 USER JSON: $json');
            print('🔍 Keys: ${json.keys}');

            // Le format de recherche est: {id, type, title, description, imageUrl, metadata}
            final metadata = json['metadata'] as Map<String, dynamic>? ?? {};

            users.add(User(
              id: json['id'] ?? 0,
              email: '', // Not provided in search results
              name: json['title'] ?? 'Utilisateur', // title is the display name
              username: metadata['username'] ?? json['title'],
              bio: json['description'] ?? '',
              profilePictureUrl: json['imageUrl'], // imageUrl instead of profilePictureUrl
              isMentor: metadata['isMentor'] ?? false,
            ));
          }
        }

        print('✅ Parsed ${users.length} users');
        for (var user in users) {
          print('👤 User: ${user.name}, photo: ${user.profilePictureUrl}');
        }

        setState(() {
          _searchResults = users;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('❌ Search error: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _toggleUserSelection(User user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });

    if (_selectedUsers.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstagramChatScreen(
            recipientUser: _selectedUsers.first,
            isGroup: false,
          ),
        ),
      );
    }
  }

  void _createGroupChat() {
    print('🔥🔥🔥 _createGroupChat called - Opening InstagramGroupSelectionScreen');
    // Ouvrir l'écran de sélection de groupe style Instagram
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstagramGroupSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final networkProvider = context.watch<NetworkProvider>();

    if (networkProvider.isLoading && networkProvider.suggestions.isEmpty) {
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
            'Nouveau message',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1313EC)),
        ),
      );
    }

    final allUsers = _searchQuery.isEmpty || _searchResults.isEmpty
        ? networkProvider.suggestions
        .map((suggestion) => suggestion.user)
        .where((user) => user.id != currentUser?.id)
        .toList()
        : _searchResults.where((user) => user.id != currentUser?.id).toList();

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
          'Nouveau message',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'À:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      suffixIcon: _isSearching
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1313EC),
                          ),
                        ),
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _searchUsers(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          _buildQuickOption(
            icon: Icons.group,
            title: 'Discussion de groupe',
            onTap: _createGroupChat,
          ),
          _buildQuickOption(
            icon: Icons.alternate_email,
            title: 'Créer un canal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InstagramCreateChannelScreen(),
                ),
              );
            },
          ),
          _buildQuickOption(
            icon: Icons.auto_awesome,
            title: 'Discussions IA',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _searchQuery.isEmpty ? 'Suggestions' : 'Résultats de recherche',
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
                  Text(
                    _searchQuery.isEmpty ? 'Aucun utilisateur trouvé' : 'Aucun résultat',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
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
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: user.profilePictureUrl != null
                                  ? NetworkImage(user.profilePictureUrl!)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: user.profilePictureUrl == null
                                  ? Text(
                                user.name[0].toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                                  : null,
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1313EC),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (networkProvider.isUserConnected(user.id))
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1313EC).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Connecté',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1313EC),
                                    ),
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

  Widget _buildQuickOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
