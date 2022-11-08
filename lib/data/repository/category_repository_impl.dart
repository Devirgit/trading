import 'package:trading/core/error/category_failure.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/category_service_interface.dart';
import 'package:trading/data/cache/interface/category_cache_interface.dart';
import 'package:trading/data/model/category_model.dart';
import 'package:trading/data/mapper/category_mapper.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';
import 'package:flutter/foundation.dart';

typedef CategoriesChange = List<CategoryModel> Function(
    List<CategoryModel> oldList);

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
      {required this.cacheCategory, required this.categoryService});

  final CategoryCache cacheCategory;
  final CategoryService categoryService;

  Future<Respons<Failure, T>> _catchData<T>(ResultFunction<T> onAction) async {
    try {
      return Right(await onAction());
    } on CacheException {
      return const Left(CacheFailure());
    } on ServerException catch (e) {
      return Left(CategoryFailure.fromType(e.type));
    }
  }

  void _changeCacheData(CategoriesChange change) {
    final categoryCache = cacheCategory.getCategories();
    categoryCache.then((value) {
      if (value != null) {
        cacheCategory.setCategories(change(value));
      } else {
        cacheCategory.setCategories(change([]));
      }
    });
  }

  @override
  Future<Respons<Failure, CategoryEntity>> create(NewCategory item) async {
    return await _catchData(
      () async {
        final createCategory = CategoryModel(
            uid: -1, name: item.name, currency: item.curency, icon: item.icon);

        final service = categoryService.createCategory(createCategory);

        final category = await service.then((value) async {
          _changeCacheData(
            (oldList) => oldList..add(value),
          );
          return CategoryMapper.fromApi(value);
        }).catchError((e) => throw const ServerException('create-error'));

        return category;
      },
    );
  }

  @override
  Future<Respons<Failure, bool>> delete(CategoryUID uid) async {
    return await _catchData(() async {
      final service = categoryService.deleteCategory(uid);
      await service.then((value) {
        _changeCacheData(
          (oldList) => oldList..removeWhere((element) => element.uid == uid),
        );
      });

      return true;
    });
  }

  @override
  Future<Respons<Failure, CategoryEntity>> update(CategoryEntity edited) async {
    return await _catchData(() async {
      final oldCat = CategoryMapper.toApi(edited);

      final service = categoryService.updateCatergory(oldCat);

      final category = await service.then((value) {
        _changeCacheData(
          (oldList) {
            final index = oldList.indexWhere((item) => item.uid == value.uid);
            if (index != -1) {
              oldList[index] = value;
            } else {
              oldList.add(value);
            }

            return oldList;
          },
        );

        return CategoryMapper.fromApi(value);
      }).catchError((e) => throw const ServerException('update-error'));

      return category;
    });
  }

  List<CategoryEntity> mapperCollection(List<CategoryModel> items) {
    return items.map((item) => CategoryMapper.fromApi(item)).toList();
  }

  @override
  Stream<Respons<Failure, List<CategoryEntity>>> getAll(
      CategoryUID? uid) async* {
    try {
      final categoryCache = await cacheCategory.getCategories();
      if (categoryCache != null) {
        yield Right(mapperCollection(categoryCache));
      }

      final category = await categoryService.getCategory(uid);

      if (!listEquals<CategoryModel>(categoryCache, category)) {
        cacheCategory.setCategories(category);
        yield Right(mapperCollection(category));
      }
    } on ServerException catch (e) {
      yield Left(CategoryFailure.fromType(e.type));
    }
  }
}
