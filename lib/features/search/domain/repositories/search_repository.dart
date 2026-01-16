import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../data/models/search_dto.dart';

abstract class SearchRepository {
  Future<SearchResultDto> searchCombined(String query, {String? type});
  Future<List<User>> searchUsers(String query);
  Future<List<Post>> searchPosts(String query);
  Future<List<Job>> searchJobs(String query);
  Future<List<Event>> searchEvents(String query);
}
