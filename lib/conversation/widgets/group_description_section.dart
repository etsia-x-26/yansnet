import 'package:flutter/material.dart';

class GroupDescriptionSection extends StatelessWidget {
  const GroupDescriptionSection({
    required this.description,
    required this.isUserAdmin,
    this.onEditTap,
    super.key,
  });

  final String description;
  final bool isUserAdmin;
  final VoidCallback? onEditTap;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (isUserAdmin)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEditTap,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description.isEmpty ? 'Aucune description' : description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

