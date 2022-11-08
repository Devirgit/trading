import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

enum DealsType { buy, sell }

extension DealsTypeInt on DealsType {
  int get name {
    switch (this) {
      case DealsType.buy:
        return 1;
      case DealsType.sell:
        return 2;
    }
  }
}

class DealsModel extends Equatable {
  const DealsModel(
      {required this.uid,
      this.stokUID = 0,
      this.categoryUID = 0,
      this.countDeals = 0,
      this.pnl = 0,
      this.priceDeals = 0,
      this.type = DealsType.buy,
      this.volume = 0,
      this.date});

  final int uid;
  final StockUid stokUID;
  final CategoryUID categoryUID;
  final DealsType type;
  final double countDeals;
  final double priceDeals;
  final double pnl;
  final int volume;
  final DateTime? date;

  static DealsType parseType(int value) {
    return value == 1 ? DealsType.buy : DealsType.sell;
  }

  DealsModel.fromJson(Map<String, dynamic> map)
      : uid = map['uid'],
        stokUID = map['stok_id'],
        categoryUID = map['category_id'],
        type = parseType(map['type']),
        countDeals = map['count_deals'],
        priceDeals = map['price_deals'],
        pnl = map['pnl'],
        volume = map['volume'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'stok_id': stokUID,
      'category_id': categoryUID,
      'type': type.name,
      'count_deals': countDeals,
      'price_deals': priceDeals,
      'pnl': pnl,
      'volume': volume,
      'date': DateTime.now().millisecondsSinceEpoch,
    };
  }

  DealsModel copyWith({
    required int uid,
    int? stokUID,
    int? categoryUID,
    DealsType? type,
    double? countDeals,
    double? priceDeals,
    double? pnl,
    int? volume,
    DateTime? date,
  }) {
    return DealsModel(
      uid: uid,
      stokUID: stokUID ?? this.stokUID,
      categoryUID: categoryUID ?? this.categoryUID,
      type: type ?? this.type,
      countDeals: countDeals ?? this.countDeals,
      priceDeals: priceDeals ?? this.priceDeals,
      pnl: pnl ?? this.pnl,
      volume: volume ?? this.volume,
      date: date ?? this.date,
    );
  }

  bool get isEmpty => uid < 0;

  @override
  List<Object?> get props => [uid, type];
}
