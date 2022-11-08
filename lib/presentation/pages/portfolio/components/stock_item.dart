import 'package:trading/common/ui_colors.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:flutter/material.dart';

class StocklItem extends StatelessWidget {
  const StocklItem(this.item, {Key? key}) : super(key: key);

  final StockEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UIColor.accentColor,
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Image.network(
                Di.get<String>(name: 'iconURL') + item.iconUri,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/default/stock.png",
                  width: 32,
                  height: 32,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.symbol,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: UIColor.h2Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Кол.во: ${item.count}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: UIColor.h3Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          ViewFormat.formatCostDisplay(item.price,
                              patern: item.currentPrice),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: UIColor.h3Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          size: 14,
                          color: UIColor.h3Color,
                        ),
                        Text(
                          ViewFormat.formatCostDisplay(item.currentPrice),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: UIColor.h3Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ViewFormat.formatCostDisplay(item.margin),
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: UIColor.h2Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    ViewFormat.formatCostDisplay(item.profit),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: item.profit > 0
                          ? UIColor.positivPositionColor
                          : UIColor.negativePositionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${ViewFormat.formatCostDisplay(item.profit / item.margin * 100, patern: 0)}%",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: item.profit > 0
                          ? UIColor.positivPositionColor
                          : UIColor.negativePositionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
