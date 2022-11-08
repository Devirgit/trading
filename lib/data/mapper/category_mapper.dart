import 'package:trading/data/model/category_model.dart';
import 'package:trading/domain/entitis/category_entity.dart';

class CategoryMapper {
  static CategoryEntity fromApi(CategoryModel item) {
    return CategoryEntity(
      uid: item.uid,
      currency: item.currency,
      name: item.name,
      icon: item.icon,
      indexPosition: item.indexPosition,
    );
  }

  static CategoryModel toApi(CategoryEntity item) {
    return CategoryModel(
      uid: item.uid,
      name: item.name,
      currency: item.currency,
      icon: item.icon,
      indexPosition: item.indexPosition,
    );
  }
}
