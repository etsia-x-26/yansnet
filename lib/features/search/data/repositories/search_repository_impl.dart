import '../../domain/repositories/search_repository.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> searchUsers(String query) {
    return remoteDataSource.searchUsers(query);
  }

  @override
  Future<List<Post>> searchPosts(String query) {
    return remoteDataSource.searchPosts(query);
  }
}
