// lib/conversation/widgets/message_filter_tabs.dart
import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/message_filter.dart';

class MessageFilterTabs extends StatelessWidget {
  const MessageFilterTabs({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.groupsCount,
    super.key,
  });

  final MessageFilter selectedFilter;
  final void Function(MessageFilter) onFilterChanged;
  final int groupsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context: context,
            filter: MessageFilter.all,
            label: 'Toutes',
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context: context,
            filter: MessageFilter.unread,
            label: 'Non lues',
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context: context,
            filter: MessageFilter.favorites,
            label: 'Favoris',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required MessageFilter filter,
    required String label,
  }) {
    final isSelected = selectedFilter == filter;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFilterChanged(filter),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4F4DD) // Vert clair WhatsApp
                : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF075E54) // Vert foncé WhatsApp
                  : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
