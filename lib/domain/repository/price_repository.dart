import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/price_entity.dart';
import 'package:trading/domain/entitis/search_params.dart';

abstract class PriceRepository {
  Future<Respons<Failure, PageListEntitis<PriceEntity>>> getPrice(
      String? cursor);

  Future<Respons<Failure, PageListEntitis<PriceEntity>>> search(
      SearchParams search);
}
