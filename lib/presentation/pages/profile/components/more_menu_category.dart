import 'package:trading/common/ui_text.dart';
import 'package:flutter/material.dart';

enum MenuCategory { edit, delete }

class MoreMenuCategory extends StatelessWidget {
  const MoreMenuCategory({this.onSelected, Key? key}) : super(key: key);

  final PopupMenuItemSelected<MenuCategory>? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuCategory>(
        tooltip: UItext.menuEdit,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onSelected: onSelected,
        itemBuilder: (context) => <PopupMenuEntry<MenuCategory>>[
              const PopupMenuItem<MenuCategory>(
                value: MenuCategory.edit,
                child: Text(UItext.menuEdit),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<MenuCategory>(
                value: MenuCategory.delete,
                child: Text(UItext.menuDelete),
              ),
            ]);
  }
}
