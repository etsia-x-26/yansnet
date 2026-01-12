import '../entities/job_entity.dart';
import '../repositories/job_repository.dart';

class CreateJobUseCase {
  final JobRepository repository;

  CreateJobUseCase(this.repository);

  Future<Job> call(String title, String companyName, String location, String type, String description) {
    return repository.createJob(title, companyName, location, type, description);
  }
}
