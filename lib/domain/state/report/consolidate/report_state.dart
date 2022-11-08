part of 'report_bloc.dart';

class ReportState extends Equatable {
  const ReportState(
      {this.reports = const {},
      this.status = LoadDataStatus.none,
      this.changetItemUID,
      this.errorMessage});

  final Map<int, CommonReportEntity> reports;
  final LoadDataStatus status;
  final String? errorMessage;
  final int? changetItemUID;

  ReportState copyWith({
    LoadDataStatus? status,
    Map<int, CommonReportEntity>? reports,
    String? errorMessage,
    int? changetItemUID,
  }) {
    return ReportState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      changetItemUID: changetItemUID ?? this.changetItemUID,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status];
}
