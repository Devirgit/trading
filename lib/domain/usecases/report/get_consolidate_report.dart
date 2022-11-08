import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/report_entity.dart';
import 'package:trading/domain/entitis/report_params.dart';
import 'package:trading/domain/repository/report_repository.dart';

class GetConsolidateReport extends UseCase<CommonReportEntity, ReportParams> {
  GetConsolidateReport(ReportRepository repository) : _repository = repository;
  final ReportRepository _repository;

  @override
  Future<Respons<Failure, CommonReportEntity>> call(ReportParams params) async {
    return await _repository.getReport(params);
  }
}
