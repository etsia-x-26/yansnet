import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/rsvp_event_usecase.dart';
import '../../domain/usecases/cancel_rsvp_usecase.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../../../features/search/domain/repositories/search_repository.dart';

class EventsProvider extends ChangeNotifier {
  final GetEventsUseCase getEventsUseCase;
  final RsvpEventUseCase rsvpEventUseCase;
  final CancelRsvpUseCase cancelRsvpUseCase;
  final CreateEventUseCase createEventUseCase;

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  final SearchRepository searchRepository;

  EventsProvider({
    required this.getEventsUseCase,
    required this.rsvpEventUseCase,
    required this.cancelRsvpUseCase,
    required this.createEventUseCase,
    required this.searchRepository,
  });

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) {
      _isLoading = true;
      _error = null; // Clear previous errors
      notifyListeners();
    }

    try {
      final newEvents = await getEventsUseCase();
      _events = newEvents;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchEvents(String query) async {
    if (query.isEmpty) {
      return loadEvents(refresh: true);
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await searchRepository.searchEvents(query);
      _events = results;
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleRsvp(Event event) async {
    // Optimistic update
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index == -1) return;

    final oldEvent = _events[index];
    final bool newStatus = !oldEvent.isAttending;
    final int newCount = newStatus ? oldEvent.attendeesCount + 1 : oldEvent.attendeesCount - 1;

    _events[index] = Event(
      id: oldEvent.id,
      title: oldEvent.title,
      description: oldEvent.description,
      location: oldEvent.location,
      eventDate: oldEvent.eventDate,
      organizer: oldEvent.organizer,
      attendeesCount: newCount,
      bannerUrl: oldEvent.bannerUrl,
      isAttending: newStatus,
    );
    notifyListeners();

    try {
      if (newStatus) {
        await rsvpEventUseCase(event.id);
      } else {
        await cancelRsvpUseCase(event.id);
      }
    } catch (e) {
      // Revert if failed
      _events[index] = oldEvent;
      _error = "Failed to update RSVP";
      notifyListeners();
    }
  }

  Future<bool> createEvent(String title, DateTime eventDate, String location, String description, String category, int maxParticipants, String? imageUrl, int organizerId, String organizerName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newEvent = await createEventUseCase(title, eventDate, location, description, category, maxParticipants, imageUrl, organizerId, organizerName);
      _events.insert(0, newEvent);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
