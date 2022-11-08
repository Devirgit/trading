import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/category_service_interface.dart';
import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/model/category_model.dart';
import 'package:dio/dio.dart';

class BegetCategoryService implements CategoryService {
  BegetCategoryService(this.token);

  final String token;

  @override
  Future<CategoryModel> createCategory(CategoryModel item) async {
    final options = RequestOptions(
        path: 'category',
        method: 'POST',
        queryParameters: item.toJson(),
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, (item) {
      return CategoryModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<bool> deleteCategory(CategoryUID uid) async {
    final options = RequestOptions(
        path: 'category/$uid',
        method: 'DELETE',
        headers: {'Authorization': 'Bearer $token'});
    return await BegetBase().request(options, (item) => true);
  }

  List<CategoryModel> getCollection(List<dynamic> items) {
    final List<CategoryModel> result = [];
    if (items.isNotEmpty) {
      for (Map<String, dynamic> element in items) {
        result.add(CategoryModel.fromJson(element));
      }
    }
    return result;
  }

  @override
  Future<List<CategoryModel>> getCategory([CategoryUID? id]) async {
    final options = RequestOptions(
        path: id == null ? 'category' : 'category/$id',
        method: 'GET',
        headers: {'Authorization': 'Bearer $token'});
    return await BegetBase().request(options, (item) {
      return id == null ? getCollection(item) : [CategoryModel.fromJson(item)];
    });
  }

  @override
  Future<CategoryModel> updateCatergory(CategoryModel item) async {
    final options = RequestOptions(
        path: 'category/${item.uid}',
        method: 'PUT',
        queryParameters: item.toJson(),
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, (item) {
      return CategoryModel.fromJson(item as Map<String, dynamic>);
    });
  }
}
