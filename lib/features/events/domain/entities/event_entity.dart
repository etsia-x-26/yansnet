class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime eventDate;
  final String? bannerUrl;
  final String organizer;
  final int attendeesCount;
  final bool isAttending;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.organizer,
    this.attendeesCount = 0,
    this.bannerUrl,
    this.isAttending = false,
  });
}
