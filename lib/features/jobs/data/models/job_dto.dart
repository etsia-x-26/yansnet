import '../../domain/entities/job_entity.dart';

class JobDto {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String type;
  final String postedAt;
  final String? bannerUrl;
  final String? applicationUrl;
  final String? salary;
  final String? deadline;

  JobDto({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    required this.type,
    required this.postedAt,
    this.bannerUrl,
    this.applicationUrl,
    this.salary,
    this.deadline,
  });

  factory JobDto.fromJson(Map<String, dynamic> json) {
    return JobDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      companyName: json['publisherName'] ?? json['companyName'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? 'FULL_TIME',
      postedAt: json['createdAt'] ?? json['postedAt'] ?? DateTime.now().toIso8601String(),
      bannerUrl: json['bannerUrl'],
      applicationUrl: json['applicationUrl'],
      salary: json['salary'],
      deadline: json['deadline'],
    );
  }

  Job toEntity() {
    return Job(
      id: id,
      title: title,
      description: description,
      companyName: companyName,
      location: location,
      type: type,
      postedAt: DateTime.tryParse(postedAt) ?? DateTime.now(),
      bannerUrl: bannerUrl,
      applicationUrl: applicationUrl,
      salary: salary,
      deadline: deadline != null ? DateTime.tryParse(deadline!) : null,
    );
  }
}
