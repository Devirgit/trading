import 'package:trading/core/error/crud_server_failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/stock_service_interface.dart';
import 'package:trading/data/cache/interface/stock_cache_interface.dart';
import 'package:trading/data/mapper/stock_deal_mapper.dart';
import 'package:trading/data/model/stock_model.dart';
import 'package:trading/domain/entitis/search_params.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/stock_repository.dart';
import 'package:flutter/foundation.dart';

class StockRepositoryImpl extends StockRepository {
  StockRepositoryImpl({required this.stockService, required this.stockCache});

  final StockService stockService;
  final StockCache stockCache;

  Future<Respons<Failure, T>> _catchData<T>(ResultFunction<T> onAction) async {
    try {
      return Right(await onAction());
    } on ServerException catch (e) {
      return Left(CRUDServerFailure.fromType(e.type));
    }
  }

  @override
  Future<Respons<Failure, StockListModel>> getHistory(String? cursor) async {
    return await _catchData(() async => await stockService.getHistory(cursor));
  }

  @override
  Future<Respons<Failure, StockListModel>> search(SearchParams search) async {
    return await _catchData(() async =>
        await stockService.searchHistory(search.search, search.cursor));
  }

  @override
  Future<Respons<Failure, StockModel>> getOneStock(StockUid uid) async {
    return await _catchData(() async {
      StockModel? cacheStock;
      if (uid == 0) {
        cacheStock = await stockCache.getActiveStock();
      }

      if (cacheStock != null) {
        return cacheStock;
      }

      final stock = await stockService.getOneStock(uid);
      stockCache.setActiveStock(stock);
      return stock;
    });
  }

  void _updateIfActiveStock(StockModel stock) async {
    stockCache.getActiveStock().then((item) {
      if (item != null && stock.uid == item.uid) {
        stockCache.setActiveStock(stock);
      }
    });
  }

  Future<void> _updateCacheStockList(StockModel stock) async {
    final stocks = await stockCache.getStockCategory(stock.categoryUID);
    if (stocks != null) {
      final changeIndex =
          stocks.indexWhere((element) => element.uid == stock.uid);

      if (changeIndex != -1) {
        if (stock.count <= 0) {
          stocks.removeAt(changeIndex);
        } else {
          stocks[changeIndex] = stock;
        }
        await stockCache.setStockCategory(stock.categoryUID, stocks);
      }
    }
  }

  @override
  Future<Respons<Failure, StockModel>> buy(StockDealParams deal) async {
    return await _catchData(() async {
      final stock = await stockService.buy(StockDealMapper.toApi(deal));

      _updateIfActiveStock(stock);

      await _updateCacheStockList(stock);
      return stock;
    });
  }

  @override
  Future<Respons<Failure, StockModel>> sell(StockDealParams deal) async {
    return await _catchData(() async {
      final stock = await stockService.sell(StockDealMapper.toApi(deal));

      _updateIfActiveStock(stock);
      await _updateCacheStockList(stock);

      return stock;
    });
  }

  @override
  Stream<Respons<Failure, List<StockModel>>> getStockCategory(
      CategoryUID uid) async* {
    try {
      final cacheStock = await stockCache.getStockCategory(uid);

      if (cacheStock != null) {
        yield Right(cacheStock);
      }

      final stock = await stockService.getStockCategory(uid);

      if (!listEquals<StockModel>(cacheStock, stock)) {
        stockCache.setStockCategory(uid, stock);
        yield Right(stock);
      }
    } on ServerException catch (e) {
      yield Left(CRUDServerFailure.fromType(e.type));
    }
  }
}
