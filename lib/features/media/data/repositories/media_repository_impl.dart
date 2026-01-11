import 'dart:io';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_remote_data_source.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;

  MediaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> uploadFile(File file) async {
    return await remoteDataSource.uploadFile(file);
  }
}
