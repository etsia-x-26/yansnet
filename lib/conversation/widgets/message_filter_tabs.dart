import 'package:flutter/material.dart';
import '../models/message_filter.dart';

class MessageFilterTabs extends StatelessWidget {
  final MessageFilter selectedFilter;
  final Function(MessageFilter) onFilterChanged;
  final int unreadCount;
  final int groupsCount;

  const MessageFilterTabs({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.unreadCount = 0,
    this.groupsCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context,
            filter: MessageFilter.all,
            label: 'Toutes',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            filter: MessageFilter.unread,
            label: 'Non lues',
            count: unreadCount > 0 ? unreadCount : null,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            filter: MessageFilter.channel,
            label: 'Chaines',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            filter: MessageFilter.favorites,
            label: 'Favoris',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            filter: MessageFilter.groups,
            label: 'Groupes',
            count: groupsCount > 0 ? groupsCount : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, {
        required MessageFilter filter,
        required String label,
        int? count,
      }) {
    final isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4F4DD) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF25D366) : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF25D366).withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF075E54) : Colors.grey[700],
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF075E54)
                      : Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}