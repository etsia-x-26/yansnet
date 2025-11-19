import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/conversation/models/group_member.dart';
import 'package:yansnet/conversation/widgets/group_actions_section.dart';
import 'package:yansnet/conversation/widgets/group_description_section.dart';
import 'package:yansnet/conversation/widgets/group_dialogs.dart';
import 'package:yansnet/conversation/widgets/group_important_messages_section.dart';
import 'package:yansnet/conversation/widgets/group_members_section.dart';
import 'package:yansnet/conversation/widgets/group_profile_section.dart';
import 'package:yansnet/conversation/widgets/group_statistics_section.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({
    required this.groupName,
    required this.groupAvatar,
    required this.memberCount,
    required this.isUserAdmin,
    super.key,
  });

  final String groupName;
  final String groupAvatar;
  final int memberCount;
  final bool isUserAdmin;

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late bool _isUserAdmin;
  final String _currentUserId = '1';
  final String _groupDescription =
      'Groupe de travail pour le projet ETSIA. Échangeons nos idées et collaborons ensemble !';

  final List<GroupMember> _members = [
    const GroupMember(
      id: '1',
      name: 'Axelle Bakery',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      role: GroupMemberRole.admin,
      isOnline: true,
    ),
    const GroupMember(
      id: '2',
      name: 'Emmy',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      role: GroupMemberRole.member,
      isOnline: false,
    ),
    const GroupMember(
      id: '3',
      name: 'Victoire',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      role: GroupMemberRole.member,
      isOnline: true,
    ),
    const GroupMember(
      id: '4',
      name: 'Passi',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      role: GroupMemberRole.member,
      isOnline: false,
    ),
    const GroupMember(
      id: '5',
      name: 'Pixsie',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      role: GroupMemberRole.admin,
      isOnline: true,
    ),
    const GroupMember(
      id: '6',
      name: 'Sophie',
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
      role: GroupMemberRole.member,
      isOnline: false,
    ),
    const GroupMember(
      id: '7',
      name: 'Lucas',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      role: GroupMemberRole.member,
      isOnline: true,
    ),
    const GroupMember(
      id: '8',
      name: 'Marie',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      role: GroupMemberRole.member,
      isOnline: false,
    ),
  ];

  final int _mediaCount = 24;
  final int _linksCount = 12;
  final int _documentsCount = 8;
  final int _importantMessagesCount = 5;

  @override
  void initState() {
    super.initState();
    _isUserAdmin = widget.isUserAdmin;
  }

  bool get _isMainAdmin {
    if (!_isUserAdmin) return false;
    return _currentUserId == '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Informations du groupe',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        /*
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Switch(
                value: _isUserAdmin,
                onChanged: (value) {
                  setState(() {
                    _isUserAdmin = value;
                  });
                },
                activeColor: const Color(0xFF5D1A1A),
              ),
            ],
          ),
          if (_isUserAdmin)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                GroupDialogs.showEditGroupInfoDialog(
                  context,
                  widget.groupName,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informations du groupe mises à jour'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
        ],
         */
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupProfileSection(
              groupName: widget.groupName,
              groupAvatar: widget.groupAvatar,
              memberCount: widget.memberCount,
              isUserAdmin: _isUserAdmin,
              onAvatarTap: () {
                GroupDialogs.showChangeAvatarDialog(context);
              },
            ),
            const SizedBox(height: 8),
            GroupDescriptionSection(
              description: _groupDescription,
              isUserAdmin: _isUserAdmin,
              onEditTap: () {
                GroupDialogs.showEditDescriptionDialog(
                  context,
                  _groupDescription,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Description mise à jour'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            GroupStatisticsSection(
              groupName: widget.groupName,
              mediaCount: _mediaCount,
              linksCount: _linksCount,
              documentsCount: _documentsCount,
            ),
            const SizedBox(height: 8),
            GroupImportantMessagesSection(
              groupName: widget.groupName,
              count: _importantMessagesCount,
            ),
            const SizedBox(height: 8),
            GroupMembersSection(
              members: _members,
              isUserAdmin: _isUserAdmin,
              isMainAdmin: _isMainAdmin,
              currentUserId: _currentUserId,
              onAddMember: () {
                GroupDialogs.showAddMembersDialog(context);
              },
              onPromoteToAdmin: (member) {
                GroupDialogs.showPromoteToAdminDialog(
                  context,
                  member,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${member.name} a été promu administrateur'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
              onRevokeAdminRights: (member) {
                GroupDialogs.showRevokeAdminRightsDialog(
                  context,
                  member,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Les droits d\'admin de ${member.name} ont été révoqués'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
              onRemoveMember: (member) {
                GroupDialogs.showRemoveMemberDialog(
                  context,
                  member,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${member.name} a été retiré du groupe'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            GroupActionsSection(
              onLeaveGroup: () {
                GroupDialogs.showLeaveGroupDialog(
                  context,
                  widget.groupName,
                  () {
                    // Action pour quitter le groupe
                  },
                );
              },
              onClearConversation: () {
                GroupDialogs.showClearConversationDialog(
                  context,
                  widget.groupName,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Discussion effacée pour vous'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
