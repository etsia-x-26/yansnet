import '../entities/job_entity.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs({int page = 0, int size = 10});
  Future<Job> getJobDetails(int id);
}
