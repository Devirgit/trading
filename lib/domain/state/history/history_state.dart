part of 'history_bloc.dart';

class StockHistoryState extends Equatable {
  const StockHistoryState._({
    this.status = LoadDataStatus.none,
    this.stock,
    this.errorMessage,
  });

  final LoadDataStatus status;
  final StockEntity? stock;
  final String? errorMessage;

  const StockHistoryState.init() : this._(status: LoadDataStatus.none);

  const StockHistoryState.error(String? message)
      : this._(status: LoadDataStatus.failure);

  const StockHistoryState.success(StockEntity stock)
      : this._(status: LoadDataStatus.success, stock: stock);

  const StockHistoryState.loading() : this._(status: LoadDataStatus.loading);

  @override
  List<Object> get props => [status];
}
