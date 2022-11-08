part of 'data_list_bloc.dart';

class DataListState<T> extends Equatable {
  const DataListState({
    this.status = LoadDataStatus.none,
    this.items = const [],
    this.cursor,
    this.search,
    this.errorMessage,
  });

  final LoadDataStatus status;
  final List<T> items;
  final String? search;
  final String? cursor;
  final String? errorMessage;

  bool get isEnd => cursor == null && status != LoadDataStatus.none;
  bool get isNotEnd => !isEnd;

  DataListState<T> copyWith({
    LoadDataStatus? status,
    List<T>? items,
    String? cursor,
    String? search,
    String? errorMessage,
  }) {
    return DataListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      search: search ?? this.search,
      cursor: cursor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  const DataListState.reload() : this(status: LoadDataStatus.none);

  const DataListState.search(
    String search,
  ) : this(
          search: search,
          status: LoadDataStatus.none,
        );

  @override
  List<Object> get props => [items, status];
}
