import 'package:trading/core/types/types.dart';
import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/repository/category_repository.dart';

class DeleteCategory extends UseCase<bool, CategoryUID> {
  DeleteCategory(CategoryRepository repository) : _repository = repository;

  final CategoryRepository _repository;

  @override
  Future<Respons<Failure, bool>> call(CategoryUID params) async {
    return await _repository.delete(params);
  }
}
