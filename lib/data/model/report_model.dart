import 'package:trading/domain/entitis/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel(
      {required double investing,
      required double allProfit,
      required double avgInvest,
      required double avgNegativePnl,
      required double avgPositivePnl,
      required double maxProfit,
      required double minProfit,
      required double sumNegativePnl,
      required double sumPositivePnl})
      : super(
            allProfit: allProfit,
            avgInvest: avgInvest,
            avgNegativePnl: avgNegativePnl,
            avgPositivePnl: avgPositivePnl,
            investing: investing,
            maxProfit: maxProfit,
            minProfit: minProfit,
            sumNegativePnl: sumNegativePnl,
            sumPositivePnl: sumPositivePnl);

  ReportModel.fromJson(Map<String, dynamic> map)
      : super(
            allProfit: map['all_profit'] * 1.0,
            avgInvest: map['avg_invest'] * 1.0,
            avgNegativePnl: map['avg_negative_pnl'] * 1.0,
            avgPositivePnl: map['avg_positive_pnl'] * 1.0,
            investing: map['investing'] * 1.0,
            maxProfit: map['max_profit'] * 1.0,
            minProfit: map['min_profit'] * 1.0,
            sumNegativePnl: map['sum_negative_pnl'] * 1.0,
            sumPositivePnl: map['sum_positive_pnl'] * 1.0);
}

class ReportPeriod {
  ReportPeriod(
      {required this.report,
      required this.endPeriod,
      required this.startPeriod});
  final ReportModel report;
  final DateTime endPeriod;
  final DateTime startPeriod;
}
