import '../../domain/auth_domain.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/network/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ApiClient apiClient; // To access storage, or inject a LocalDataSource ideally

  AuthRepositoryImpl(this.remoteDataSource, this.apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await remoteDataSource.login(email, password);
    await apiClient.storage.write(key: 'auth_token', value: response.accessToken);
    await apiClient.storage.write(key: 'refresh_token', value: response.refreshToken);
    await apiClient.storage.write(key: 'user_id', value: response.userId.toString());

    return response;
  }

  @override
  Future<AuthResponse> register(String name, String username, String email, String password) async {
    return remoteDataSource.register(name, username, email, password);
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Ignore logout errors from server if any
    }
    await apiClient.storage.delete(key: 'auth_token');
    await apiClient.storage.delete(key: 'refresh_token');
    await apiClient.storage.delete(key: 'user_id');
  }

  @override
  Future<User> getUser(int id) {
    return remoteDataSource.getUser(id);
  }

  @override
  Future<User> updateUser(int id, {String? name, String? bio, String? profilePictureUrl}) {
    return remoteDataSource.updateUser(id, name: name, bio: bio, profilePictureUrl: profilePictureUrl);
  }
}
