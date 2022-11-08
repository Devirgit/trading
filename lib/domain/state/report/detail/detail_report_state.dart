part of 'detail_report_bloc.dart';

class DetailReportState extends Equatable {
  const DetailReportState(
      {this.reports = const [],
      this.status = LoadDataStatus.none,
      this.cursor,
      this.endPeriod,
      this.startPeriod,
      this.errorMessage});

  final List<DetailReportEntity> reports;
  final DateTime? startPeriod;
  final DateTime? endPeriod;
  final String? cursor;
  final LoadDataStatus status;
  final String? errorMessage;

  bool get isEnd => cursor == null && status != LoadDataStatus.none;
  bool get isNotEnd => !isEnd;

  DetailReportState copyWith({
    LoadDataStatus? status,
    String? cursor,
    DateTime? startPeriod,
    DateTime? endPeriod,
    List<DetailReportEntity>? reports,
    String? errorMessage,
  }) {
    return DetailReportState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      endPeriod: endPeriod ?? this.endPeriod,
      startPeriod: startPeriod ?? this.startPeriod,
      cursor: cursor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
