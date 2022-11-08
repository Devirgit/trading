import 'package:trading/core/types/types.dart';
import 'package:trading/data/model/deal_model.dart';

abstract class DealService {
  Future<DealListModel> getDeals(StockUid stockUID, {String? cursor});
}
