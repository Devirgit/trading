import 'package:trading/data/model/category_model.dart';

abstract class CategoryCache {
  Future<List<CategoryModel>?> getCategories();

  Future<void> setCategories(List<CategoryModel> params);
}
