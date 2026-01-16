import '../../domain/repositories/search_repository.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../data/models/search_dto.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<SearchResultDto> searchCombined(String query, {String? type}) {
    return remoteDataSource.searchCombined(query, type: type);
  }

  @override
  Future<List<User>> searchUsers(String query) {
    return remoteDataSource.searchUsers(query);
  }

  @override
  Future<List<Post>> searchPosts(String query) {
    return remoteDataSource.searchPosts(query);
  }

  @override
  Future<List<Job>> searchJobs(String query) {
    return remoteDataSource.searchJobs(query);
  }

  @override
  Future<List<Event>> searchEvents(String query) {
    return remoteDataSource.searchEvents(query);
  }
}

