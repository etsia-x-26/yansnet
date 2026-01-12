import '../../../../core/network/api_client.dart';
import '../../domain/entities/job_entity.dart';
import '../models/job_dto.dart';

abstract class JobRemoteDataSource {
  Future<List<Job>> getJobs({int page = 0, int size = 10});
  Future<Job> getJobDetails(int id);
  Future<Job> createJob(Map<String, dynamic> jobData);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final ApiClient apiClient;

  JobRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Job>> getJobs({int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.dio.get('/api/jobs', queryParameters: {
        'page': page,
        'size': size,
      });

      final data = response.data;
      if (data != null && data['content'] != null) {
        return (data['content'] as List).map((e) => JobDto.fromJson(e).toEntity()).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }

  @override
  Future<Job> getJobDetails(int id) async {
    try {
      final response = await apiClient.dio.get('/api/jobs/$id');
      return JobDto.fromJson(response.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Job> createJob(Map<String, dynamic> jobData) async {
    // Simulating success
    await Future.delayed(const Duration(seconds: 1));
    return Job(
      id: DateTime.now().millisecondsSinceEpoch,
      title: jobData['title'],
      companyName: jobData['companyName'],
      location: jobData['location'],
      type: jobData['type'],
      description: jobData['description'],
      postedAt: DateTime.now(),
      bannerUrl: null,
    );
  }
}
