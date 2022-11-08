import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/stock_service_interface.dart';
import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/model/stock_model.dart';
import 'package:dio/dio.dart';

class BegetStockService implements StockService {
  BegetStockService(this.token);

  final String token;

  @override
  Future<StockListModel> getHistory([String? cursor]) async {
    final options = RequestOptions(
        path: cursor ?? 'stock/all',
        method: 'GET',
        baseUrl: cursor,
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return StockListModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<StockListModel> searchHistory(String search, [String? cursor]) async {
    final options = RequestOptions(
        path: cursor ?? 'stock/search/$search',
        method: 'GET',
        baseUrl: cursor,
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return StockListModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<StockModel> getOneStock(StockUid uid) async {
    final options = RequestOptions(
        path: 'stock/$uid',
        method: 'GET',
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, (item) {
      return StockModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<StockModel> buy(StockDealApiParams deal) async {
    final options = RequestOptions(
      path: 'deals/buy',
      method: 'POST',
      queryParameters: deal.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    return await BegetBase().request(options, (item) {
      return StockModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<StockModel> sell(StockDealApiParams deal) async {
    final options = RequestOptions(
        path: 'deals/sell',
        method: 'POST',
        queryParameters: deal.toJson(),
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, (item) {
      return StockModel.fromJson(item as Map<String, dynamic>);
    });
  }

  List<StockModel> _getCollection(List<dynamic> items) {
    return items
        .map((item) => StockModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<StockModel>> getStockCategory(CategoryUID categoryUID) async {
    final options = RequestOptions(
      path: 'category/$categoryUID/stock',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
    );

    return await BegetBase().request(options, (items) {
      return _getCollection(items['stock'] as List<dynamic>);
    });
  }
}
