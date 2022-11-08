import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';

class CreateNewCategory extends UseCase<CategoryEntity, NewCategory> {
  CreateNewCategory(CategoryRepository repository) : _repository = repository;

  final CategoryRepository _repository;

  @override
  Future<Respons<Failure, CategoryEntity>> call(NewCategory params) async {
    return await _repository.create(params);
  }
}
