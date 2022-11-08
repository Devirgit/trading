import 'package:trading/core/types/types.dart';
import 'package:trading/data/cache/hive/hive_base.dart';
import 'package:trading/data/cache/interface/report_cache_interface.dart';
import 'package:trading/data/model/report_api_params.dart';

class HiveReportCache implements ReportCache {
  static const _reportPeriodKey = 'report_period_';

  @override
  Future<ReportApiParams?> getPeriod(CategoryUID categoryUID) async {
    final period = await HiveBase().read(
        HiveBase.stateAppCache, _reportPeriodKey + categoryUID.toString());
    if (period != null) {
      return ReportApiParams(categoryUID, start: period[0], end: period[1]);
    } else {
      return period;
    }
  }

  @override
  Future<void> setPeriod(ReportApiParams params) async {
    final data = [params.start, params.end];
    return await HiveBase().write(data,
        boxName: HiveBase.stateAppCache,
        keyName: _reportPeriodKey + params.categoryUID.toString());
  }
}
