import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/report_entity.dart';
import 'package:trading/domain/entitis/report_params.dart';
import 'package:trading/domain/state/bloc_transform.dart';
import 'package:trading/domain/usecases/report/get_consolidate_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({required GetConsolidateReport report})
      : _loadReport = report,
        super(const ReportState()) {
    on<LoadReport>(
      _onLoadReport,
      transformer: sequential(),
    );
    on<ChangePerriod>(
      _onChangePerriod,
    );
  }

  final GetConsolidateReport _loadReport;

  Future<void> _getData(
      {DateTime? start,
      DateTime? end,
      required CategoryUID categoryUID,
      required Function(ReportState state) onChangeState}) async {
    onChangeState(state.copyWith(
        status: LoadDataStatus.loading, changetItemUID: categoryUID));
    final reports =
        await _loadReport(ReportParams(categoryUID, start: start, end: end));
    reports.result(
        (error) => onChangeState(state.copyWith(
            status: LoadDataStatus.failure,
            changetItemUID: categoryUID,
            errorMessage: error.message)), (item) {
      Map<int, CommonReportEntity> reports = {};
      reports.addAll(state.reports);

      reports[categoryUID] = item;

      onChangeState(state.copyWith(
          status: LoadDataStatus.success,
          reports: reports,
          changetItemUID: categoryUID));
    });
  }

  Future<void> _onChangePerriod(
    ChangePerriod event,
    Emitter<ReportState> emit,
  ) async {
    await _getData(
      categoryUID: event.categoryUID,
      end: event.end,
      start: event.start,
      onChangeState: (state) => emit(state),
    );
  }

  Future<void> _onLoadReport(
    LoadReport event,
    Emitter<ReportState> emit,
  ) async {
    if (state.reports[event.categoryUID] == null) {
      await _getData(
        categoryUID: event.categoryUID,
        onChangeState: (state) => emit(state),
      );
    } else {
      emit(state.copyWith(
          changetItemUID: event.categoryUID, status: LoadDataStatus.success));
    }
  }
}
