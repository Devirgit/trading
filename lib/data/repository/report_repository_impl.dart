import 'package:trading/core/error/crud_server_failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/data/api/interface/report_service_interface.dart';
import 'package:trading/data/cache/interface/report_cache_interface.dart';
import 'package:trading/data/mapper/report_mapper.dart';
import 'package:trading/data/model/detail_report_model.dart';
import 'package:trading/data/model/report_api_params.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/domain/entitis/report_entity.dart';
import 'package:trading/domain/entitis/report_params.dart';
import 'package:trading/domain/repository/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  ReportRepositoryImpl(
      {required this.reportService, required this.reportCache});

  final ReportService reportService;
  final ReportCache reportCache;

  Future<Respons<Failure, T>> _catchData<T>(ResultFunction<T> onAction,
      {ErrorFunction<Failure, T>? catchResult}) async {
    try {
      return Right(await onAction());
    } on ServerException catch (e) {
      if (catchResult != null) {
        return await catchResult(e);
      }
      return Left(CRUDServerFailure.fromType(e.type));
    }
  }

  @override
  Future<Respons<Failure, CommonReportEntity>> getReport(
      ReportParams params) async {
    DateTime? end = params.end;
    DateTime? start = params.start;
    if (end == null || start == null) {
      final cache = await reportCache.getPeriod(params.categoryUID);
      if (cache != null) {
        end = cache.end;
        start = cache.start;
      } else {
        end = DateTime.now();
        start = DateTime(end.year, end.month - 1, end.day);
      }
    } else {
      reportCache.setPeriod(
          ReportApiParams(params.categoryUID, end: end, start: start));
    }

    final ReportApiParams bodyRequest =
        ReportApiParams(params.categoryUID, end: end, start: start);

    return await _catchData(
      () async {
        final report = await reportService.getReport(bodyRequest);

        return CommonReportEntity(
            report: report,
            endPeriod: bodyRequest.end,
            startPeriod: bodyRequest.start);
      },
    );
  }

  @override
  Future<Respons<Failure, DetailReportListModel>> getDetailReport(
      DetaiReportParams params) async {
    final bodyRequest = ReportMapper.toDetailApi(params);
    return await _catchData(
      () async => await reportService.getDetailReport(bodyRequest),
    );
  }
}
