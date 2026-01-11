import 'dart:io';

abstract class MediaRepository {
  Future<String> uploadFile(File file);
}
