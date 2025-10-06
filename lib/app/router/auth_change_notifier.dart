import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:yansnet/authentication/cubit/auth_state.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this._authCubit) {
    _authSubscription = _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }
  
  final AuthenticationCubit _authCubit;
  late StreamSubscription<AuthenticationState> _authSubscription;

  

  AuthenticationState get state => _authCubit.state;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}