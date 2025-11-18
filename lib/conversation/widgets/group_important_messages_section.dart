import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupImportantMessagesSection extends StatelessWidget {
  const GroupImportantMessagesSection({
    required this.groupName,
    required this.count,
    super.key,
  });

  final String groupName;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          final encodedName = Uri.encodeComponent(groupName);
          context.push('/group/$encodedName/info/important-messages');
        },
        child: Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 24,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Messages marqués importants',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

