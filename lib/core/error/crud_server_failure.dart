import 'package:trading/core/error/failure.dart';

class CRUDServerFailure extends ServerFailure {
  const CRUDServerFailure([String message = 'Ошибка обращения к серверу.'])
      : super(message);

  factory CRUDServerFailure.fromType(String type) {
    switch (type) {
      case 'create-error':
        return const CRUDServerFailure(
            'При сохранении данных возникла ошибка, попробуйте еще раз позднее.');
      case 'get-error':
        return const CRUDServerFailure(
            'Не удалось получить данные. Проверьте подключение к интернет.');
      case 'update-error':
        return const CRUDServerFailure(
            'Не удалось обновить данные. Проверьте подключение к интернет.');
      case 'delete-error':
        return const CRUDServerFailure(
            'При удалении возникла ошибка, попробуйте еще раз позднее.');
      default:
        return CRUDServerFailure(ServerFailure.getMessage(type));
    }
  }
}
