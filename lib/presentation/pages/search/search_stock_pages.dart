import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/data_list_widget.dart';
import 'package:trading/presentation/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchStockPages extends StatelessWidget {
  const SearchStockPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataListWidget<StockEntity>(
      getAllData: Di.get(name: 'GetStockHistory'),
      searchData: Di.get(name: 'SearchStockHistory'),
      itemBuilder: (context, index, item) => _StockListItem(item[index]),
      header: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                UItext.catHeader,
                style: TextStyle(fontSize: 12, color: UIColor.h3Color),
              ),
            ),
            Text(
              UItext.countDateHeader,
              style: TextStyle(fontSize: 12, color: UIColor.h3Color),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockListItem extends StatelessWidget {
  const _StockListItem(this.item, {Key? key}) : super(key: key);

  final StockEntity item;

  @override
  Widget build(BuildContext context) {
    final icon = Di.get<String>(name: 'iconURL') + item.iconUri;
    return ItemListTile(
      leading: Image.network(
        icon,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          "assets/default/stock.png",
          width: 24,
          height: 24,
        ),
      ),
      title: item.symbol,
      subTitle: item.categoryName,
      trailing: Text(
          ViewFormat.formatCostDisplay(item.count, patern: item.currentPrice)),
      subTraling: Text(
        ViewFormat.formatingDate(item.updateDate),
        style: const TextStyle(fontSize: 12, color: UIColor.h3Color),
      ),
      onTap: () => context.go('/history/?uid=${item.uid}'),
    );
  }
}
