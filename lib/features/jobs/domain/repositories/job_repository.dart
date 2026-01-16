import '../entities/job_entity.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs({int page = 0, int size = 10});
  Future<Job> getJobDetails(int id);
  Future<Job> createJob(String title, String companyName, String location, String type, String description, String salary, DateTime deadline, String applicationUrl, int publisherId);
  Future<void> applyJob(int jobId);
}
