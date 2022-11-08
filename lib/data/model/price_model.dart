import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/price_entity.dart';

class PriceModel extends PriceEntity {
  const PriceModel({
    required String symbolId,
    required String name,
    required String description,
    required String source,
    required double price,
    required String iconUri,
  }) : super(
            description: description,
            symbolID: symbolId,
            name: name,
            source: source,
            iconUri: iconUri,
            price: price);

  PriceModel.fromJson(Map<String, dynamic> map)
      : super(
            symbolID: map['symbol_id'] as String,
            name: map['name'] as String,
            description: map['descript'] as String,
            source: map['source'] as String,
            price: map['price'] * 1.0,
            iconUri: map['icon_uri'] as String);
}

class PriceListModel extends PageListEntitis<PriceEntity> {
  const PriceListModel(List<PriceEntity> items,
      {String? nextPage, String? prevPage})
      : super(items, nextPage: nextPage, prevPage: prevPage);

  PriceListModel.fromJson(Map<String, dynamic> map)
      : super(_fromMap(map['data'] as List<dynamic>),
            prevPage: map['links']['prev'], nextPage: map['links']['next']);

  static List<PriceEntity> _fromMap(List<dynamic> items) {
    return items
        .map((e) => PriceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
