import '../../../../core/network/api_client.dart';
import '../../domain/entities/event_entity.dart';
import '../models/event_dto.dart';

abstract class EventRemoteDataSource {
  Future<List<Event>> getEvents({int page = 0, int size = 10});
  Future<void> rsvpEvent(int eventId);
  Future<void> cancelRsvp(int eventId);
  Future<Event> createEvent(Map<String, dynamic> eventData);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final ApiClient apiClient;

  EventRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Event>> getEvents({int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.dio.get('/api/events', queryParameters: {
        'page': page,
        'size': size,
      });

      final data = response.data;
      if (data != null && data['content'] != null) {
        return (data['content'] as List).map((e) => EventDto.fromJson(e).toEntity()).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  @override
  Future<void> rsvpEvent(int eventId) async {
    await apiClient.dio.post('/api/events/$eventId/rsvp');
  }

  @override
  Future<void> cancelRsvp(int eventId) async {
    await apiClient.dio.delete('/api/events/$eventId/rsvp');
  }

  @override
  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    // TODO: Connect to real API
    // final response = await apiClient.dio.post('/api/events', data: eventData);
    // return EventDto.fromJson(response.data).toEntity();

    // Simulating success
    await Future.delayed(const Duration(seconds: 1));
    return Event(
      id: DateTime.now().millisecondsSinceEpoch,
      title: eventData['title'],
      description: eventData['description'],
      location: eventData['location'],
      eventDate: DateTime.parse(eventData['eventDate']),
      organizer: 'You',
      attendeesCount: 0,
      bannerUrl: null,
      isAttending: true,
    );
  }
}
