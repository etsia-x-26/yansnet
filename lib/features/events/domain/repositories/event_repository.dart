import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents({int page = 0, int size = 10});
  Future<void> rsvpEvent(int eventId);
  Future<void> cancelRsvp(int eventId);
  Future<Event> createEvent(String title, DateTime eventDate, String location, String description);
}
