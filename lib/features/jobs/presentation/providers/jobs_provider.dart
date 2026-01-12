import 'package:flutter/material.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/usecases/create_job_usecase.dart';

class JobsProvider extends ChangeNotifier {
  final GetJobsUseCase getJobsUseCase;
  final CreateJobUseCase createJobUseCase;

  List<Job> _jobs = [];
  bool _isLoading = false;
  String? _error;

  JobsProvider({
    required this.getJobsUseCase, 
    required this.createJobUseCase
  });

  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadJobs({bool refresh = false}) async {
    if (refresh) {
      _jobs = [];
      _isLoading = true;
      notifyListeners();
    }
    
    // If not refreshing and already have jobs, maybe don't load? Or pagination logic.
    // For now simple load.

    try {
      final newJobs = await getJobsUseCase();
      _jobs = newJobs; 
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createJob(String title, String companyName, String location, String type, String description, String salary, DateTime deadline, String applicationUrl, int publisherId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newJob = await createJobUseCase(title, companyName, location, type, description, salary, deadline, applicationUrl, publisherId);
      _jobs.insert(0, newJob);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
