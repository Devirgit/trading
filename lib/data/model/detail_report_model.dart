import 'package:trading/domain/entitis/detail_report_entity.dart';
import 'package:trading/domain/entitis/page_list_entitis.dart';

class DetailReportModel extends DetailReportEntity {
  const DetailReportModel(
      {required String iconURI,
      required double pnl,
      required String symbol,
      required int deals,
      required String symbolID,
      required int uid})
      : super(
            iconUri: iconURI,
            pnl: pnl,
            symbol: symbol,
            symbolID: symbolID,
            deals: deals,
            uid: uid);

  DetailReportModel.fromJson(Map<String, dynamic> map)
      : super(
            iconUri: map['icon_url'] as String,
            pnl: map['pnl'] * 1.0,
            symbol: map['symbol'] as String,
            symbolID: map['symbol_id'] as String,
            deals: map['deals'] as int,
            uid: map['id'] as int);
}

class DetailReportListModel extends PageListEntitis<DetailReportEntity> {
  const DetailReportListModel(List<DetailReportEntity> items,
      {String? nextPage, String? prevPage})
      : super(items, nextPage: nextPage, prevPage: prevPage);

  DetailReportListModel.fromJson(Map<String, dynamic> map)
      : super(_fromMap(map['data'] as List<dynamic>),
            prevPage: map['links']['prev'], nextPage: map['links']['next']);

  static List<DetailReportEntity> _fromMap(List<dynamic> items) {
    return items
        .map((e) => DetailReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
