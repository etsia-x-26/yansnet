class Channel {
  final int id;
  final String title;
  final String description;
  final int totalFollowers;

  Channel({
    required this.id,
    required this.title,
    required this.description,
    this.totalFollowers = 0,
  });
}
