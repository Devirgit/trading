import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/repository/deal_repository.dart';

class GetDeals extends UseCase<PageListEntitis<DealEntity>, DealParams> {
  GetDeals(DealRepository repository) : _repository = repository;

  final DealRepository _repository;

  @override
  Future<Respons<Failure, PageListEntitis<DealEntity>>> call(
      DealParams params) async {
    return await _repository.getDeals(params.stockUID, cursor: params.cursor);
  }
}
