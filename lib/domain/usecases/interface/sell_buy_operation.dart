import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/stock_entity.dart';

abstract class SellBuyUC extends UseCase<StockEntity, StockDealParams> {
  @override
  Future<Respons<Failure, StockEntity>> call(StockDealParams params);
}
