import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = '']) : super(message);
  static String getMessage(type) {
    switch (type) {
      case 'timeout-error':
        return 'Не получен ответ в отведенное время';
      case 'server-error':
        return 'Произошла ошибка на сервере, повторите позднее';
      default:
        return 'Не получен ответ от сервера. Проверьте подключение к интернет.';
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure([String message = '']) : super(message);
}
