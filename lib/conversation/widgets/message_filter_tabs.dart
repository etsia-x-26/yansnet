// lib/conversation/widgets/message_filter_tabs.dart
import 'package:flutter/material.dart';
import '../models/message_filter.dart';
import '../views/groups_list_page.dart';

class MessageFilterTabs extends StatelessWidget {
  final MessageFilter selectedFilter;
  final Function(MessageFilter) onFilterChanged;
  final int groupsCount;

  const MessageFilterTabs({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.groupsCount,
  }) : super(key: key);

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
            filter: MessageFilter.channel,
            label: 'Chaînes',
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            context: context,
            filter: MessageFilter.favorites,
            label: 'Favoris',
          ),
          const SizedBox(width: 12),
          // Bouton Groupes avec navigation
          _buildGroupsFilterChip(context),
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

  Widget _buildGroupsFilterChip(BuildContext context) {
    final isSelected = selectedFilter == MessageFilter.groups;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigation vers la page des groupes
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GroupsListPage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4F4DD)
                : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Groupes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF075E54)
                      : Colors.grey.shade700,
                ),
              ),
              if (groupsCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF25D366) // Vert WhatsApp
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    groupsCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}