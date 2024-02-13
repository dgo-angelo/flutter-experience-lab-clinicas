import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:lab_clinicas_self_service/src/services/user_login_service.dart';

class LoginController with MessageStateMixin {
  final UserLoginService _loginService;
  LoginController({
    required UserLoginService loginService,
  }) : _loginService = loginService;
  final _obscurePassword = signal(true);
  final _logged = signal(false);
  bool get logged => _logged();

  bool get obscurePassword => _obscurePassword();

  void passwordToggle() => _obscurePassword.value = !_obscurePassword.value;

  Future<void> login(String email, String password) async {
    final loginResult =
        await _loginService.execute(email, password).asyncLoader();

    switch (loginResult) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: _):
        _logged.value = true;
    }
  }
}
