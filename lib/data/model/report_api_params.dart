import 'package:trading/core/types/types.dart';

class ReportApiParams {
  ReportApiParams(this.categoryUID, {required this.start, required this.end});

  final DateTime start;
  final DateTime end;
  final CategoryUID categoryUID;

  Map<String, dynamic> toJson() {
    return {'begin': start, 'end': end, 'category_id': categoryUID};
  }
}

class DetailReportApiParams {
  DetailReportApiParams(this.categoryUID,
      {this.cursor, required this.start, required this.end});

  final DateTime start;
  final DateTime end;
  final int categoryUID;
  final String? cursor;

  Map<String, dynamic> toJson() {
    return {'begin': start, 'end': end, 'category_id': categoryUID};
  }
}
