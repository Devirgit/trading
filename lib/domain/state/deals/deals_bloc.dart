import 'dart:async';

import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/domain/state/bloc_transform.dart';
import 'package:trading/domain/usecases/deal/get_deals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'deals_event.dart';
part 'deals_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

class DealsBloc extends Bloc<DealsEvent, DealsState> {
  DealsBloc({required GetDeals getAllData})
      : _getAllData = getAllData,
        super(const DealsState()) {
    on<LoadDealsEvent>(_onLoadDeals,
        transformer: throttleDroppable(_throttleDuration));
    on<ReloadDealsEvent>(_onReloadData);
    on<FilterDealsEvent>(_onFilterData);
  }

  final GetDeals _getAllData;

  Future<void> _onFilterData(
    FilterDealsEvent event,
    Emitter<DealsState> emit,
  ) async {
    emit(state.copyWith(filterIndex: event.filterIndex));
  }

  List<DealEntity> margeDeal(List<List<DealEntity>> items) {
    List<DealEntity> result = [];

    for (var price in items) {
      result.addAll(price);
    }
    return result;
  }

  Future<void> _onReloadData(
    ReloadDealsEvent event,
    Emitter<DealsState> emit,
  ) async {
    emit(const DealsState.reload());
    await _getListData(emit, event.stockUID);
  }

  Future<void> _onLoadDeals(
    LoadDealsEvent event,
    Emitter<DealsState> emit,
  ) async {
    await _getListData(emit, event.stockUID);
  }

  Future<void> _getListData(Emitter<DealsState> emit, int stockUID) async {
    if (state.isEnd) return;
    emit(state.copyWith(cursor: state.cursor, status: LoadDataStatus.loading));

    final dealList =
        await _getAllData(DealParams(stockUID, cursor: state.cursor));
    dealList.result(
        (error) => emit(state.copyWith(
            errorMessage: error.message,
            status: LoadDataStatus.failure)), (data) {
      if (data.items.isEmpty) {
        return emit(state.copyWith(status: LoadDataStatus.empty));
      }
      emit(state.copyWith(
          items: margeDeal([state.items, data.items]),
          cursor: data.nextPage,
          status: LoadDataStatus.success));
    });
  }
}
