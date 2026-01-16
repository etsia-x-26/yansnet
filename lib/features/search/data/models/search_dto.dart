import '../../../posts/domain/entities/post_entity.dart' as post_entity;
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../../auth/domain/auth_domain.dart' as auth;

class SearchResultDto {
  final List<SearchResultItemDto> users;
  final List<SearchResultItemDto> posts;
  final List<SearchResultItemDto> events;
  final List<SearchResultItemDto> jobs;
  final int totalResults;
  final String query;

  SearchResultDto({
    required this.users,
    required this.posts,
    required this.events,
    required this.jobs,
    required this.totalResults,
    required this.query,
  });

  factory SearchResultDto.fromJson(Map<String, dynamic> json) {
    return SearchResultDto(
      users: (json['users'] as List?)?.map((e) => SearchResultItemDto.fromJson(e)).toList() ?? [],
      posts: (json['posts'] as List?)?.map((e) => SearchResultItemDto.fromJson(e)).toList() ?? [],
      events: (json['events'] as List?)?.map((e) => SearchResultItemDto.fromJson(e)).toList() ?? [],
      jobs: (json['jobs'] as List?)?.map((e) => SearchResultItemDto.fromJson(e)).toList() ?? [],
      totalResults: json['totalResults'] ?? 0,
      query: json['query'] ?? '',
    );
  }
}

class SearchResultItemDto {
  final int id;
  final String type; // USER, POST, EVENT, JOB
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? createdAt;
  final Map<String, dynamic>? metadata;

  SearchResultItemDto({
    required this.id,
    required this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.metadata,
  });

  factory SearchResultItemDto.fromJson(Map<String, dynamic> json) {
    return SearchResultItemDto(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      metadata: json['metadata'],
    );
  }

  auth.User toUserEntity() {
    return auth.User(
      id: id,
      name: title ?? '',
      username: metadata?['username'] ?? title,
      profilePictureUrl: imageUrl,
      isMentor: metadata?['isMentor'] ?? false,
      email: '', // Not provided in search
    );
  }

  post_entity.Post toPostEntity() {
    return post_entity.Post(
      id: id,
      content: description ?? '',
      createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
      totalLikes: metadata?['totalLikes'] ?? 0,
      totalComments: metadata?['totalComments'] ?? 0,
      user: auth.User(
        id: metadata?['authorId'] ?? 0,
        name: metadata?['authorName'] ?? 'Unknown',
        email: '',
      ),
      media: imageUrl != null ? [post_entity.Media(id: 0, url: imageUrl!, type: 'IMAGE')] : [],
    );
  }

  Job toJobEntity() {
    return Job(
      id: id,
      title: title ?? '',
      description: description ?? '',
      companyName: metadata?['companyName'] ?? 'Unknown',
      location: metadata?['location'] ?? 'Remote',
      type: metadata?['jobType'] ?? 'FULL_TIME',
      postedAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
      bannerUrl: imageUrl,
    );
  }

  Event toEventEntity() {
    return Event(
      id: id,
      title: title ?? '',
      description: description ?? '',
      location: metadata?['location'] ?? 'Online',
      eventDate: DateTime.tryParse(metadata?['eventDate'] ?? createdAt ?? '') ?? DateTime.now(),
      organizer: metadata?['organizerName'] ?? 'Unknown',
      bannerUrl: imageUrl,
    );
  }
}
