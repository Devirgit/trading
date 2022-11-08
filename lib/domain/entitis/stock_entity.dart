import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  const StockEntity({
    required this.uid,
    required this.categoryUID,
    required this.count,
    required this.symbol,
    required this.price,
    required this.iconUri,
    required this.symbolID,
    required this.categoryName,
    required this.updateDate,
    required this.currentPrice,
    required this.pnl,
  });
  final StockUid uid;
  final CategoryUID categoryUID;
  final String symbol;
  final String symbolID;
  final double count;
  final double price;
  final String iconUri;
  final String categoryName;
  final DateTime updateDate;
  final double currentPrice;
  final double pnl;

  double get profit => count * currentPrice - count * price;
  double get margin => count * price;

  @override
  List<Object?> get props =>
      [uid, categoryUID, symbol, symbolID, count, price, currentPrice, pnl];
}

class StockDealParams extends Equatable {
  const StockDealParams({
    required this.categoryUID,
    required this.count,
    required this.price,
    required this.symbol,
    this.stockUID,
    required this.symbolID,
  });

  const StockDealParams.empty()
      : this(categoryUID: 0, count: 0, price: 0, symbolID: '', symbol: '');

  final CategoryUID categoryUID;
  final StockUid? stockUID;
  final String symbolID;
  final String symbol;
  final double count;
  final double price;

  @override
  List<Object?> get props => [categoryUID, symbolID, count, price];
}
