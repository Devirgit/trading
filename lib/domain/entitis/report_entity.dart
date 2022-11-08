import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  const ReportEntity(
      {required this.investing,
      required this.allProfit,
      required this.avgInvest,
      required this.avgNegativePnl,
      required this.avgPositivePnl,
      required this.maxProfit,
      required this.minProfit,
      required this.sumNegativePnl,
      required this.sumPositivePnl});

  final double investing;
  final double avgInvest;
  final double sumPositivePnl;
  final double avgPositivePnl;
  final double sumNegativePnl;
  final double avgNegativePnl;
  final double allProfit;
  final double maxProfit;
  final double minProfit;

  @override
  List<Object> get props => [
        investing,
        avgInvest,
        sumPositivePnl,
        avgPositivePnl,
        sumNegativePnl,
        avgNegativePnl,
        allProfit,
        maxProfit,
        minProfit
      ];
}

class CommonReportEntity extends Equatable {
  const CommonReportEntity(
      {required this.endPeriod,
      required this.report,
      required this.startPeriod});

  final DateTime startPeriod;
  final DateTime endPeriod;
  final ReportEntity report;

  @override
  List<Object> get props => [
        startPeriod,
        endPeriod,
        report,
      ];
}
