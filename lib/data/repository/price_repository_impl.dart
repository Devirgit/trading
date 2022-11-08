import 'package:trading/core/error/crud_server_failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/data/api/interface/price_service_interface.dart';
import 'package:trading/data/model/price_model.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/domain/entitis/search_params.dart';
import 'package:trading/domain/repository/price_repository.dart';

class PriceRepositoryImpl extends PriceRepository {
  PriceRepositoryImpl(this.priceService);

  final PriceService priceService;

  Future<Respons<Failure, T>> _catchData<T>(ResultFunction<T> onAction) async {
    try {
      return Right(await onAction());
    } on ServerException catch (e) {
      return Left(CRUDServerFailure.fromType(e.type));
    }
  }

  @override
  Future<Respons<Failure, PriceListModel>> getPrice(String? cursor) async {
    return _catchData(() async => await priceService.getPrice(cursor));
  }

  @override
  Future<Respons<Failure, PriceListModel>> search(SearchParams search) async {
    return _catchData(
        () async => priceService.searchPrice(search.search, search.cursor));
  }
}
