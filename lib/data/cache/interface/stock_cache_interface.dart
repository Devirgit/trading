import 'package:trading/core/types/types.dart';
import 'package:trading/data/model/stock_model.dart';

abstract class StockCache {
  Future<StockModel?> getActiveStock();

  Future<void> setActiveStock(StockModel stock);

  Future<List<StockModel>?> getStockCategory(CategoryUID categoryUID);

  Future<void> setStockCategory(
      CategoryUID categoryUID, List<StockModel> stocks);
}
