import 'dart:io';
import '../repositories/media_repository.dart';

class UploadFileUseCase {
  final MediaRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call(File file, {String? folder}) async {
    return await repository.uploadFile(file); // Repository might ignoring folder for now, but signature needs to match call site
  }
}
