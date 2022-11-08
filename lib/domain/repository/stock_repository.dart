import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/search_params.dart';
import 'package:trading/domain/entitis/stock_entity.dart';

abstract class StockRepository {
  Future<Respons<Failure, PageListEntitis<StockEntity>>> getHistory(
      String? cursor);

  Future<Respons<Failure, PageListEntitis<StockEntity>>> search(
      SearchParams search);

  Future<Respons<Failure, StockEntity>> getOneStock(StockUid uid);

  Stream<Respons<Failure, List<StockEntity>>> getStockCategory(CategoryUID uid);

  Future<Respons<Failure, StockEntity>> buy(StockDealParams deal);

  Future<Respons<Failure, StockEntity>> sell(StockDealParams deal);
}
