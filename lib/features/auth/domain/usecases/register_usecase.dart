import '../auth_domain.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> call(String name, String username, String email, String password) {
    return repository.register(name, username, email, password);
  }
}
