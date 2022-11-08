import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/stock_repository.dart';
import 'package:trading/domain/usecases/interface/data_list_operation.dart';

class GetStockHistory extends GetDataUC<PageListEntitis<StockEntity>> {
  GetStockHistory(StockRepository repository) : _repository = repository;

  final StockRepository _repository;
  @override
  Future<Respons<Failure, PageListEntitis<StockEntity>>> call(
      String? params) async {
    return await _repository.getHistory(params);
  }
}
