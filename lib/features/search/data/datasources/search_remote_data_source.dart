import '../../../../core/network/api_client.dart';
import '../../../auth/domain/auth_domain.dart' as auth;
import '../../../posts/domain/entities/post_entity.dart' as post_entity;
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../models/search_dto.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultDto> searchCombined(String query, {String? type});
  Future<List<auth.User>> searchUsers(String query);
  Future<List<post_entity.Post>> searchPosts(String query);
  Future<List<Job>> searchJobs(String query);
  Future<List<Event>> searchEvents(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SearchResultDto> searchCombined(String query, {String? type}) async {
    try {
      final queryParams = {'q': query};
      if (type != null) {
        queryParams['type'] = type;
      }
      final response = await apiClient.dio.get('/search', queryParameters: queryParams);
      return SearchResultDto.fromJson(response.data);
    } catch (e) {
      print('Combined Search Error: $e');
      return SearchResultDto(
        users: [],
        posts: [],
        events: [],
        jobs: [],
        totalResults: 0,
        query: query,
      );
    }
  }

  @override
  Future<List<auth.User>> searchUsers(String query) async {
    final result = await searchCombined(query, type: 'USER');
    return result.users.map((e) => e.toUserEntity()).toList();
  }

  @override
  Future<List<post_entity.Post>> searchPosts(String query) async {
    final result = await searchCombined(query, type: 'POST');
    return result.posts.map((e) => e.toPostEntity()).toList();
  }

  @override
  Future<List<Job>> searchJobs(String query) async {
    final result = await searchCombined(query, type: 'JOB');
    return result.jobs.map((e) => e.toJobEntity()).toList();
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    final result = await searchCombined(query, type: 'EVENT');
    return result.events.map((e) => e.toEventEntity()).toList();
  }
}

