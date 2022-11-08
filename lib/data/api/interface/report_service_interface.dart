import 'package:trading/data/model/detail_report_model.dart';
import 'package:trading/data/model/report_api_params.dart';
import 'package:trading/data/model/report_model.dart';

abstract class ReportService {
  Future<ReportModel> getReport(ReportApiParams params);

  Future<DetailReportListModel> getDetailReport(DetailReportApiParams params);
}
