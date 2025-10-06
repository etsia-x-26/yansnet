class AuthResponse {

  AuthResponse({
    required this.id,
    required this.email,
    required this.accessToken
  });
  int id;
  String email;
  String accessToken;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    id:json['userid'] as int,
    email: json['email'] as String,
    accessToken: json['accessToken'] as String
  );

  Map<String, dynamic> toJson() => {
    'userId': id,
    'email': email,
  };
}

class User {
  User({
    required this.id,
    required this.email,
  });
  int id;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id:json['userId'] as int,
      email: json['email'] as String,
  );

}