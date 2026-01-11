import '../../domain/entities/event_entity.dart';

class EventDto {
  final int id;
  final String title;
  final String description;
  final String location;
  final String eventDate;
  final String? bannerUrl;
  final String organizer; // Could be User object in real API
  final int attendeesCount;
  final bool isAttending;

  EventDto({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.organizer,
    required this.attendeesCount,
    this.bannerUrl,
    this.isAttending = false,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      eventDate: json['eventDate'] ?? DateTime.now().toIso8601String(),
      organizer: json['organizer'] is Map ? (json['organizer']['name'] ?? 'Organizer') : (json['organizer'] ?? 'Organizer'),
      attendeesCount: json['attendeesCount'] ?? 0,
      bannerUrl: json['bannerUrl'],
      isAttending: json['isAttending'] ?? false,
    );
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      location: location,
      eventDate: DateTime.tryParse(eventDate) ?? DateTime.now(),
      organizer: organizer,
      attendeesCount: attendeesCount,
      bannerUrl: bannerUrl,
      isAttending: isAttending,
    );
  }
}
