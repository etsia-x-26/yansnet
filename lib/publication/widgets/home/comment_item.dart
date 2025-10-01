import 'package:flutter/material.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    required this.username,
    required this.comment,
    required this.time,
    this.likes = 0,
    this.hasReplies = false,
    super.key,
  });

  final String username;
  final String comment;
  final String time;
  final int likes;
  final bool hasReplies;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: const CircleAvatar(),
          isThreeLine: true,
          title: Text(widget.username),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.comment),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Reply',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 1,
            children: [
              if (_likesCount <= 0)
                SizedBox(
                  width: 60, // Fixed width to match liked state
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      maxWidth: 0,
                      maxHeight: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _likesCount++;
                      });
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 18,
                    ),
                  ),
                ),
              if (_likesCount > 0)
                SizedBox(
                  width: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          maxWidth: 1,
                          maxHeight: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _likesCount--;
                          });
                        },
                        icon: const Icon(
                          Icons.favorite,
                          size: 18,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        _likesCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (widget.hasReplies)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showReplies = !_showReplies;
                  });
                },
                child: Text(
                  _showReplies ? 'View less' : 'View more',
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
            ],
          ),

        // Horizontal divider with low opacity
        Container(
          height: 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color.fromARGB(255, 211, 211, 211),
        ),
      ],
    );
  }
}
