import '../auth_domain.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<User> call(int id, {String? name, String? bio, String? profilePictureUrl}) {
    return repository.updateUser(id, name: name, bio: bio, profilePictureUrl: profilePictureUrl);
  }
}
