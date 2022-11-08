import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

class DealEntity extends Equatable {
  const DealEntity({
    required this.uid,
    required this.count,
    required this.price,
    required int typeID,
    required this.pnl,
    required this.volume,
    required this.date,
  }) : type = typeID == 1 ? DealType.buy : DealType.sell;

  final DealUid uid;
  final double count;
  final double price;
  final DealType type;
  final double pnl;
  final int volume;
  final DateTime date;

  @override
  List<Object?> get props => [
        uid,
      ];
}

class DealParams {
  DealParams(this.stockUID, {this.cursor});
  final StockUid stockUID;
  final String? cursor;
}
