import 'dart:async';

import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/search_params.dart';
import 'package:trading/domain/state/bloc_transform.dart';
import 'package:trading/domain/usecases/interface/data_list_operation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'data_list_event.dart';
part 'data_list_state.dart';

const _duration = Duration(milliseconds: 500);
const _throttleDuration = Duration(milliseconds: 100);

class DataListBloc<T> extends Bloc<ListDataEvent, DataListState<T>> {
  DataListBloc(
      {required GetDataUC getAllData, required SearchDataUC searchData})
      : _getAllData = getAllData,
        _searchData = searchData,
        super(DataListState<T>()) {
    on<LoadListData>(
      _onLoadData,
      transformer: throttleDroppable(_throttleDuration),
    );
    on<SearchChanged>(_onSearchChanged, transformer: debounce(_duration));
    on<ReloadListData>(_onReloadData);
  }

  final GetDataUC _getAllData;
  final SearchDataUC _searchData;

  List<T> margeData(List<List<T>> items) {
    List<T> result = [];

    for (var price in items) {
      result.addAll(price);
    }
    return result;
  }

  Future<void> _onSearchChanged(
    SearchChanged event,
    Emitter<DataListState<T>> emit,
  ) async {
    DataListState<T> newState;
    if (event.text == '') {
      newState = DataListState<T>();
    } else {
      newState = DataListState<T>.search(event.text);
    }
    emit(newState);
    await _getListData(emit);
  }

  Future<void> _onReloadData(
    ReloadListData event,
    Emitter<DataListState<T>> emit,
  ) async {
    emit(DataListState<T>.reload());
    await _getListData(emit);
  }

  Future<void> _onLoadData(
    LoadListData event,
    Emitter<DataListState<T>> emit,
  ) async {
    await _getListData(emit);
  }

  Future<void> _getListData(Emitter<DataListState<T>> emit) async {
    if (state.isEnd) return;
    emit(state.copyWith(cursor: state.cursor, status: LoadDataStatus.loading));

    final dataList = state.search == null
        ? await _getAllData(state.cursor)
        : await _searchData(SearchParams(state.search ?? '', state.cursor));
    dataList.result(
        (error) => emit(state.copyWith(
            errorMessage: error.message,
            status: LoadDataStatus.failure)), (data) {
      if (data.items.isEmpty) {
        emit(state.copyWith(status: LoadDataStatus.empty));
      }
      emit(state.copyWith(
          items: margeData([state.items, data.items]),
          cursor: data.nextPage,
          status: LoadDataStatus.success));
    });
  }
}
