import 'package:trading/core/types/types.dart';
import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/stock_repository.dart';

class GetStockCategory extends UseCaseStream<List<StockEntity>, CategoryUID> {
  GetStockCategory(StockRepository repository) : _repository = repository;

  final StockRepository _repository;

  @override
  Stream<Respons<Failure, List<StockEntity>>> call(CategoryUID params) async* {
    yield* _repository.getStockCategory(params);
  }
}
