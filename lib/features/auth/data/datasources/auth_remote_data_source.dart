import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/auth_domain.dart';
import '../../../../models/user_model.dart' as u_model; 

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String name, String username, String email, String password);
  Future<void> logout();
  Future<User> getUser(int id);
  Future<User> updateUser(int id, {String? name, String? bio, String? profilePictureUrl});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return _mapToAuthResponse(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(String name, String username, String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/register', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      });
      return _mapToAuthResponse(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final userId = await apiClient.storage.read(key: 'user_id');
    if (userId != null) {
      await apiClient.dio.post('/auth/logout', data: {'userId': int.tryParse(userId)});
    }
  }

  @override
  Future<User> getUser(int id) async {
    final response = await apiClient.dio.get('/api/user/$id');
    final userModel = u_model.User.fromJson(response.data);
    return _mapUser(userModel);
  }

  @override
  Future<User> updateUser(int id, {String? name, String? bio, String? profilePictureUrl}) async {
     // Assuming id usage or just current user context
     final data = <String, dynamic>{
       'userId': id, // Some APIs need explicit Id in body
     };
     if (name != null) data['name'] = name;
     if (bio != null) data['bio'] = bio;
     if (profilePictureUrl != null) data['profilePictureUrl'] = profilePictureUrl;

     final response = await apiClient.dio.put('/api/user', data: data);
     final userModel = u_model.User.fromJson(response.data);
     return _mapUser(userModel);
  }

  User _mapUser(u_model.User userModel) {
    return User(
      id: userModel.id,
      email: userModel.email,
      name: userModel.name,
      username: userModel.username,
      bio: userModel.bio,
      profilePictureUrl: userModel.profilePictureUrl,
      isMentor: userModel.isMentor,
    );
  }

  AuthResponse _mapToAuthResponse(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
    );
  }
}
