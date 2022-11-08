import 'package:trading/data/api/interface/report_service_interface.dart';
import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/model/detail_report_model.dart';
import 'package:trading/data/model/report_api_params.dart';
import 'package:trading/data/model/report_model.dart';
import 'package:dio/dio.dart';

class BegetReportService implements ReportService {
  BegetReportService(this.token);

  final String token;

  @override
  Future<DetailReportListModel> getDetailReport(
      DetailReportApiParams params) async {
    final options = RequestOptions(
        path: params.cursor ??
            'category/${params.categoryUID}/report/'
                'stock/${params.start}/${params.end}/all',
        method: 'GET',
        headers: {'Authorization': 'Bearer $token'});

    return await BegetBase().request(options, fullResult: true, (item) {
      return DetailReportListModel.fromJson(item as Map<String, dynamic>);
    });
  }

  @override
  Future<ReportModel> getReport(ReportApiParams params) async {
    final options = RequestOptions(
        path: 'report',
        method: 'GET',
        queryParameters: params.toJson(),
        headers: {'Authorization': 'Bearer $token'});
    return await BegetBase().request(options, (item) {
      return ReportModel.fromJson(item as Map<String, dynamic>);
    });
  }
}
