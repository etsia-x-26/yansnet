import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  Future<Event> call(String title, DateTime eventDate, String location, String description) {
    return repository.createEvent(title, eventDate, location, description);
  }
}
