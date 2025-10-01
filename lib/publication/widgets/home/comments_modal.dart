import 'package:flutter/material.dart';
import 'package:yansnet/publication/widgets/home/comment_input.dart';
import 'package:yansnet/publication/widgets/home/comment_item.dart';

class CommentsModal extends StatefulWidget {
  const CommentsModal({super.key});

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 7,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CommentItem(
                      username: 'marine_webre',
                      comment: 'Vraiment une belle surprise ce film',
                      time: '5h',
                      hasReplies: true,
                    ),
                    CommentItem(
                      username: 'marine_webre',
                      comment: 'Ah ça!!',
                      time: '15min',
                      hasReplies: true,
                    ),
                    CommentItem(
                      username: 'marine_webre',
                      comment: 'Ah ça!!',
                      time: '15min',
                    ),
                    CommentItem(
                      username: 'marine_webre',
                      comment: 'Ah ça!!',
                      time: '15min',
                    ),
                    CommentItem(
                      username: 'aerda_elrea',
                      comment: 'Début 🎉 Fin 🎉',
                      time: '3h',
                    ),
                    CommentItem(
                      username: 'cvm_p_vh',
                      comment: 'J’ai vu hierrr',
                      time: '3h',
                      hasReplies: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CommentInput(),
        ],
      ),
    );
  }
}
