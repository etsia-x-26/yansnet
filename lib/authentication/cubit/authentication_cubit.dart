import 'package:bloc/bloc.dart';
import 'package:yansnet/authentication/cubit/auth_state.dart';
import 'package:yansnet/authentication/models/login_credentials.dart';
import 'package:yansnet/authentication/models/registration_credentials.dart';
import 'package:yansnet/authentication/models/user.dart';
import 'package:yansnet/core/network/exceptions.dart';
import 'package:yansnet/core/utils/pref_utils.dart';
import 'package:yansnet/template/api/authentication_client.dart' hide HttpException;

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.authClient}) : super(const NoAuth());
  final AuthenticationClient authClient;

  Future<void> login(LoginCredentials credentials) async{
    emit(AuthLoading());
    try{
      final user = await authClient.loginUser(credentials);
      await saveToken(user.accessToken);
      emit(UserFetched(user: User.fromJson(user.toJson())));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
    }
  }

  Future<void> register(RegistrationCredentials credentials) async{
    emit(AuthLoading());
    try{
      final user = await authClient.registerUser(credentials);
      await saveToken(user.accessToken);
      emit(UserFetched(user: User.fromJson(user.toJson())));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
    }
  }

  Future<void> saveToken(String sessionId) async {
    await PrefUtils().setAuthToken(sessionId);
  }

  Future<void> logout(User user) async {
    try {
      emit(AuthLoading());
      const message = "User logged out";
      await PrefUtils()
          .setAuthToken('');
      await PrefUtils().removeUser();
      emit(const Logout(message: message));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
      emit(UserFetched(user: user));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
      emit(UserFetched(user: user));
    }
  }

}