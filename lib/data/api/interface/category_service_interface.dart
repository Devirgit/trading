import 'package:trading/core/types/types.dart';
import 'package:trading/data/model/category_model.dart';

abstract class CategoryService {
  Future<List<CategoryModel>> getCategory([CategoryUID? id]);

  Future<CategoryModel> updateCatergory(CategoryModel item);

  Future<CategoryModel> createCategory(CategoryModel item);

  Future<bool> deleteCategory(CategoryUID categoryUid);
}
