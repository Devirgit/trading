import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/api/interface/price_service_interface.dart';
import 'package:trading/data/model/price_model.dart';
import 'package:dio/dio.dart';

class BegetPriceService implements PriceService {
  BegetPriceService(this.token);

  final String token;

  @override
  Future<PriceListModel> getPrice([String? cursor]) async {
    final options = RequestOptions(
        path: cursor ?? 'price',
        method: 'GET',
        baseUrl: cursor,
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return PriceListModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<PriceListModel> searchPrice(String search, [String? cursor]) async {
    final options = RequestOptions(
        path: cursor ?? 'price/search/$search',
        method: 'GET',
        baseUrl: cursor,
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return PriceListModel.fromJson(item as Map<String, dynamic>);
    });
  }
}
