import 'package:trading/data/model/report_api_params.dart';
import 'package:trading/domain/entitis/report_params.dart';

class ReportMapper {
  static DetailReportApiParams toDetailApi(DetaiReportParams item) {
    final end = DateTime.now();
    final start = DateTime(end.year, end.month - 1, end.day);

    return DetailReportApiParams(item.categoryUID,
        start: item.start ?? start, end: item.end ?? end, cursor: item.cursor);
  }
}
