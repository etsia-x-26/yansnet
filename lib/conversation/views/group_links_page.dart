import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupLinksPage extends StatelessWidget {
  GroupLinksPage({
    required this.groupName,
    super.key,
  });

  final String groupName;

  // Données mockées pour les liens
  final List<LinkItem> _linkItems = [
    const LinkItem(
      id: '1',
      url: 'https://flutter.dev',
      title: 'Flutter - Build apps for any screen',
      description: 'Flutter transforms the app development process',
      senderName: 'Axelle Bakery',
      date: '15/01/2025',
      isDownloaded: true,
    ),
    const LinkItem(
      id: '2',
      url: 'https://dart.dev',
      title: 'Dart programming language',
      description: 'Dart is a client-optimized language',
      senderName: 'Emmy',
      date: '14/01/2025',
      isDownloaded: false,
    ),
    const LinkItem(
      id: '3',
      url: 'https://pub.dev',
      title: 'Pub.dev - Dart packages',
      description: 'Find and use packages to build Dart apps',
      senderName: 'Victoire',
      date: '13/01/2025',
      isDownloaded: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Liens - $groupName',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _linkItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.link_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun lien',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les liens partagés dans ce groupe\napparaîtront ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _linkItems.length,
              itemBuilder: (context, index) {
                final link = _linkItems[index];
                return _buildLinkItem(context, link);
              },
            ),
    );
  }

  Widget _buildLinkItem(BuildContext context, LinkItem link) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Action pour ouvrir le lien
          // "url_launcher" en production pour ouvrir le lien
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ouverture de ${link.url}...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.link,
                    color: Color(0xFF5D1A1A),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      link.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  /*
                  if (link.isDownloaded)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                   */
                ],
              ),
              if (link.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  link.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                link.url,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    link.senderName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    link.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkItem {
  const LinkItem({
    required this.id,
    required this.url,
    required this.title,
    this.description = '',
    required this.senderName,
    required this.date,
    this.isDownloaded = false,
  });

  final String id;
  final String url;
  final String title;
  final String description;
  final String senderName;
  final String date;
  final bool isDownloaded;
}

