import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/category_entity.dart';

abstract class CategoryRepository {
  Future<Respons<Failure, CategoryEntity>> create(NewCategory item);

  Future<Respons<Failure, bool>> delete(CategoryUID uid);

  Future<Respons<Failure, CategoryEntity>> update(CategoryEntity edited);

  Stream<Respons<Failure, List<CategoryEntity>>> getAll(CategoryUID? uid);
}

class NewCategory {
  NewCategory(this.name, this.curency, this.icon);

  final String name;
  final String curency;
  final int icon;
}
