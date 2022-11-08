import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';

abstract class DealRepository {
  Future<Respons<Failure, PageListEntitis<DealEntity>>> getDeals(
      StockUid stockUID,
      {String? cursor});
}
