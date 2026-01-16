import '../repositories/job_repository.dart';

class ApplyJobUseCase {
  final JobRepository repository;

  ApplyJobUseCase(this.repository);

  Future<void> call(int jobId) async {
    return await repository.applyJob(jobId);
  }
}
