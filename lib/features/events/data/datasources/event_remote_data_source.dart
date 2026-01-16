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
    final userIdStr = await apiClient.storage.read(key: 'user_id');
    final userId = userIdStr != null ? int.parse(userIdStr) : 0;
    await apiClient.dio.post(
      '/api/events/$eventId/rsvp',
      queryParameters: {
        'userId': userId,
        'status': 'GOING',
      },
    );
  }

  @override
  Future<void> cancelRsvp(int eventId) async {
    await apiClient.dio.delete('/api/events/$eventId/rsvp');
  }

  @override
  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    try {
      // Constructing body based on user requirements
      final body = {
        "title": eventData['title'],
        "description": eventData['description'],
        "category": eventData['category'],
        "eventDate": eventData['eventDate'],
        "location": eventData['location'],
        "maxParticipants": eventData['maxParticipants'],
        "imageUrl": eventData['imageUrl'] ?? "",
        "organizerId": eventData['organizerId'],
        "organizerName": eventData['organizerName'],
      };

      final response = await apiClient.dio.post('/api/events', data: body);
      return EventDto.fromJson(response.data).toEntity();
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }
}
