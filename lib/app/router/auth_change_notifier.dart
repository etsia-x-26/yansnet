import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';
import 'package:yansnet/authentication/cubit/auth_state.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final AuthenticationCubit _authCubit;
  late StreamSubscription _authSubscription;

  AuthChangeNotifier(this._authCubit) {
    _authSubscription = _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  AuthenticationState get state => _authCubit.state;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}