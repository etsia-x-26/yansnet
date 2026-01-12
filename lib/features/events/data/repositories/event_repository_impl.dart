import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Event>> getEvents({int page = 0, int size = 10}) {
    return remoteDataSource.getEvents(page: page, size: size);
  }

  @override
  Future<void> rsvpEvent(int eventId) {
    return remoteDataSource.rsvpEvent(eventId);
  }

  @override
  Future<void> cancelRsvp(int eventId) {
    return remoteDataSource.cancelRsvp(eventId);
  }

  @override
  Future<Event> createEvent(String title, DateTime eventDate, String location, String description) {
     return remoteDataSource.createEvent({
       'title': title,
       'eventDate': eventDate.toIso8601String(),
       'location': location,
       'description': description,
     });
  }
}
