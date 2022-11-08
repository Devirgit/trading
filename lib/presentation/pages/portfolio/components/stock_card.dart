import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/state/stock/stocks_bloc.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/forms/form_buy_sale.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/pages/portfolio/components/slide_actions.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:trading/presentation/pages/portfolio/components/stock_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StockCard extends StatelessWidget {
  const StockCard(
    this.category, {
    Key? key,
  }) : super(key: key);

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return BoxDecor.header(
      iconHeader: Icon(
        UIIcon.iconSet[category.icon],
        size: 32,
        color: UIColor.h1Color,
      ),
      header: _StockHeaderData(category),
      action: SizedBox(
        width: 32.0,
        height: 32.0,
        child: FloatingActionButton(
          heroTag: 'addSymbol${category.uid}',
          backgroundColor: UIColor.primaryColor,
          onPressed: () {
            context.go('/add/${category.uid}', extra: context);
          },
          child: const Icon(
            Icons.add,
            size: 24,
            color: UIColor.h1Color,
          ),
        ),
      ),
      child: const _StockDataView(),
    );
  }
}

class _StockHeaderData extends StatelessWidget {
  const _StockHeaderData(this.category, {Key? key}) : super(key: key);

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: UIColor.h1Color,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<StocksBloc, StocksState>(
          buildWhen: (previous, current) =>
              (previous.profit != current.profit) ||
              (previous.investing != current.investing),
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ViewFormat.formatCostDisplay(state.investing),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: UIColor.h3Color,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  ViewFormat.formatCostDisplay(state.profit),
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: state.profit > 0
                          ? UIColor.positivPositionColor
                          : UIColor.negativePositionColor),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 1),
                  height: 14,
                  width: 2,
                  color: UIColor.primaryColor,
                ),
                Text(
                  '${ViewFormat.formatCostDisplay(state.profit / state.investing * 100, patern: 0)}%',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: state.profit > 0
                          ? UIColor.positivPositionColor
                          : UIColor.negativePositionColor),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 1),
                  height: 14,
                  width: 2,
                  color: UIColor.primaryColor,
                ),
                Text(
                  category.currency.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: UIColor.h3Color,
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}

class _StockDataView extends StatelessWidget {
  const _StockDataView({Key? key}) : super(key: key);

  void _onBuySaleActiveStock(BuildContext context,
      {required DealType formType, required StockEntity stock}) {
    _actionForm(context,
        formType: formType,
        currentPrice: stock.currentPrice,
        params: StockDealParams(
            categoryUID: stock.categoryUID,
            count: stock.count,
            price: stock.price,
            symbol: stock.symbol,
            symbolID: stock.symbolID,
            stockUID: stock.uid));
  }

  void _actionForm(BuildContext context,
      {required DealType formType,
      required double currentPrice,
      required StockDealParams params}) {
    Forms.show(
        context,
        ModalFormBuySale(
          params,
          currentPrice: currentPrice,
          actionType: formType,
          onSuccess: (formContext, data) {
            if (data is StockEntity) {
              context
                  .read<StocksBloc>()
                  .add(StocksChange(data.categoryUID, stock: data));
            }
            Forms.close(formContext);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StocksBloc, StocksState>(
      listenWhen: (previous, current) =>
          (previous.addStockParams != current.addStockParams) &&
          (current.addStockPrice != -1),
      listener: (context, state) {
        _actionForm(context,
            currentPrice: state.addStockPrice,
            params: state.addStockParams,
            formType: DealType.buy);
      },
      child: BlocBuilder<StocksBloc, StocksState>(
        buildWhen: (previous, current) =>
            (previous.stocks.length != current.stocks.length) ||
            ((previous.status == LoadDataStatus.changed) &&
                (current.status == LoadDataStatus.success)),
        builder: (context, state) {
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.stocks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const Divider(),
                    SlideActions(
                      key: ValueKey<int>(index),
                      leftActionPane: Container(
                          color: UIColor.negativePositionColor,
                          padding: const EdgeInsets.only(left: 15),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              UItext.sell,
                              style: TextStyle(
                                  color: UIColor.h2Color,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      rightActionPane: Container(
                          color: UIColor.positivPositionColor,
                          padding: const EdgeInsets.only(right: 15),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              UItext.buy,
                              style: TextStyle(
                                  color: UIColor.h2Color,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      child: InkWell(
                        onTap: () {
                          context
                              .go('/history/?uid=${state.stocks[index].uid}');
                        },
                        child: StocklItem(state.stocks[index]),
                      ),
                      onAction: (ActionDirection action) {
                        _onBuySaleActiveStock(context,
                            formType: action == ActionDirection.right
                                ? DealType.buy
                                : DealType.sell,
                            stock: state.stocks[index]);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
