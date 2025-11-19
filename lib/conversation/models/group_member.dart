enum GroupMemberRole {
  admin,
  member,
}

class GroupMember {
  const GroupMember({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final GroupMemberRole role;
  final bool isOnline;

  bool get isAdmin => role == GroupMemberRole.admin;
}

