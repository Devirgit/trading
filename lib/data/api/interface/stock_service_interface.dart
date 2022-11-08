import 'package:trading/core/types/types.dart';
import 'package:trading/data/model/stock_model.dart';

abstract class StockService {
  Future<StockListModel> getHistory([String? cursor]);

  Future<StockListModel> searchHistory(String search, [String? cursor]);

  Future<StockModel> getOneStock(StockUid uid);

  Future<List<StockModel>> getStockCategory(CategoryUID categoryUID);

  Future<StockModel> buy(StockDealApiParams deal);

  Future<StockModel> sell(StockDealApiParams deal);
}
