import 'package:trading/data/model/stock_model.dart';
import 'package:trading/domain/entitis/stock_entity.dart';

class StockMapper {
  static StockModel toApi(StockEntity item) {
    return StockModel(
        categoryName: item.categoryName,
        categoryUID: item.categoryUID,
        count: item.count,
        currentPrice: item.currentPrice,
        iconUri: item.iconUri,
        pnl: item.pnl,
        price: item.price,
        symbol: item.symbol,
        symbolID: item.symbolID,
        uid: item.uid,
        updateDate: item.updateDate);
  }
}
