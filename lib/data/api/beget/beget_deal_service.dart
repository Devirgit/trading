import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/deal_service_interface.dart';
import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/model/deal_model.dart';
import 'package:dio/dio.dart';

class BegetDealService implements DealService {
  BegetDealService(this.token);

  final String token;

  @override
  Future<DealListModel> getDeals(StockUid stockUID, {String? cursor}) async {
    final options = RequestOptions(
        path: cursor ?? 'deals/$stockUID',
        method: 'GET',
        baseUrl: cursor,
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return DealListModel.fromJson(item as Map<String, dynamic>);
    });
  }
}
