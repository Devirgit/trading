import 'package:trading/common/ui_colors.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';

class ListTileReport extends StatelessWidget {
  const ListTileReport(
      {Key? key,
      required this.cost,
      required this.icon,
      this.subTrail,
      this.onTap,
      required this.subTitle,
      required this.title})
      : super(key: key);

  final Widget icon;
  final String title;
  final String subTitle;
  final double cost;
  final String? subTrail;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color colorCost =
        cost > 0 ? UIColor.positivPositionColor : UIColor.negativePositionColor;
    return ItemListTile(
      leading: icon,
      title: title,
      subTitle: subTitle,
      onTap: onTap,
      trailing: Text(
        ViewFormat.formatCostDisplay(cost, patern: cost),
        style: TextStyle(
            color: colorCost, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subTraling: subTrail != null
          ? Text(
              subTrail ?? '',
              style: const TextStyle(
                  color: UIColor.h3Color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            )
          : const SizedBox(
              height: 16,
            ),
    );
  }
}
