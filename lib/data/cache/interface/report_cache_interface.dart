import 'package:trading/core/types/types.dart';
import 'package:trading/data/model/report_api_params.dart';

abstract class ReportCache {
  Future<ReportApiParams?> getPeriod(CategoryUID categoryUID);
  Future<void> setPeriod(ReportApiParams params);
}
