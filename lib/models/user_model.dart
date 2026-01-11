class User {
  final int id;
  final String email;
  final String name;
  final String? username;
  final String? bio;
  final String? profilePictureUrl;
  final bool isMentor;
  final int promotionYear;
  final int totalFollowers;
  final int totalFollowing;
  final int totalPosts;
  final Department? department;
  final Batch? batch;
  final UserCategory? category;
  final String? phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.bio,
    this.profilePictureUrl,
    this.isMentor = false,
    this.promotionYear = 0,
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.totalPosts = 0,
    this.department,
    this.batch,
    this.category,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] is Map ? json['email']['value'] : (json['email'] ?? ''), // Handle object or string
      name: json['name'] ?? '',
      username: json['username'],
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
      isMentor: json['isMentor'] ?? false,
      promotionYear: json['promotionYear'] ?? 0,
      totalFollowers: json['totalFollowers'] ?? 0,
      totalFollowing: json['totalFollowing'] ?? 0,
      totalPosts: json['totalPosts'] ?? 0,
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      batch: json['batch'] != null ? Batch.fromJson(json['batch']) : null,
      category: json['category'] != null ? UserCategory.fromJson(json['category']) : null,
      phoneNumber: json['phoneNumber'] is Map ? json['phoneNumber']['value'] : json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'isMentor': isMentor,
      'promotionYear': promotionYear,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'totalPosts': totalPosts,
      'department': department?.toJson(),
      'batch': batch?.toJson(),
      'category': category?.toJson(),
      'phoneNumber': phoneNumber,
    };
  }
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Batch {
  final int id;
  final String department;
  final int endYear;

  Batch({required this.id, required this.department, required this.endYear});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] ?? 0,
      department: json['departement'] ?? '', // Note spelling in API: departement
      endYear: json['endYear'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'departement': department, 'endYear': endYear};
}

class UserCategory {
  final int id;
  final String name;
  final String? description;

  UserCategory({required this.id, required this.name, this.description});

  factory UserCategory.fromJson(Map<String, dynamic> json) {
    return UserCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description};
}
