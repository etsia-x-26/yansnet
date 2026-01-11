import '../repositories/event_repository.dart';

class RsvpEventUseCase {
  final EventRepository repository;

  RsvpEventUseCase(this.repository);

  Future<void> call(int eventId) {
    return repository.rsvpEvent(eventId);
  }
}
