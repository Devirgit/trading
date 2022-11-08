import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

class StockModelSQL extends Equatable {
  const StockModelSQL(
      {required this.uid,
      required this.categoryUID,
      this.symbolID = '',
      this.symbol = '',
      this.count = 0.0,
      this.price = 0.0,
      this.lastdate,
      this.firstdate,
      this.iconURI = ''});

  final StockUid uid;
  final CategoryUID categoryUID;
  final String symbol;
  final String symbolID;
  final double count;
  final double price;
  final DateTime? lastdate;
  final DateTime? firstdate;
  final String iconURI;

  @override
  StockModelSQL.fromJson(Map<String, dynamic> map)
      : uid = map['uid'],
        categoryUID = map['category_id'],
        symbolID = map['symbol_id'],
        symbol = map['symbol'],
        count = map['count'],
        price = map['price'],
        lastdate = DateTime.fromMillisecondsSinceEpoch(map['lastdate']),
        firstdate = DateTime.fromMillisecondsSinceEpoch(map['firstdate']),
        iconURI = map['icon'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'category_id': categoryUID,
      'symbol': symbol,
      'symbol_id': symbolID,
      'count': count,
      'price': price,
      'lastdate': lastdate?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'firstdate': firstdate?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'icon': iconURI,
    };
  }

  StockModelSQL copyWith({
    required StockUid uid,
    CategoryUID? categoryUID,
    String? symbolID,
    String? symbol,
    double? count,
    double? price,
    DateTime? lastdate,
    DateTime? firstdate,
    String? iconURI,
  }) {
    return StockModelSQL(
      uid: uid,
      categoryUID: categoryUID ?? this.categoryUID,
      symbolID: symbolID ?? this.symbolID,
      symbol: symbol ?? this.symbol,
      count: count ?? this.count,
      price: price ?? this.price,
      lastdate: lastdate ?? this.lastdate,
      firstdate: firstdate ?? this.firstdate,
      iconURI: iconURI ?? this.iconURI,
    );
  }

  bool get isEmpty => uid < 0;

  @override
  List<Object?> get props => [uid, symbolID];
}
