import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupStatisticsSection extends StatelessWidget {
  const GroupStatisticsSection({
    required this.groupName,
    required this.mediaCount,
    required this.linksCount,
    required this.documentsCount,
    super.key,
  });

  final String groupName;
  final int mediaCount;
  final int linksCount;
  final int documentsCount;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Médias, liens et documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _StatisticItem(
            icon: Icons.photo_library,
            label: 'Médias',
            count: mediaCount,
            onTap: () {
              final encodedName = Uri.encodeComponent(groupName);
              context.push('/group/$encodedName/info/media');
            },
          ),
          const Divider(height: 24),
          _StatisticItem(
            icon: Icons.link,
            label: 'Liens',
            count: linksCount,
            onTap: () {
              final encodedName = Uri.encodeComponent(groupName);
              context.push('/group/$encodedName/info/links');
            },
          ),
          const Divider(height: 24),
          _StatisticItem(
            icon: Icons.insert_drive_file,
            label: 'Documents',
            count: documentsCount,
            onTap: () {
              final encodedName = Uri.encodeComponent(groupName);
              context.push('/group/$encodedName/info/documents');
            },
          ),
        ],
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5D1A1A), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
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

