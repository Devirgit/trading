import 'package:trading/core/types/types.dart';

class ReportParams {
  ReportParams(this.categoryUID, {this.start, this.end});

  final DateTime? start;
  final DateTime? end;
  final CategoryUID categoryUID;
}

class DetaiReportParams extends ReportParams {
  DetaiReportParams(CategoryUID categoryUID,
      {required DateTime start, required DateTime end, this.cursor})
      : super(categoryUID, start: start, end: end);

  final String? cursor;
}
