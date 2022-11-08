part of 'deals_bloc.dart';

class DealsState extends Equatable {
  const DealsState({
    this.status = LoadDataStatus.none,
    this.items = const [],
    this.filterIndex = 0,
    this.cursor,
    this.errorMessage,
  });

  final LoadDataStatus status;
  final List<DealEntity> items;
  final String? cursor;
  final String? errorMessage;
  final int filterIndex;

  bool get isEnd => cursor == null && status != LoadDataStatus.none;
  bool get isNotEnd => !isEnd;

  DealsState copyWith({
    LoadDataStatus? status,
    List<DealEntity>? items,
    int? filterIndex,
    String? cursor,
    String? errorMessage,
  }) {
    return DealsState(
      status: status ?? this.status,
      items: items ?? this.items,
      filterIndex: filterIndex ?? this.filterIndex,
      cursor: cursor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  const DealsState.reload() : this(status: LoadDataStatus.none);

  @override
  List<Object> get props => [status, filterIndex];
}
