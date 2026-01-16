class Job {
  final int id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String type; // FULL_TIME, INTERNSHIP, etc.
  final DateTime postedAt;
  final String? bannerUrl;
  final String? applicationUrl;
  final String? salary;
  final DateTime? deadline;

  Job({
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
}
