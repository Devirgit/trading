import 'package:trading/data/model/stock_model.dart';
import 'package:trading/domain/entitis/stock_entity.dart';

class StockDealMapper {
  static StockDealApiParams toApi(StockDealParams item) {
    return StockDealApiParams(
        categoryUID: item.categoryUID,
        count: item.count,
        price: item.price,
        symbolID: item.symbolID,
        stockUID: item.stockUID);
  }
}
