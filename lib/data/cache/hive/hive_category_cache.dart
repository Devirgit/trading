import 'package:trading/data/cache/hive/hive_base.dart';
import 'package:trading/data/cache/interface/category_cache_interface.dart';
import 'package:trading/data/model/category_model.dart';
import 'package:flutter/foundation.dart';

class HiveCategoryCache implements CategoryCache {
  static const _categoryKey = 'category_list';

  @override
  Future<List<CategoryModel>?> getCategories() async {
    final List<dynamic>? category =
        await HiveBase().read(HiveBase.dataAppCache, _categoryKey);
    if (category != null) {
      final result = category
          .map(
            (item) => item as CategoryModel,
          )
          .toList();
      return result;
    }
    return SynchronousFuture(null);
  }

  @override
  Future<void> setCategories(List<CategoryModel> params) {
    return HiveBase()
        .write(params, boxName: HiveBase.dataAppCache, keyName: _categoryKey);
  }
}
