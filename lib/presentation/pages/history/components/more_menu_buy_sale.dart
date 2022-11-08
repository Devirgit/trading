import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/forms/form_buy_sale.dart';
import 'package:flutter/material.dart';

class MoreMenuBuySale extends StatelessWidget {
  const MoreMenuBuySale(this.stock, {Key? key, this.onSuccess})
      : super(key: key);

  final StockEntity? stock;
  final ValueChanged<StockEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    final enabledBuy = stock != null ? true : false;
    final enabledSell = stock != null ? (stock!.count > 0) : false;

    return PopupMenuButton<DealType>(
        iconSize: 24,
        padding: const EdgeInsets.only(left: 8.0),
        tooltip: '${UItext.buy} / ${UItext.sell}',
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onSelected: ((value) {
          if (stock != null) {
            final initData = StockDealParams(
                categoryUID: stock!.categoryUID,
                count: stock!.count,
                price: stock!.price,
                symbol: stock!.symbol,
                symbolID: stock!.symbolID,
                stockUID: stock!.uid);
            Forms.show(
                context,
                ModalFormBuySale(
                  initData,
                  currentPrice: stock!.currentPrice,
                  actionType: value,
                  onSuccess: (formContext, data) {
                    if ((onSuccess != null) && (data != null)) {
                      onSuccess!(data);
                    }
                    Forms.close(context);
                  },
                ));
          }
        }),
        itemBuilder: (context) => <PopupMenuEntry<DealType>>[
              PopupMenuItem<DealType>(
                value: DealType.buy,
                enabled: enabledBuy,
                child: const Text(UItext.buy),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<DealType>(
                value: DealType.sell,
                enabled: enabledSell,
                child: const Text(UItext.sell),
              ),
            ]);
  }
}
