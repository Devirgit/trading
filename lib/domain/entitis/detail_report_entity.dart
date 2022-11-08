import 'package:equatable/equatable.dart';

class DetailReportEntity extends Equatable {
  const DetailReportEntity(
      {required this.iconUri,
      required this.pnl,
      required this.symbol,
      required this.deals,
      required this.symbolID,
      required this.uid});

  final String symbol;
  final String symbolID;
  final String iconUri;
  final double pnl;
  final int deals;
  final int uid;

  @override
  List<Object?> get props => [uid, symbol, symbolID, iconUri, pnl, deals];
}
