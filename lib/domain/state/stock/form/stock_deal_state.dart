part of 'stock_deal_bloc.dart';

class StockDealState extends Equatable {
  const StockDealState({
    this.count = const InputNum.pure(),
    this.price = const InputNum.pure(),
    this.status = FormValidStatus.empty,
    this.calcNewCount = -1,
    this.calcParams = -1,
    this.changedStock,
    this.errorMessage,
  });

  const StockDealState.success(StockEntity stock)
      : this(changedStock: stock, status: FormValidStatus.submitSuccess);

  final FormValidStatus status;
  final String? errorMessage;
  final InputNum count;
  final InputNum price;
  final double calcNewCount;
  final double calcParams;
  final StockEntity? changedStock;

  StockDealState copyWith(
      {InputNum? count,
      InputNum? price,
      FormValidStatus? status,
      String? errorMessage,
      double? calcNewCount,
      double? calcParams}) {
    return StockDealState(
      calcParams: calcParams ?? this.calcParams,
      calcNewCount: calcNewCount ?? this.calcNewCount,
      count: count ?? this.count,
      price: price ?? this.price,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, count, price];
}
