import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/stock_entity.dart';

class StockModel extends StockEntity {
  const StockModel({
    required StockUid uid,
    required CategoryUID categoryUID,
    required String categoryName,
    required String symbol,
    required String symbolID,
    required double count,
    required double price,
    required DateTime updateDate,
    required String iconUri,
    required double currentPrice,
    required double pnl,
  }) : super(
            categoryUID: categoryUID,
            categoryName: categoryName,
            count: count,
            iconUri: iconUri,
            price: price,
            symbol: symbol,
            symbolID: symbolID,
            uid: uid,
            updateDate: updateDate,
            currentPrice: currentPrice,
            pnl: pnl);

  StockModel.fromJson(Map<String, dynamic> map)
      : super(
          categoryUID: map['category_id'] as int,
          categoryName: map['category_name'] as String,
          count: map['count'] * 1.0,
          iconUri: map['icon_url'] as String,
          price: map['price'] * 1.0,
          symbol: map['symbol'] as String,
          symbolID: map['symbol_id'] as String,
          uid: map['id'] as int,
          updateDate: DateTime.parse(map['update_date']),
          currentPrice: map['current_price'] * 1.0,
          pnl: map['pnl'] * 1.0,
        );

  Map<String, dynamic> toJson() => {
        'category_id': categoryUID,
        'category_name': categoryName,
        'count': count,
        'icon_url': iconUri,
        'price': price,
        'symbol': symbol,
        'symbol_id': symbolID,
        'id': uid,
        'update_date': updateDate.toString(),
        'current_price': currentPrice,
        'pnl': pnl
      };
}

class StockListModel extends PageListEntitis<StockModel> {
  const StockListModel(List<StockModel> items,
      {String? nextPage, String? prevPage})
      : super(items, nextPage: nextPage, prevPage: prevPage);

  StockListModel.fromJson(Map<String, dynamic> map)
      : super(_fromMap(map['data'] as List<dynamic>),
            prevPage: map['links']['prev'], nextPage: map['links']['next']);

  static List<StockModel> _fromMap(List<dynamic> items) {
    return items
        .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class StockDealApiParams {
  const StockDealApiParams({
    required this.categoryUID,
    this.stockUID,
    required this.symbolID,
    required this.count,
    required this.price,
  });

  final CategoryUID categoryUID;
  final StockUid? stockUID;
  final String symbolID;
  final double count;
  final double price;

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryUID,
      'stock_id': stockUID ?? -1,
      'symbol_id': symbolID,
      'count_deal': count,
      'price_deal': price
    };
  }
}
