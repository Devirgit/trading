import 'dart:async';

import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/domain/usecases/stock/get_stock_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'stocks_event.dart';
part 'stocks_state.dart';

class StocksBloc extends Bloc<StocksEvent, StocksState> {
  StocksBloc(
      {required GetStockCategory getStock, Stream<RequestBuyStock>? buySymbol})
      : _getStock = getStock,
        super(const StocksState.init()) {
    on<StocksLoad>(_onStockLoad);
    on<StocksChange>(_onStockChange);
    on<StocksAdd>(_onAddStock);
    _actionSubscription = buySymbol?.listen(_requestBuyStock);
  }

  final GetStockCategory _getStock;
  StreamSubscription<RequestBuyStock>? _actionSubscription;

  void _requestBuyStock(RequestBuyStock event) {
    if (event is AddStock) {
      _addStock(event);
    }
    if (event is ChangeStock) {
      add(StocksChange(event.categoryUID, stock: event.stock));
    }
  }

  void _addStock(AddStock event) {
    try {
      final findStock = state.stocks.firstWhere(
        (element) => element.symbolID == event.symbol.symbolID,
      );
      add(StocksAdd(
          addParams: StockDealParams(
              categoryUID: findStock.categoryUID,
              count: findStock.count,
              price: findStock.price,
              stockUID: findStock.uid,
              symbol: event.symbol.name,
              symbolID: event.symbol.symbolID),
          addPrice: event.symbol.price));
    } catch (e) {
      add(StocksAdd(
          addParams: StockDealParams(
              categoryUID: event.categoryUID,
              count: 0,
              price: event.symbol.price,
              stockUID: -1,
              symbol: event.symbol.name,
              symbolID: event.symbol.symbolID),
          addPrice: event.symbol.price));
    }
  }

  @override
  Future<void> close() {
    _actionSubscription?.cancel();
    return super.close();
  }

  StocksState _prepareStockListEmit(List<StockEntity> stocks) {
    double calcProfit = 0;
    double calcInvesting = 0;
    for (final StockEntity item in stocks) {
      calcProfit += item.profit;
      calcInvesting += item.count * item.price;
    }
    return StocksState.success(stocks,
        profit: calcProfit, investing: calcInvesting);
  }

  Future<void> _onAddStock(
    StocksAdd event,
    Emitter<StocksState> emit,
  ) async {
    emit(state.copyWith(
        addStockParams: event.addParams, addStockPrice: event.addPrice));
  }

  Future<void> _onStockLoad(
    StocksLoad event,
    Emitter<StocksState> emit,
  ) async {
    emit(const StocksState.loading());

    final stock = _getStock(event.categoryUID);

    await emit.forEach(
      stock,
      onData: (Respons<Failure, List<StockEntity>> items) =>
          items.result((error) {
        if (state.stocks.isNotEmpty) {
          return state.copyWith(
              errorMessage: error.message, status: LoadDataStatus.failure);
        }
        return StocksState.error(error.message);
      }, (stocks) => _prepareStockListEmit(stocks)),
    );
  }

  Future<void> _onStockChange(
    StocksChange event,
    Emitter<StocksState> emit,
  ) async {
    emit(state.copyWith(status: LoadDataStatus.changed));
    List<StockEntity> stocks = state.stocks;
    final stockIndex =
        stocks.indexWhere((element) => element.uid == event.stock.uid);
    if ((event.stock.count == 0) && (stockIndex >= 0)) {
      stocks.removeAt(stockIndex);
      return emit(_prepareStockListEmit(stocks));
    }

    if (stockIndex >= 0) {
      stocks[stockIndex] = event.stock;
    } else {
      if (stocks.isEmpty) {
        stocks = [event.stock];
      } else {
        stocks.add(event.stock);
      }
    }

    emit(_prepareStockListEmit(stocks));
  }
}
