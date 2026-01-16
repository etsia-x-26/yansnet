class Channel {
  final int id;
  final String title;
  final String description;
  final int totalFollowers;
  final bool isFollowing;

  Channel({
    required this.id,
    required this.title,
    required this.description,
    this.totalFollowers = 0,
    this.isFollowing = false,
  });
}
