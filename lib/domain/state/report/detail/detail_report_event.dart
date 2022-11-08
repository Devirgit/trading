part of 'detail_report_bloc.dart';

abstract class DetailReportEvent extends Equatable {
  const DetailReportEvent();
  @override
  List<Object> get props => [];
}

class DetailReportMoreEvent extends DetailReportEvent {
  const DetailReportMoreEvent();
}

class DetailReportLoadEvent extends DetailReportEvent {
  const DetailReportLoadEvent(
      {required this.categoryUID,
      required this.startPeriod,
      required this.endPeriod});

  final DateTime startPeriod;
  final DateTime endPeriod;
  final CategoryUID categoryUID;

  @override
  List<Object> get props => [startPeriod, endPeriod, categoryUID];
}
