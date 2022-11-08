import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/stock_repository.dart';
import 'package:trading/domain/usecases/interface/sell_buy_operation.dart';

class SellStock extends SellBuyUC {
  SellStock(StockRepository repository) : _repository = repository;

  final StockRepository _repository;

  @override
  Future<Respons<Failure, StockEntity>> call(StockDealParams params) async {
    return await _repository.sell(params);
  }
}
