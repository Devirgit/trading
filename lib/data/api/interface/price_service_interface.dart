import 'package:trading/data/model/price_model.dart';

abstract class PriceService {
  Future<PriceListModel> getPrice([String? cursor]);

  Future<PriceListModel> searchPrice(String search, [String? cursor]);
}
