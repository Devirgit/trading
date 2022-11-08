import 'package:trading/core/types/types.dart';
import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/stock_repository.dart';

class GetOneStock extends UseCase<StockEntity, StockUid> {
  GetOneStock(StockRepository repository) : _repository = repository;

  final StockRepository _repository;

  @override
  Future<Respons<Failure, StockEntity>> call(StockUid params) async {
    return await _repository.getOneStock(params);
  }
}
