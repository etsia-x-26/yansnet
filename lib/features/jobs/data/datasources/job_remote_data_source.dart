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
    try {
      final body = {
        "title": jobData['title'],
        "description": jobData['description'],
        "type": jobData['type'].toString().toUpperCase().replaceAll(' ', '_'),
        "location": jobData['location'],
        "salary": jobData['salary'],
        "deadline": jobData['deadline'],
        "applicationUrl": jobData['applicationUrl'],
        "companyName": jobData['companyName'],
        "publisher": {
          "id": jobData['publisherId']
        }
      };

      final response = await apiClient.dio.post('/api/jobs', data: body);
      return JobDto.fromJson(response.data).toEntity();
    } catch (e) {
      print('Error creating job: $e');
      rethrow;
    }
  }
}
