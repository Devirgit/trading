part of 'stock_deal_bloc.dart';

abstract class StockDealEvent extends Equatable {
  const StockDealEvent({this.type = DealType.buy});

  final DealType type;
  @override
  List<Object> get props => [
        type,
      ];
}

class VolumeChangeEvent extends StockDealEvent {
  const VolumeChangeEvent({DealType? type, required this.volume});

  final String volume;
  @override
  List<Object> get props => [type, volume];
}

class PriceChangeEvent extends StockDealEvent {
  const PriceChangeEvent({DealType? type, required this.price});

  final String price;
  @override
  List<Object> get props => [type, price];
}

class SubmitEvent extends StockDealEvent {
  const SubmitEvent({
    DealType? type,
  });

  @override
  List<Object> get props => [type];
}
