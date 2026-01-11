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

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
    );
  }
}
