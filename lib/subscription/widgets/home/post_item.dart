import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'comments_modal.dart';

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

  @override
  void initState() {
    super.initState();
    _likesCount = widget.likes;
  }

  void _showCommentsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const CommentsModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/40'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text('@${widget.username}'),
                      ],
                    )
                  ],
                ),
                const Icon(Icons.more_vert)
              ],
            ),
          ),
          // ListTile(
          //   leading: const CircleAvatar(
          //     backgroundImage: NetworkImage('https://via.placeholder.com/40'),
          //   ),
          //   title: Text(widget.displayName),
          //   subtitle: Text('@${widget.username}'),
          //   trailing: const Icon(Icons.more_vert),
          // ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(widget.content),
          ),
          if (widget.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 0, bottom: 8),
              child: Image.network(widget.imageUrl!),
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
    );
  }
}
