part of 'stocks_bloc.dart';

abstract class StocksEvent extends Equatable {
  const StocksEvent();

  @override
  List<Object> get props => [];
}

class StocksLoad extends StocksEvent {
  const StocksLoad(this.categoryUID);

  final CategoryUID categoryUID;

  @override
  List<Object> get props => [categoryUID];
}

class StocksChange extends StocksEvent {
  const StocksChange(this.categoryUID, {required this.stock});

  final CategoryUID categoryUID;
  final StockEntity stock;

  @override
  List<Object> get props => [categoryUID, stock];
}

class StocksAdd extends StocksEvent {
  const StocksAdd({required this.addParams, required this.addPrice});

  final StockDealParams addParams;
  final double addPrice;

  @override
  List<Object> get props => [addParams, addPrice];
}
