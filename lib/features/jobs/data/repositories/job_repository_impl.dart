import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Job>> getJobs({int page = 0, int size = 10}) {
    return remoteDataSource.getJobs(page: page, size: size);
  }

  @override
  Future<Job> getJobDetails(int id) {
    return remoteDataSource.getJobDetails(id);
  }
}
