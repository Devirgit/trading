import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';

class UpdateCategory extends UseCase<CategoryEntity, CategoryEntity> {
  UpdateCategory(CategoryRepository repository) : _repository = repository;

  final CategoryRepository _repository;

  @override
  Future<Respons<Failure, CategoryEntity>> call(CategoryEntity params) async {
    return await _repository.update(params);
  }
}
