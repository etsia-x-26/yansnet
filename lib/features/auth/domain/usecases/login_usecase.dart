import '../auth_domain.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponse> call(String email, String password) {
    return repository.login(email, password);
  }
}
