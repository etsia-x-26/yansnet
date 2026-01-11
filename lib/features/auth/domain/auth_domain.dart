class User {
  final int id;
  final String email;
  final String name;
  final String? username;
  final String? bio;
  final String? profilePictureUrl;
  final bool isMentor;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.bio,
    this.profilePictureUrl,
    this.isMentor = false,
  });
}

class AuthResponse {
  final int userId;
  final String email;
  final String accessToken;
  final String tokenType;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.tokenType,
  });
}

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String name, String username, String email, String password);
  Future<void> logout();
  Future<User> getUser(int id);
  Future<User> updateUser(int id, {String? name, String? bio, String? profilePictureUrl});
}
