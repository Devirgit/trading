import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/detail_report_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';
import 'package:trading/domain/entitis/report_params.dart';
import 'package:trading/domain/repository/report_repository.dart';

class GetDetailReport
    extends UseCase<PageListEntitis<DetailReportEntity>, DetaiReportParams> {
  GetDetailReport(ReportRepository repository) : _repository = repository;
  final ReportRepository _repository;

  @override
  Future<Respons<Failure, PageListEntitis<DetailReportEntity>>> call(
      DetaiReportParams params) async {
    return await _repository.getDetailReport(params);
  }
}
