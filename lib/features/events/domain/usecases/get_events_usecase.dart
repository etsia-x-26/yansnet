import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class GetEventsUseCase {
  final EventRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<Event>> call({int page = 0, int size = 10}) {
    return repository.getEvents(page: page, size: size);
  }
}
