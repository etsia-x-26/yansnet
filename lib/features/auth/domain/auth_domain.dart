enum UserType { individual, company, mentor }

class User {
  final int id;
  final String email;
  final String name;
  final String? username;
  final String? bio;
  final String? profilePictureUrl;
  final bool isMentor;
  final UserType userType;
  final int totalFollowers;
  final int totalFollowing;
  final int totalPosts;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.bio,
    this.profilePictureUrl,
    this.isMentor = false,
    this.userType = UserType.individual,
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.totalPosts = 0,
  });
}

class AuthResponse {
  final int userId;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String name, String username, String email, String password);
  Future<void> logout(int userId);
  Future<User> getUser(int id);
  Future<User> updateUser(int id, {String? name, String? bio, String? profilePictureUrl});
}
