import 'package:trading/core/error/crud_server_failure.dart';

class CategoryFailure extends CRUDServerFailure {
  const CategoryFailure([String message = 'Ошибка обращения к серверу.'])
      : super(message);

  factory CategoryFailure.fromType(String type) {
    switch (type) {
      case 'not-found':
        return const CategoryFailure('Позиция не найдена');
      case 'not-empty':
        return const CategoryFailure(
            'В категории содержатся история операций.');
      default:
        return CategoryFailure(CRUDServerFailure.fromType(type).message);
    }
  }
}
