import 'package:trading/core/types/types.dart';
import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';

class GetCategories extends UseCaseStream<List<CategoryEntity>, CategoryUID?> {
  GetCategories(CategoryRepository repository) : _repository = repository;

  final CategoryRepository _repository;

  @override
  Stream<Respons<Failure, List<CategoryEntity>>> call(
      [CategoryUID? params]) async* {
    yield* _repository.getAll(params);
  }
}
