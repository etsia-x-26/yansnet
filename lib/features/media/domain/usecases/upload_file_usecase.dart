import 'dart:io';
import '../repositories/media_repository.dart';

class UploadFileUseCase {
  final MediaRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call(File file) async {
    return await repository.uploadFile(file);
  }
}
