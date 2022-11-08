import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/price_entity.dart';
import 'package:trading/domain/repository/price_repository.dart';
import 'package:trading/domain/usecases/interface/data_list_operation.dart';

class GetAllPrice extends GetDataUC<PageListEntitis<PriceEntity>> {
  GetAllPrice(PriceRepository repository) : _repository = repository;

  final PriceRepository _repository;
  @override
  Future<Respons<Failure, PageListEntitis<PriceEntity>>> call(params) async {
    return await _repository.getPrice(params);
  }
}
