import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';

class DealModel extends DealEntity {
  const DealModel({
    required DealUid uid,
    required double count,
    required double price,
    required int typeID,
    required double pnl,
    required int volume,
    required DateTime date,
  }) : super(
            count: count,
            date: date,
            pnl: pnl,
            price: price,
            typeID: typeID,
            uid: uid,
            volume: volume);

  int get typeID => type == DealType.buy ? 1 : 2;

  DealModel.fromJson(Map<String, dynamic> map)
      : super(
            uid: map['id'] as int,
            count: map['count_deal'] * 1.0,
            date: DateTime.parse(map['date']),
            pnl: map['pnl'] * 1.0,
            price: map['price_deal'] * 1.0,
            typeID: map['type'],
            volume: map['volume'] as int);
}

class DealListModel extends PageListEntitis<DealModel> {
  const DealListModel(List<DealModel> items,
      {String? nextPage, String? prevPage})
      : super(items, nextPage: nextPage, prevPage: prevPage);

  DealListModel.fromJson(Map<String, dynamic> map)
      : super(_fromMap(map['data'] as List<dynamic>),
            prevPage: map['links']['prev'], nextPage: map['links']['next']);

  static List<DealModel> _fromMap(List<dynamic> items) {
    return items
        .map((e) => DealModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
