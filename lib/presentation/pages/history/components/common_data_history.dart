import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/pages/history/components/more_menu_buy_sale.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:trading/presentation/widgets/data_with_label.dart';
import 'package:flutter/material.dart';

class CommonDataHistory extends StatelessWidget {
  const CommonDataHistory({Key? key, this.stock, this.onChange})
      : super(key: key);
  final StockEntity? stock;
  final ValueChanged<StockEntity>? onChange;

  @override
  Widget build(BuildContext context) {
    Widget icon = stock != null
        ? Image.network(
            Di.get<String>(name: 'iconURL') + stock!.iconUri,
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/default/stock.png",
              width: 32,
              height: 32,
            ),
          )
        : Image.asset(
            "assets/default/stock.png",
            width: 32,
            height: 32,
          );

    Widget header = Text(
      stock?.symbol ?? UItext.stockActiv,
      style: const TextStyle(
        fontSize: 20.0,
        color: UIColor.h1Color,
        fontWeight: FontWeight.w600,
      ),
    );

    return BoxDecor.header(
      iconHeader: icon,
      header: header,
      action: SizedBox(
          width: 32,
          height: 32,
          child: MoreMenuBuySale(stock, onSuccess: onChange)),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ColumnData([
                    _DataColor(
                        labelID: 'volume',
                        value: stock != null ? stock!.count : '?'),
                    _DataColor(
                      labelID: 'margin',
                      value: stock != null ? stock!.margin : '?',
                    )
                  ]),
                  Expanded(
                    child: _ColumnData([
                      _DataColor(
                        labelID: 'avg_price',
                        value: stock != null ? stock!.price : '?',
                      ),
                      _DataColor(
                          labelID: 'current_price',
                          value: stock != null ? stock!.currentPrice : '?'),
                    ]),
                  ),
                  _ColumnData([
                    _DataColor(
                        labelID: 'pnl',
                        color: true,
                        value: stock != null ? stock!.pnl : '?'),
                    _DataColor(
                      color: true,
                      labelID: 'profit',
                      value: stock != null ? stock!.profit : '?',
                    ),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}

class _DataColor {
  _DataColor(
      {required dynamic value, required String labelID, bool color = false})
      : label = UItext.historyFields[labelID] ?? '',
        colorData = value is double ? _colorValue(value, color) : null,
        data = value is double ? ViewFormat.formatCostDisplay(value) : '?';

  final Color? colorData;
  final String label;
  final String data;

  static Color? _colorValue(double value, bool color) {
    if (color) {
      return value > 0
          ? UIColor.positivPositionColor
          : UIColor.negativePositionColor;
    }
    return null;
  }
}

class _ColumnData extends StatelessWidget {
  const _ColumnData(this.data, {Key? key}) : super(key: key);
  final List<_DataColor> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataWithLabel(
            label: data[0].label,
            data: data[0].data,
            dataStyle: TextStyle(color: data[0].colorData)),
        const SizedBox(
          height: 15,
        ),
        DataWithLabel(
          label: data[1].label,
          data: data[1].data,
          dataStyle: TextStyle(color: data[1].colorData),
        ),
      ],
    );
  }
}
