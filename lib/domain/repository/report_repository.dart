import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/domain/entitis/detail_report_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/report_entity.dart';
import 'package:trading/domain/entitis/report_params.dart';

abstract class ReportRepository {
  Future<Respons<Failure, CommonReportEntity>> getReport(ReportParams params);
  Future<Respons<Failure, PageListEntitis<DetailReportEntity>>> getDetailReport(
      DetaiReportParams params);
}
