import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/report_params.dart';
import 'package:trading/domain/usecases/report/get_detail_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading/domain/entitis/detail_report_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:trading/domain/state/bloc_transform.dart';

part 'detail_report_event.dart';
part 'detail_report_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

class DetailReportBloc extends Bloc<DetailReportEvent, DetailReportState> {
  DetailReportBloc({required GetDetailReport report})
      : _getReport = report,
        super(const DetailReportState()) {
    on<DetailReportMoreEvent>(_onMoreReport,
        transformer: throttleDroppable(_throttleDuration));
    on<DetailReportLoadEvent>(
      _onloadReport,
    );
  }

  final GetDetailReport _getReport;

  List<DetailReportEntity> margePrice(List<List<DetailReportEntity>> items) {
    List<DetailReportEntity> result = [];

    for (var price in items) {
      result.addAll(price);
    }
    return result;
  }

  Future<void> _getDataReport(
      DetaiReportParams params, Emitter<DetailReportState> emit) async {
    final reportList = await _getReport(params);
    reportList.result(
        (error) => emit(state.copyWith(
            endPeriod: params.end,
            startPeriod: params.start,
            errorMessage: error.message,
            status: LoadDataStatus.failure)), (report) {
      if (report.items.isEmpty) {
        emit(state.copyWith(
            endPeriod: params.end,
            startPeriod: params.start,
            status: LoadDataStatus.empty));
      }
      emit(state.copyWith(
          endPeriod: params.end,
          startPeriod: params.start,
          reports: margePrice([state.reports, report.items]),
          cursor: report.nextPage,
          status: LoadDataStatus.success));
    });
  }

  Future<void> _onMoreReport(
      DetailReportMoreEvent event, Emitter<DetailReportState> emit) async {
    if (state.isEnd) return;
    if (state.cursor == null) return;
    emit(state.copyWith(cursor: state.cursor, status: LoadDataStatus.loading));
    await _getDataReport(
        DetaiReportParams(0,
            end: state.endPeriod ?? DateTime.now(),
            start: state.startPeriod ?? DateTime.now(),
            cursor: state.cursor),
        emit);
  }

  Future<void> _onloadReport(
      DetailReportLoadEvent event, Emitter<DetailReportState> emit) async {
    emit(const DetailReportState(status: LoadDataStatus.loading));
    await _getDataReport(
        DetaiReportParams(event.categoryUID,
            start: event.startPeriod, end: event.endPeriod),
        emit);
  }
}
