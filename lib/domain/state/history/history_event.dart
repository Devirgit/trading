part of 'history_bloc.dart';

abstract class StockHistoryEvent extends Equatable {
  const StockHistoryEvent(this.stockUID);
  final StockUid stockUID;

  @override
  List<Object> get props => [stockUID];
}

class LoadStockHistory extends StockHistoryEvent {
  const LoadStockHistory(StockUid stockUID) : super(stockUID);
}

class ChangeStockHistory extends StockHistoryEvent {
  ChangeStockHistory(
    this.stock,
  ) : super(stock.uid);
  final StockEntity stock;

  @override
  List<Object> get props => [stock];
}
