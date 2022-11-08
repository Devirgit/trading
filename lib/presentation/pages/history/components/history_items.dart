import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/circle_progress.dart';
import 'package:trading/presentation/widgets/data_with_label.dart';
import 'package:flutter/material.dart';

class HistoryItems extends StatelessWidget {
  const HistoryItems(this.deal, {Key? key}) : super(key: key);

  final DealEntity deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          gradient: deal.type == DealType.sell
              ? UIColor.negativeHistoryGradient
              : UIColor.positiveHistoryGradient,
          border: Border.all(
              color: deal.type == DealType.sell
                  ? UIColor.negativeHistoryStrok
                  : UIColor.positiveHistoryStroke)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  ViewFormat.formatingDate(deal.date),
                  style: const TextStyle(
                      color: UIColor.fontColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(ViewFormat.formatingTime(deal.date),
                    style: const TextStyle(
                        color: UIColor.fontColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 20.0,
                ),
                Text(deal.type == DealType.sell ? UItext.sell : UItext.buy,
                    style: TextStyle(
                        color: deal.type == DealType.sell
                            ? UIColor.negativePositionColor
                            : UIColor.positivPositionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(children: [
              CircleProgress(
                radius: 21,
                progress: deal.volume,
                color: deal.type == DealType.sell
                    ? UIColor.negativeProgress
                    : UIColor.positiveProgress,
                strokeColor: deal.type == DealType.sell
                    ? UIColor.negativeProgressSTR
                    : UIColor.positiveProgressSTR,
              ),
              const SizedBox(height: 5.0),
              DataWithLabel(
                label: UItext.pnl,
                data: deal.pnl == 0
                    ? '-'
                    : ViewFormat.formatCostDisplay(
                        deal.pnl,
                      ),
              ),
            ]),
          ),
          Expanded(
              child: Column(
            children: [
              DataWithLabel(
                label: UItext.priceSH,
                data: ViewFormat.formatCostDisplay(
                  deal.price,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              DataWithLabel(
                label: UItext.volumeSH,
                data: ViewFormat.formatCostDisplay(
                  deal.count,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
