part of 'stocks_bloc.dart';

class StocksState extends Equatable {
  const StocksState._(
      {this.status = LoadDataStatus.none,
      this.stocks = const [],
      this.errorMessage,
      this.profit = 0,
      this.investing = 0,
      this.addStockPrice = -1,
      this.addStockParams = const StockDealParams.empty()});

  final LoadDataStatus status;
  final List<StockEntity> stocks;
  final String? errorMessage;
  final double profit;
  final double investing;
  final StockDealParams addStockParams;
  final double addStockPrice;
  const StocksState.init() : this._();

  const StocksState.success(List<StockEntity> items,
      {required double profit, required double investing})
      : this._(
            stocks: items,
            profit: profit,
            investing: investing,
            status: LoadDataStatus.success);

  const StocksState.loading() : this._(status: LoadDataStatus.loading);

  const StocksState.error(String message)
      : this._(errorMessage: message, status: LoadDataStatus.failure);

  StocksState copyWith(
      {LoadDataStatus? status,
      List<StockEntity>? stocks,
      String? errorMessage,
      double? profit,
      StockDealParams? addStockParams,
      double? addStockPrice,
      double? investing}) {
    return StocksState._(
      addStockParams: addStockParams ?? this.addStockParams,
      errorMessage: errorMessage ?? this.errorMessage,
      addStockPrice: addStockPrice ?? this.addStockPrice,
      stocks: stocks ?? this.stocks,
      status: status ?? this.status,
      profit: profit ?? this.profit,
      investing: investing ?? this.investing,
    );
  }

  @override
  List<Object> get props => [status, stocks, profit, addStockParams];
}
