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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const CircleAvatar(),
          title: Text(widget.username),
          subtitle: Text(widget.comment),
          trailing: Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.likes <= 0)
                  IconButton(
                    icon: const Icon(Icons.favorite_border, size: 16),
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                  ),
                if (widget.likes > 0)
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 16, color: Colors.red),
                      const SizedBox(width: 2),
                      Text(widget.likes.toString()),
                    ],
                  ),
                Text(widget.time),
              ],
            ),
          ),
        ),
        if (widget.hasReplies && _showReplies)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reply'),
                Text('View more replies', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: !_showReplies && widget.hasReplies
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _showReplies = true;
                    });
                  },
                  child: const Text(
                    'View more replies',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              : widget.hasReplies
              ? null
              : const Text('Reply', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
