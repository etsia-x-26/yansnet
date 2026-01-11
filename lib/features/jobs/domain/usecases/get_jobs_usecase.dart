import '../entities/job_entity.dart';
import '../repositories/job_repository.dart';

class GetJobsUseCase {
  final JobRepository repository;

  GetJobsUseCase(this.repository);

  Future<List<Job>> call({int page = 0, int size = 10}) {
    return repository.getJobs(page: page, size: size);
  }
}
