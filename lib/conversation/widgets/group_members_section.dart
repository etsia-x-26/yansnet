import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/group_member.dart';
import 'package:yansnet/conversation/widgets/group_member_item.dart';

class GroupMembersSection extends StatefulWidget {
  const GroupMembersSection({
    required this.members,
    required this.isUserAdmin,
    required this.isMainAdmin,
    required this.currentUserId,
    this.onAddMember,
    this.onPromoteToAdmin,
    this.onRevokeAdminRights,
    this.onRemoveMember,
    super.key,
  });

  final List<GroupMember> members;
  final bool isUserAdmin;
  final bool isMainAdmin;
  final String currentUserId;
  final VoidCallback? onAddMember;
  final void Function(GroupMember)? onPromoteToAdmin;
  final void Function(GroupMember)? onRevokeAdminRights;
  final void Function(GroupMember)? onRemoveMember;

  @override
  State<GroupMembersSection> createState() => _GroupMembersSectionState();
}

class _GroupMembersSectionState extends State<GroupMembersSection> {
  bool _showAllMembers = false;

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
              Text(
                'Membres (${widget.members.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (widget.isUserAdmin)
                IconButton(
                  icon: const Icon(Icons.person_add, color: Color(0xFF5D1A1A)),
                  onPressed: widget.onAddMember,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Afficher les membres (5 premiers par défaut, ou tous si _showAllMembers est true)
          ...(_showAllMembers ? widget.members : widget.members.take(5))
              .map((member) => GroupMemberItem(
                    member: member,
                    isUserAdmin: widget.isUserAdmin,
                    isMainAdmin: widget.isMainAdmin,
                    currentUserId: widget.currentUserId,
                    onPromoteToAdmin: widget.onPromoteToAdmin != null
                        ? () => widget.onPromoteToAdmin!(member)
                        : null,
                    onRevokeAdminRights: widget.onRevokeAdminRights != null
                        ? () => widget.onRevokeAdminRights!(member)
                        : null,
                    onRemoveMember: widget.onRemoveMember != null
                        ? () => widget.onRemoveMember!(member)
                        : null,
                  )),
          // Bouton "Voir tout" si il y a plus de 5 membres
          if (widget.members.length > 5 && !_showAllMembers)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllMembers = true;
                  });
                },
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFF5D1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          // Bouton "Voir moins" si tous les membres sont affichés
          if (_showAllMembers && widget.members.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllMembers = false;
                  });
                },
                child: const Text(
                  'Voir moins',
                  style: TextStyle(
                    color: Color(0xFF5D1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

