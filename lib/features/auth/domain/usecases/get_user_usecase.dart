import '../auth_domain.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<User> call(int id) {
    return repository.getUser(id);
  }
}
