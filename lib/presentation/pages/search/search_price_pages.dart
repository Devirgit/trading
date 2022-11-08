import 'package:trading/common/ui_colors.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/price_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/data_list_widget.dart';
import 'package:trading/presentation/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPricePages extends StatelessWidget {
  const SearchPricePages({Key? key, required this.categoryUID})
      : super(key: key);

  final CategoryUID categoryUID;

  @override
  Widget build(BuildContext context) {
    return DataListWidget<PriceEntity>(
      getAllData: Di.get(name: 'GetAllPrice'),
      searchData: Di.get(name: 'SearchPrice'),
      itemBuilder: (context, index, item) => _PriceListItem(
        item[index],
        categoryUID: categoryUID,
      ),
    );
  }
}

class _PriceListItem extends StatelessWidget {
  const _PriceListItem(this.item, {Key? key, required this.categoryUID})
      : super(key: key);

  final PriceEntity item;
  final CategoryUID categoryUID;

  @override
  Widget build(BuildContext context) {
    final icon = Di.get<String>(name: 'iconURL') + item.iconUri;
    return ItemListTile(
      onTap: () {
        context.go('/');
        Di.get<AppState>()
            .add(AddStock(categoryUID: categoryUID, symbol: item));
      },
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
      title: item.name,
      subTitle: item.description,
      trailing:
          Text(ViewFormat.formatCostDisplay(item.price, patern: item.price)),
      subTraling: Text(
        item.source,
        style: const TextStyle(fontSize: 12, color: UIColor.h3Color),
      ),
    );
  }
}
