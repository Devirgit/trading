part of 'deals_bloc.dart';

abstract class DealsEvent extends Equatable {
  const DealsEvent(this.stockUID);
  final StockUid stockUID;

  @override
  List<Object> get props => [stockUID];
}

class LoadDealsEvent extends DealsEvent {
  const LoadDealsEvent(StockUid stockUID) : super(stockUID);
}

class ReloadDealsEvent extends DealsEvent {
  const ReloadDealsEvent(StockUid stockUID) : super(stockUID);
}

class FilterDealsEvent extends DealsEvent {
  const FilterDealsEvent(StockUid stockUID, this.filterIndex) : super(stockUID);

  final int filterIndex;
}
