import 'dart:async';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/usecases/stock/get_one_stock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'history_event.dart';
part 'history_state.dart';

class StockHistoryBloc extends Bloc<StockHistoryEvent, StockHistoryState> {
  StockHistoryBloc({required GetOneStock getStock})
      : _getStock = getStock,
        super(const StockHistoryState.init()) {
    on<LoadStockHistory>(
      _onLoadStock,
    );
    on<ChangeStockHistory>(
      _onChangeStock,
    );
  }

  final GetOneStock _getStock;

  Future<void> _onChangeStock(
    ChangeStockHistory event,
    Emitter<StockHistoryState> emit,
  ) async {
    emit(const StockHistoryState.loading());
    emit(StockHistoryState.success(event.stock));
  }

  Future<void> _onLoadStock(
    LoadStockHistory event,
    Emitter<StockHistoryState> emit,
  ) async {
    emit(const StockHistoryState.loading());
    final stock = await _getStock(event.stockUID);
    stock.result((error) => emit(StockHistoryState.error(error.message)),
        (data) {
      emit(StockHistoryState.success(data));
    });
  }
}
