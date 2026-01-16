import '../auth_domain.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call(int userId) async {
    return await repository.logout(userId);
  }
}
