// lib/conversation/views/channels_view.dart
import 'package:flutter/material.dart';
import 'channel_detail_page.dart';

enum ChannelFilter {
  all,        // Toutes
  subscribed, // Abonnées
  fields,     // Filières
  official    // Officielles
}

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({Key? key}) : super(key: key);

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  ChannelFilter _selectedFilter = ChannelFilter.all;

  // Données mockées des chaînes
  final List<Map<String, dynamic>> _allChannels = [
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=30',
      'channelName': 'ETSIA Officiel 🎓',
      'description': 'Chaîne officielle de l\'ETSIA - Actualités et informations importantes',
      'lastPost': 'Nouvelles inscriptions ouvertes !',
      'lastPostTime': '2h',
      'subscriberCount': 1500,
      'isSubscribed': true,
      'isOfficial': true,
      'field': null,
    },
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=31',
      'channelName': 'Génie Logiciel 💻',
      'description': 'Tout sur le développement logiciel et la programmation',
      'lastPost': 'Cours de UML disponible',
      'lastPostTime': '5h',
      'subscriberCount': 250,
      'isSubscribed': true,
      'isOfficial': false,
      'field': 'Informatique',
    },
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=32',
      'channelName': 'Génie Civil 🏗️',
      'description': 'Construction, architecture et projets de génie civil',
      'lastPost': 'Projet de construction',
      'lastPostTime': 'Hier',
      'subscriberCount': 180,
      'isSubscribed': false,
      'isOfficial': false,
      'field': 'Génie Civil',
    },
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=33',
      'channelName': 'Actualités Campus 📰',
      'description': 'Les dernières nouvelles du campus ETSIA',
      'lastPost': 'Événement ce weekend',
      'lastPostTime': '1j',
      'subscriberCount': 890,
      'isSubscribed': true,
      'isOfficial': true,
      'field': null,
    },
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=34',
      'channelName': 'Réseaux & Télécoms 📡',
      'description': 'Technologies de réseau et télécommunications',
      'lastPost': 'TP Cisco ce jeudi',
      'lastPostTime': '3h',
      'subscriberCount': 120,
      'isSubscribed': true,
      'isOfficial': false,
      'field': 'Informatique',
    },
    {
      'channelAvatar': 'https://i.pravatar.cc/150?img=35',
      'channelName': 'Électronique ⚡',
      'description': 'Électronique, circuits et systèmes embarqués',
      'lastPost': 'Tutoriel Arduino',
      'lastPostTime': '6h',
      'subscriberCount': 95,
      'isSubscribed': false,
      'isOfficial': false,
      'field': 'Électronique',
    },
  ];

  // Filtrage des chaînes
  List<Map<String, dynamic>> get _filteredChannels {
    switch (_selectedFilter) {
      case ChannelFilter.all:
        return _allChannels;
      case ChannelFilter.subscribed:
        return _allChannels.where((ch) => ch['isSubscribed'] == true).toList();
      case ChannelFilter.fields:
        return _allChannels.where((ch) => ch['field'] != null).toList();
      case ChannelFilter.official:
        return _allChannels.where((ch) => ch['isOfficial'] == true).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sous-filtres des chaînes - HOMOGÈNE avec Chats/Groupes
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(label: 'Toutes', filter: ChannelFilter.all),
                const SizedBox(width: 12),
                _buildFilterChip(label: 'Abonnées', filter: ChannelFilter.subscribed),
                const SizedBox(width: 12),
                _buildFilterChip(label: 'Filières', filter: ChannelFilter.fields),
                const SizedBox(width: 12),
                _buildFilterChip(label: 'Officielles', filter: ChannelFilter.official),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        // Liste des chaînes
        Expanded(
          child: _filteredChannels.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucune chaîne',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filteredChannels.length,
            itemBuilder: (context, index) {
              final channel = _filteredChannels[index];
              return _buildChannelItem(channel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({required String label, required ChannelFilter filter}) {
    final isSelected = _selectedFilter == filter;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = filter),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD4F4DD) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? const Color(0xFF075E54) : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelItem(Map<String, dynamic> channel) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelDetailPage(
              channelName: channel['channelName'] as String,
              channelAvatar: channel['channelAvatar'] as String,
              description: channel['description'] as String,
              subscriberCount: channel['subscriberCount'] as int,
              isSubscribed: channel['isSubscribed'] as bool,
              isOfficial: channel['isOfficial'] as bool,
              onSubscriptionChanged: (isSubscribed) {
                setState(() => channel['isSubscribed'] = isSubscribed);
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            // Avatar avec badge officiel
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(channel['channelAvatar'] as String),
                ),
                if (channel['isOfficial'] == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.verified, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel['channelName'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        channel['lastPostTime'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel['lastPost'] as String,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${channel['subscriberCount']} abonnés',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      if (channel['field'] != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            channel['field'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => setState(() {
                channel['isSubscribed'] = !(channel['isSubscribed'] as bool);
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: (channel['isSubscribed'] as bool)
                    ? Colors.grey[300]
                    : const Color(0xFF5D1A1A),
                foregroundColor: (channel['isSubscribed'] as bool)
                    ? Colors.black87
                    : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                (channel['isSubscribed'] as bool) ? 'Abonné' : 'S\'abonner',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}