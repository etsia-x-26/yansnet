import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yansnet/publication/widgets/home/comments_modal.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    required this.username,
    required this.displayName,
    required this.content,
    required this.time,
    required this.likes,
    required this.comments,
    super.key,
    this.imageUrl,
  });

  final String username;
  final String displayName;
  final String content;
  final String? imageUrl;
  final String time;
  final int likes;
  final int comments;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isLiked = false;
  late int _likesCount;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.likes;
    _imageError = false;
  }

  @override
  void didUpdateWidget(PostItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Réinitialiser l'état d'erreur si l'URL de l'image change
    if (oldWidget.imageUrl != widget.imageUrl) {
      _imageError = false;
    }
  }

  void _showCommentsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const CommentsModal();
      },
    );
  }

  Widget _buildImageWidget() {
    // Si pas d'image, afficher un placeholder gris
    if (widget.imageUrl == null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune image',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Si erreur de chargement, afficher placeholder d'erreur
    if (_imageError) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Image non disponible',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Afficher l'image avec gestion du chargement et des erreurs
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _imageError = true;
              });
            }
          });
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Image non disponible',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x1F000000), width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                context.push(
                  '/profile/${widget.username}',
                  extra: {
                    'displayName': widget.displayName,
                  },
                );
              },
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/40'),
              ),
              title: Text(widget.displayName),
              subtitle: Text('@${widget.username}'),
              trailing: const Icon(Icons.more_vert),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(widget.content),
            ),
            // Toujours afficher une zone d'image (image réelle ou placeholder)
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: _buildImageWidget(),
            ),
            if (widget.time.isNotEmpty)
              Text(
                widget.time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.messenger_outline_rounded),
                        onPressed: () => _showCommentsModal(context),
                        color: Colors.grey,
                      ),
                      Text('${widget.comments}'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: _isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            if (_isLiked) {
                              _likesCount = (widget.likes) + 1;
                            } else {
                              _likesCount = widget.likes;
                            }
                          });
                        },
                      ),
                      Text('$_likesCount'),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: () {
                      Share.share('Check out this post: ${widget.content}');
                    },
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
