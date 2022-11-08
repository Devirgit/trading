import 'package:trading/core/error/crud_server_failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/data/api/interface/deal_service_interface.dart';
import 'package:trading/data/model/deal_model.dart';
import 'package:trading/domain/repository/deal_repository.dart';

class DealRepositoryImpl extends DealRepository {
  DealRepositoryImpl({required this.dealService});

  final DealService dealService;

  @override
  Future<Respons<Failure, DealListModel>> getDeals(StockUid stockUID,
      {String? cursor}) async {
    try {
      final deals = await dealService.getDeals(stockUID, cursor: cursor);

      return Right(deals);
    } on ServerException catch (e) {
      return Left(CRUDServerFailure.fromType(e.type));
    }
  }
}
