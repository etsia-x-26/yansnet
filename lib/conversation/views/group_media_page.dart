import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupMediaPage extends StatelessWidget {
  GroupMediaPage({
    required this.groupName,
    super.key,
  });

  final String groupName;

  // Données mockées pour les médias
  final List<MediaItem> _mediaItems = [
    const MediaItem(
      id: '1',
      url: 'https://picsum.photos/300/300?random=1',
      type: MediaType.image,
      senderName: 'Axelle Bakery',
      date: '15/01/2025',
      isDownloaded: true,
    ),
    const MediaItem(
      id: '2',
      url: 'https://picsum.photos/300/300?random=2',
      type: MediaType.image,
      senderName: 'Emmy',
      date: '14/01/2025',
      isDownloaded: false,
    ),
    const MediaItem(
      id: '3',
      url: 'https://picsum.photos/300/300?random=3',
      type: MediaType.video,
      senderName: 'Victoire',
      date: '13/01/2025',
      isDownloaded: true,
    ),
    const MediaItem(
      id: '4',
      url: 'https://picsum.photos/300/300?random=4',
      type: MediaType.image,
      senderName: 'Passi',
      date: '12/01/2025',
      isDownloaded: true,
    ),
    const MediaItem(
      id: '5',
      url: 'https://picsum.photos/300/300?random=5',
      type: MediaType.image,
      senderName: 'Pixsie',
      date: '11/01/2025',
      isDownloaded: false,
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
          'Médias - $groupName',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _mediaItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun média',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les médias partagés dans ce groupe\napparaîtront ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _mediaItems.length,
              itemBuilder: (context, index) {
                final media = _mediaItems[index];
                return _buildMediaItem(media);
              },
            ),
    );
  }

  Widget _buildMediaItem(MediaItem media) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          media.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
          },
        ),
        if (media.type == MediaType.video)
          const Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 40,
            ),
          ),
        if (media.isDownloaded)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              /*
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              ),
               */
            ),
          ),
      ],
    );
  }
}

enum MediaType {
  image,
  video,
}

class MediaItem {
  const MediaItem({
    required this.id,
    required this.url,
    required this.type,
    required this.senderName,
    required this.date,
    this.isDownloaded = false,
  });

  final String id;
  final String url;
  final MediaType type;
  final String senderName;
  final String date;
  final bool isDownloaded;
}

