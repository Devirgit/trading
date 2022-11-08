import 'package:trading/core/error/failure.dart';

class RegisterServerFailure extends ServerFailure {
  const RegisterServerFailure([String message = 'Ошибка регистрации.'])
      : super(message);

  factory RegisterServerFailure.fromType(String type) {
    switch (type) {
      case 'response-error':
        return const RegisterServerFailure(
            'Пользователь с такими данными уже зарегистрован.');
      default:
        return RegisterServerFailure(ServerFailure.getMessage(type));
    }
  }
}

class LoginServerFailure extends ServerFailure {
  const LoginServerFailure([String message = 'Ошибка авторизации.'])
      : super(message);

  factory LoginServerFailure.fromType(String type) {
    switch (type) {
      case 'response-error':
        return const LoginServerFailure(
            'Не удалось авторизоваться, проверьте корректность введеных данных.');
      default:
        return LoginServerFailure(ServerFailure.getMessage(type));
    }
  }
}
