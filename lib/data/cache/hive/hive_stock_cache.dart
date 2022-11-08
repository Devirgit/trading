import 'package:trading/core/types/types.dart';
import 'package:trading/data/cache/hive/hive_base.dart';
import 'package:trading/data/cache/interface/stock_cache_interface.dart';
import 'package:trading/data/model/stock_model.dart';
import 'package:flutter/foundation.dart';

class HiveStockCache implements StockCache {
  static const _activeStockKey = 'active_stock';
  static const _casheStockKey = 'cache_stock';

  @override
  Future<StockModel?> getActiveStock() async {
    final StockModel? stock =
        await HiveBase().read(HiveBase.stateAppCache, _activeStockKey);
    return stock;
  }

  @override
  Future<void> setActiveStock(StockModel stock) {
    return HiveBase().write(stock,
        boxName: HiveBase.stateAppCache, keyName: _activeStockKey);
  }

  @override
  Future<List<StockModel>?> getStockCategory(CategoryUID categoryUID) async {
    final List<dynamic>? stocks = await HiveBase()
        .read(HiveBase.dataAppCache, _casheStockKey + categoryUID.toString());

    if (stocks != null) {
      final result = stocks
          .map(
            (item) => item as StockModel,
          )
          .toList();
      return result;
    }

    return SynchronousFuture(null);
  }

  @override
  Future<void> setStockCategory(
      CategoryUID categoryUID, List<StockModel> stocks) {
    return HiveBase().write(stocks,
        boxName: HiveBase.dataAppCache,
        keyName: _casheStockKey + categoryUID.toString());
  }
}
