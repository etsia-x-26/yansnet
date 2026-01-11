import '../repositories/event_repository.dart';

class CancelRsvpUseCase {
  final EventRepository repository;

  CancelRsvpUseCase(this.repository);

  Future<void> call(int eventId) {
    return repository.cancelRsvp(eventId);
  }
}
